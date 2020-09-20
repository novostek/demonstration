class CustomerExporter < RailsExporter::Base
  require 'csv'

  exporter do
    column :name
    column :category
    column :document_id
    column :since
    column :code
    column :birthdate => :date
    column("#{I18n.t('texts.client.onboard.main_phone')}") {|record| record.get_main_phone_f }
    column("#{I18n.t('texts.client.onboard.main_email')}") {|record| record.get_main_email_f }
    column("#{I18n.t('texts.client.onboard.main_address')}") {|record| record.get_main_address_f || I18n.t('no_address')}
    column(:created_at) { |record| record.created_at.strftime("%m/%d/%Y %H:%M") }
    column(:updated_at) { |record| record.updated_at.strftime("%m/%d/%Y %H:%M") }
    column :bpm_instance
    column :square_id
  end

end