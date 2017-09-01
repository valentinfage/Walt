class CheckSmsJob < ApplicationJob
  queue_as :default
  def perform(*args)
    Reminder
      .joins(:user)
      .where
      .not(users: { phone_number: nil })
      .where(reminders: { phone_notification: true })
      .joins(:state)
      .where(states: { status: false })
      .each do |reminder|
        #requete SQL qui selectionne les reminders de Users qui ont un num de tel dans la DB, qui ont coché web notif pour LE reminder ET dont le statut send sms n'est pas encore passé en true
        if reminder.time.to_i < DateTime.now.to_i # On compare le temps parsé par Chronic pour le reminder à l'heure actuel,
          str = reminder.user.phone_number
          numberregex = str.sub!(/^0/, "33") #ici on parse le numéro pour enlever le premier '0' du numéro de tel

          if sms_enabled?
            puts "Envoi du sms"
            SmsFactor.sms("Hey~> #{reminder.content} | Love", '0695930425')
          end

          # puts ("Hey 📆 ~> #{reminder.content} | ❤️ '#{numberregex}'")
          changestate(reminder) #On appelle la methode pour changer de statut
        else
          puts "c'est pas encore le moment d'envoyer un sms"
        end
      end
  end

  def changestate(reminder)
      reminder.state.status = true
      reminder.state.save
      #On indique que la notif du sms a bien été envoyé. Le statut du reminder passe donc en true.
  end

  def sms_enabled?
    ENV["SMS_ENABLED"] == "1"
  end
end

#le sms_enabled? est une telecommande qui permet de set un ENV (environnement)
#de manière à pouvoir activer ou désactiver l'envoi de sms sur heroku sans avoir besoin
#de rédployer le code. En effet la methode facile aurait été de commenter le code.
#pour activer sur heroku:
# heroku config:set SMS_ENABLED=0   ou heroku config:set SMS_ENABLED=1 pour activer

#pour faire la même chose en local:
#dans application.rb puis SMS_ENABLED: "0" ou SMS_ENABLED: "1" pour activer
#puis pour tester en local: rails c / CheckSmsJob.perform_now

#TODO
#cours sidekiq
#PROCFILE
#PUSH HEROKU

