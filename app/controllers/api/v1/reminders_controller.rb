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
            head :ok
        else
            render_error
        end
    end

    def create
        @reminder = Reminder.new(reminder_params)
        @reminder.user = current_user
        authorize @reminder
        if @reminder.save
            render :index, status: :created
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
        params.require(:reminder).permit(:date, :day, :time, :recurrence, :content, :user_id)
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
