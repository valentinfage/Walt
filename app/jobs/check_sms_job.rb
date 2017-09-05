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
         # On compare le temps parsé par Chronic pour le reminder à l'heure actuel,
         next unless reminder.time.to_i <= DateTime.now.to_i

        #requete SQL qui selectionne les reminders de Users qui ont un num de tel dans la DB,
        #qui ont coché web notif pour LE reminder ET dont le statut send sms n'est pas encore passé en true
        #On parse le numéro pour enlever le premier '0' du numéro de tel
        str = reminder.user.phone_number
        numberregex = str.sub!(/^0/, "33")
        case true

        when (reminder.recurrence == "Daily") # && !(reminder.recurrence.nil?)
           reminder.time = (Time.now + (60*60*24))
           puts "on lance lenvoi du sms daily"
           sms(reminder, numberregex)
          #TODO create a new reminder for the same hour the next day
        when (reminder.recurrence == "Weekly")
           reminder.time = (Time.now + (60*60*24)*7)
           puts "on lance lenvoi du sms weekly"
           sms(reminder, numberregex)
          #TODO create a new reminder for the same hour the next week
        when (reminder.recurrence == "Monthly")
           reminder.time = (Time.now + (60*60*24)*30)
           puts "on lance lenvoi du sms monthly"
           sms(reminder, numberregex)
          #TODO create a new reminder for the same hour the next month
        when (reminder.recurrence == "Yearly")
           reminder.time = (Time.now + (60*60*24)*364)
           puts "on lance lenvoi du sms yearly"
           sms(reminder, numberregex)
        #TODO create a new reminder for the same hour the next year
        else
           changestate(reminder.state) #On appelle la methode pour changer de statut
           sms(reminder, numberregex)
        end
        reminder.save
      end
  end

  def changestate(state)
      state.status = true
      state.save
     puts "le statut a changé"
      #On indique que la notif du sms a bien été envoyé. Le statut du reminder passe donc en true.
  end

  def sms(reminder, numberregex)
    if sms_enabled?
      Rails.logger.info "sms envoyé"
      # SmsFactor.sms("Hey~> #{reminder.content} | Love", "'#{numberregex}'")
    end
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
#dans application.yml puis SMS_ENABLED: "0" ou SMS_ENABLED: "1" pour activer
#puis pour tester en local: rails c / CheckSmsJob.perform_now


