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

  Customeer.create_square_customers

end