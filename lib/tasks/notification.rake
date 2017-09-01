namespace :notification do
  desc 'check sms notification every 15 seconds'
  task checksms: :environment do
    Reminder.joins(:user).where.not(users: { phone_number: nil }).where(reminders: { phone_notification: true }).joins(:state).where(states: { status: false }).each do |reminder|
      if reminder.time.to_i < DateTime.now.to_i
        str = reminder.user.phone_number
        numberregex = str.sub!(/^0/, "33")
        # s = SmsFactor.sms("hey", '0634343434')
        puts ("Hey 📆 ~> #{reminder.content} | ❤️ '#{numberregex}'")
        changestate(reminder)
      else
        puts "c'est pas encore le moment d'envoyer un sms"
      end
    end
  end
end

def changestate(reminder)
  reminder.state.status = true
  reminder.state.save
end
