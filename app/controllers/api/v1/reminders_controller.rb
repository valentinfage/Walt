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
      # Parameters: {"type"=>"reminder", "when"=>"tomorow", "content"=>"pasta"}
        # @var_content = JSON.parse(params[:content])
        # @var_date = JSON.parse(params[:when])
        # @var_action = JSON.parse(params[:type])
        # render :json => params[:content]
        # Content-Type: application/JSON

        # @reminder = Reminder.new(reminder_params)
          # if @reminder.save
          #     render :json => @reminder,
          #     :when => true
          # else
          #     render :json => @reminder.error
          #     # render_error
          # end

        puts "hello"
        @reminder = Reminder.new(reminder_params)
        @reminder.user = current_user
        puts "hello1"
        time = check_time(params[:reminder][:when])
        puts "hello2"
        # reminder.date = time
        puts time


        @reminder.jstime = Time.new(@reminder.date.year, @reminder.date.month,
                                @reminder.date.day, @reminder.time.hour,
                                @reminder.time.min).to_i * 1000
        authorize @reminder
        if @reminder.save
            render :index, status: :created
            puts "hello3"
        else
            render_error
            puts "hello4"
        end
      puts "hello5"
    end

    def destroy
        @reminder.destroy
        head :no_content
        # No need to create a `destroy.json.jbuilder` view
    end

private

     def check_time(string)
      Chronic.parse ("f")

      puts string
      puts "hello6"
      return string
     end

     def reminder_params
        params.require(:reminder).permit(:content)
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
