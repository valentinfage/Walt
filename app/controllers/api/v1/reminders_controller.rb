class Api::V1::RemindersController < Api::V1::BaseController
    acts_as_token_authentication_handler_for User

    before_action :set_reminder, only: [ :show, :update, :destroy, :sendsms ]

    def index
        @reminders = policy_scope(Reminder)
        # ici lors de l'index on fait appel à pundit pour verifier les authorisations
        # policy_scope renvoit donc sur reminder_policy.rb
    end

    def show
    end

    def update
        if @reminder.update(reminder_params)
            render :index
        else
            render_error
        end
    end

    def create
      # ici on create un reminder avec un hash dans laquelle on assigne les clés/valeurs recus en ajax par l'extension
      # a nos propres tables de notre DB. Donc content = les params de content reçu par ajax
      # Puis pour time: la valeur When part dans Chronic18n pour le parsing.
      @reminder = Reminder.new({
        content: reminder_params[:content],
        time: Chronic18n.parse(reminder_params[:when], :fr),
        user: current_user,
        # phone_notification: reminder_params[:phone_notification]
        # web_notification: reminder_params[:web_notification]
        # phone_number: reminder_params[:phone_number]
      })
      # on autorise @reminder pour Pundit
      authorize @reminder
      @reminder.user_id = current_user.id
      @state = State.new

      if @reminder.save
        # lors du save on part dans les validations du modele reminder
        render :json => @reminder.to_json
        @state.reminder_id = @reminder.id
        @state.save
        recurrence(@reminder)
      else
        render_error
      end
    end

    def recurrence(reminder)
      #on regarde si la phrase rentré par le user contient un mot type "tous" et "jours" pour assigner
      #la recurrence à daily, weekly, monthly, yearly
      recur = reminder_params[:when].downcase
      r = recur.scan(/[[:alpha:]](?:['\w]*[[:alpha:]])?/)
        if %w[tous tout every tou les all].any? { |tous| r.include?(tous) } &&
          %w[jours jour day days].any? { |jours| recur.include?(jours) }
          @reminder.recurrence = :Daily
        elsif %w[tous tout tou les all].any? { |tous| r.include?(tous) } &&
          %w[lundi lundis mardi mardis mercredi mercredis jeudi jeudis vendredi vendredis samedi samedis dimanche dimanches].any? { |jours| recur.include?(jours) }
          @reminder.recurrence = :Daily
        elsif %w[tous tout every tou les all].any? { |tous| r.include?(tous) } &&
          %w[monday tuesday wednesday thursday friday saturday sunday].any? { |jours| recur.include?(jours) }
          @reminder.recurrence = :Daily
        elsif %w[toutes toute very tous tout tou les all].any? { |tous| r.include?(tous) } &&
          %w[semaines semaine week weeks].any? { |semaines| recur.include?(semaines) }
          @reminder.recurrence = :Weekly
        elsif %w[tous tout tou every les all].any? { |tous| r.include?(tous) } &&
          %w[mois moi months month].any? { |month| recur.include?(month) }
          @reminder.recurrence = :Monthly
        elsif %w[tous tout tou every les all].any? { |tous| r.include?(tous) } &&
          %w[ans an années annes anne years year].any? { |year| recur.include?(year) }
          @reminder.recurrence = :Yearly
        else
          puts "Pas de recurrence à premiere vue"
        end
      @reminder.save
    end

    def destroy
        @reminder.destroy
        head :no_content
        # No need to create a `destroy.json.jbuilder` view
    end

private

     def reminder_params
        params.require(:reminder).permit(:content, :type, :when, :phone_notification, :web_notification, :phone_number)
     end

     def render_error
        render json: { errors: @reminder.errors.full_messages },
        status: :unprocessable_entity
     end

     def set_reminder
        @reminder = Reminder.find(params[:id])
        authorize @reminder # For Pundit
     end
end
