desc "Envia o checkout na data do due transaction"
task :send_square => :environment do

  Client.all.each do |c|
    Apartment::Tenant.switch(c.tenant_name) do
      transactions = Transaction.where.not(order: nil).where(due:  Date.today, status: :pendent,payment_method: :square_credit)
      transactions.each do |t|
        begin
          t.send_square
        rescue

        end
      end
    end
  end
end

desc "Envia o email de confirmação do schedule"
task :send_mail_schedule => :environment do

  Schedule.send_schedule_mail

end

desc "Cria os customers na square"
task :square_customer => :environment do

  Customer.create_square_customers

end

desc "Realiza a cobrança no cartão do cliente na data correspondente"
task :square_card_pay => :environment do

  Client.all.each do |c|
    Apartment::Tenant.switch(c.tenant_name) do
      transactions = Transaction.where.not(order: nil).where(due:  Date.today, status: :pendent,payment_method: :square_card_on_file)
      transactions.each do |t|
        begin
          t.square_payment
        rescue

        end
      end
    end
  end

end