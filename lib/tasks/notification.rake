namespace :notification do
  desc 'check sms notification every 15 seconds'
  task checksms: :environment do
      Reminder.joins(:user).where.not(users: { phone_number: nil }).each do |reminder|
        # binding.pry
        if reminder.time.to_i < DateTime.now.to_i
          str = reminder.user.phone_number
          numberregex = str.sub!(/^0/, "33")
          # s = SmsFactor.sms("hey", '0634343434')
          # puts ("Hey 📆 ~> #{reminder_params[:content]} | ❤️ '#{numberregex}'")
          puts ("Hey 📆 ~> #{reminder.content} | ❤️ '#{numberregex}'")

        else
          puts "c'est pas encore le moment"
        end
    end
  end
end
