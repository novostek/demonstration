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
  schedules = Schedule.where(send_mail: true, mail_sent: false)

  schedules.each do |s|
    if s.from_order?
      order = Order.find(s.origin_id)
      customer = order.current_estimate.customer
    else
      estimate = Estimate.find(s.origin_id)
      customer = estimate.customer
    end

    if customer.present?
      email = customer.get_main_email
      if email.present?
        DocumentMailer.with(schedule: s, customer: customer, emails: email).send_schedule_mail.deliver_now
        s.update(mail_sent: true)
      end
    end

  end


end