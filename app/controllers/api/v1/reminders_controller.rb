class Api::V1::RemindersController < Api::V1::BaseController
    acts_as_token_authentication_handler_for User

    before_action :set_reminder, only: [ :show, :update, :destroy ]

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
      })
      # on autorise @reminder pour Pundit
      authorize @reminder

      if @reminder.save
        # lors du save on part dans les validations du modele reminder
        render :json => @reminder.to_json
      else
        render_error
      end
    end

    def destroy
        @reminder.destroy
        head :no_content
        # No need to create a `destroy.json.jbuilder` view
    end

private

     def reminder_params
        puts "helloparams"
        params.require(:reminder).permit(:content, :type, :when)
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
