# == Schema Information
#
# Table name: transactions
#
#  id                      :uuid             not null, primary key
#  bpm_instance            :string
#  category                :string
#  due                     :date
#  effective               :datetime
#  email                   :string
#  origin                  :string
#  payment_method          :string
#  square_data             :json
#  status                  :string
#  value                   :decimal(, )
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  order_id                :uuid
#  origin_id               :string
#  purchase_id             :uuid
#  transaction_account_id  :uuid
#  transaction_category_id :uuid
#
# Indexes
#
#  index_transactions_on_order_id                 (order_id)
#  index_transactions_on_purchase_id              (purchase_id)
#  index_transactions_on_transaction_account_id   (transaction_account_id)
#  index_transactions_on_transaction_category_id  (transaction_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (purchase_id => purchases.id)
#  fk_rails_...  (transaction_account_id => transaction_accounts.id)
#  fk_rails_...  (transaction_category_id => transaction_categories.id)
#
class Transaction < ApplicationRecord
  belongs_to :transaction_category, optional:  true
  belongs_to :transaction_account, optional:  true
  belongs_to :order, optional:  true

  extend Enumerize

  enumerize :payment_method, in: [:cash, :square_credit, :square_installments, :check, :woffice_pay], predicates: true
  enumerize :status, in: [:paid, :pendent, :cancelled],predicates: true, default: :pendent

  default_scope {where.not(status: 'cancelled' )}

  #validates :category, :effective, :value, presence: true

  after_create :send_square
  before_save :set_default_categories

  def send_square
    if self.due == Date.today
      if self.square_credit?
        checkout_status, checkout_data = SquareApi.create_checkout(self.order, self)
        puts "status square #{checkout_status}"
        #binding.pry
        if checkout_status
          DocumentMailer.with(transaction: self,link: checkout_data[:checkout][:checkout_page_url] , emails: self.email, order: self.order).send_square.deliver_later
        else
          #redirect_to process_payment_customers_path
        end
      end
    end
  end

  def set_default_categories
    if self.origin == 'Order'
      if self.due == Date.today and (self.payment_method == 'cash' or self.payment_method == 'check')
        self.effective = Time.now
        self.status = :paid
      end
      self.transaction_account_id = Setting.get_value("#{self.payment_method}_transaction_account")
      self.transaction_category_id = Setting.get_value("#{self.payment_method}_transaction_category")
    elsif self.origin == 'LaborCost'
      self.transaction_account_id = Setting.get_value("labor_cost_transaction_account")
      self.transaction_category_id = Setting.get_value("labor_cost_transaction_category")
      self.value = -(self.value)
    elsif self.origin == 'ProductPurchase'
      product_purchase = ProductPurchase.find(self.origin_id)
      if product_purchase.tax
        self.value = -(self.value)
        self.transaction_account_id = Setting.get_value("taxes_transaction_account")
        self.transaction_category_id = Setting.get_value("taxes_transaction_category")
      else
        self.value = -(self.value)
        self.transaction_account_id = Setting.get_value("product_purchase_transaction_account")
        self.transaction_category_id = Setting.get_value("product_purchase_transaction_category")
      end
    end
  end

  def send_square_from_invoice
    checkout_status, checkout_data = SquareApi.create_checkout(self.order, self)
  end

  def mark_as_paid
    begin
      update(status: :paid, effective: DateTime.now)
    rescue
      false
    end
  end

  def self.get_finances type
    where("effective > now() - interval '1 year' AND value #{type == 'income' ? '>' : '<'} 0")
      .group('extract(month from effective)').sum(:value).map { |t| {
        'month_n': t[0].to_i,
        'month': Date::MONTHNAMES[t[0]],
        'value': t[1].to_f
      } }.sort_by { |f| f[:month_n] }
    # ).group('extract(month from created_at)').sum(:value).each do |t|
    #   puts t[0].to_i
    #   months[t[0].to_i() -1][:month_n] = t[0]
    #   months[t[0].to_i() -1][:month] = Date::MONTHNAMES[t[0]]
    #   months[t[0].to_i() -1][:value] = t[1].to_f
    # end

    # return months
  end

  def self.get_thirty_days_finances type
    where("effective > now() - interval '1 year' AND value #{type == 'income' ? '>' : '<'} 0")
      .group('extract(month from effective)').sum(:value).map { |t| {
        'month_n': t[0].to_i,
        'month': Date::MONTHNAMES[t[0]],
        'value': t[1].to_f
      } }.sort_by { |f| f[:month_n] }
  end

  def self.get_day_finances type
    where(
      "effective::date = ? AND value #{type == 'income' ? '>' : '<'} 0", 
      Time.now.strftime('%Y-%m-%d')
    ).sum(:value).to_f
  end

  def self.get_balance
    credit = where(
      'extract(year from effective) = ? AND value > 0', 
      Time.now.year
    ).group('extract(month from effective)').sum(:value).map { |t| {
      'month': Date::MONTHNAMES[t[0]],
      'value': t[1].to_f
    } }

    debit = where(
      'extract(year from effective) = ? AND value < 0', 
      Time.now.year
    ).group('extract(month from effective)').sum(:value).map { |t| {
      'month': Date::MONTHNAMES[t[0]],
      'value': t[1].to_f
    } }
    
    return {
      'debit' => debit,
      'credit' => credit
    }
  end

  def self.get_thirty_days_balance
    credit = where(
      'effective > now() - interval \'30 day\' AND value > 0', 
      Time.now.year
    ).group('extract(month from effective)').sum(:value).map { |t| {
      'month': Date::MONTHNAMES[t[0]],
      'value': t[1].to_f
    } }

    debit = where(
      'effective > now() - interval \'30 day\' AND value < 0', 
      Time.now.year
    ).group('extract(month from effective)').sum(:value).map { |t| {
      'month': Date::MONTHNAMES[t[0]],
      'value': t[1].to_f
    } }
    
    return {
      'debit' => debit,
      'credit' => credit
    }
  end

  def self.get_amount_of_receivables
    where('effective > now() - interval \'30 day\' AND value > 0 AND status = \'paid\'').sum(:value).to_f
  end

  def self.get_amount_of_overdue
    where('due > now() - interval \'30 day\' AND value > 0 AND status = \'pendent\'').sum(:value).to_f
  end
  
  def self.get_amount_of_open
    where('due < now() - interval \'30 day\' AND value > 0 AND status = \'pendent\'').sum(:value).to_f
  end
  
  def self.get_material_costs
    where('created_at > now() - interval \'30 day\' AND value < 0 AND origin = \'ProductPurchase\'').sum(:value).to_f
  end

  def self.get_labor_costs
    where('created_at > now() - interval \'30 day\' AND value < 0 AND origin = \'LaborCost\'').sum(:value).to_f
  end



end
