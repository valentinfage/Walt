# namespace :notification do
#   desc 'check sms notification every 1 minute'
#   task checksms: :environment do
#     Reminder.joins(:user).where.not(users: { phone_number: nil }).where(reminders: { phone_notification: true }).joins(:state).where(states: { status: false }).each do |reminder|
#       #requete SQL qui selectionne les reminders de Users qui ont un num de tel dans la DB, qui ont coché web notif pour LE reminder ET dont le statut send sms n'est pas encore passé en true
#       if reminder.time.to_i < DateTime.now.to_i # On compare le temps parsé par Chronic pour le reminder à l'heure actuel,
#         str = reminder.user.phone_number
#         numberregex = str.sub!(/^0/, "33") #ici on parse le numéro pour enlever le premier '0' du numéro de tel
#         # s = SmsFactor.sms("hey", '0634343434')
#         puts ("Hey 📆 ~> #{reminder.content} | ❤️ '#{numberregex}'")
#         changestate(reminder) #On appelle la methode pour changer de statut
#       else
#         puts "c'est pas encore le moment d'envoyer un sms"
#       end
#     end
#   end
# end

# def changestate(reminder)
#   reminder.state.status = true
#   reminder.state.save
#   #On indique que la notif du sms a bien été envoyé. Le statut du reminder passe donc en true.
# end
