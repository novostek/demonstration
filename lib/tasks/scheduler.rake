desc "Envia o checkout na data do due transaction"
task :send_square => :environment do
  transactions = Transaction.where.not(order: nil).where(due:  Date.today, status: :pendent,payment_method: :square_credit)
  transactions.each do |t|
    begin
      t.send_square
    rescue

    end
  end
end

desc "Envia o email de confirmação do schedule"
task :send_mail_schedule => :environment do

  Schedule.send_schedule_mail

end