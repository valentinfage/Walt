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
      # a nos propres tables de notre DB. Donc content = les params de content reçu par
      @reminder = Reminder.new({
        content: reminder_params[:content],
        time: Chronic18n.parse(reminder_params[:when], :fr),
        user: current_user,


      })
      authorize @reminder

      if @reminder.save

        @reminder.jstime = Time.new(@reminder.date.year, @reminder.date.month,
        @reminder.date.day, @reminder.time.hour,
        @reminder.time.min).to_i * 1000
        @reminder.save

        puts "hellosave"
        render :json => @reminder.to_json
      else
        puts "helloerror"
        render_error
      end



        # @reminder = Reminder.new(reminder_params)
        # @reminder.user = current_user
        # puts "hello1"
        # time = check_time(params[:reminder][:when])
        # puts "hello2"
        # # reminder.date = time
        # puts time




      #   if @reminder.save
      #       render :index, status: :created
      #       puts "hello3"
      #   else
      #       render_error
      #       puts "hello4"
      #   end
      # puts "hello5"
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
