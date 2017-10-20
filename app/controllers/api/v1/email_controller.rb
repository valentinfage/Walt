class EmailController < ApplicationController
   acts_as_token_authentication_handler_for User

    before_action :set_email, only: [ :show, :update, :destroy, :sendsms ]

  def index
      @emails = policy_scope(Email)
      # ici lors de l'index on fait appel à pundit pour verifier les authorisations
      # policy_scope renvoit donc sur reminder_policy.rb
  end

  def show
  end

  def new
  end

  def create
    @email = Email.new({
        content: email_params[:content],
        object: email_params[:object],
        receiver: email_params[:receiver],
        user: current_user,
      })
      # on autorise @reminder pour Pundit
      authorize @email
      @email.user_id = current_user.id

      puts "hello"

      # if @email.save
      #   # lors du save on part dans les validations du modele reminder
      #   render :json => @email.to_json
      #   user = User.find(current_user.id)
      #   user.phone_number = reminder_params[:phone_number]
      #   user.save
      #   @state.reminder_id = @reminder.id
      #   @state.save
      #   recurrence(@reminder)
      # else
      #   render_error
      # end

      # mail = Mail.new do
      #   from     'alex'
      #   to       'noxx.sound@gmail.com'
      #   subject  'Here is the image you wanted'
      #   body     'Hey'
      # end
  end

  def edit
  end

  def update
  end

  def destroy
  end

private

     def email_params
        params.require(:email).permit(:content, :receiver, :object)
     end

     def render_error
        render json: { errors: @email.errors.full_messages },
        status: :unprocessable_entity
     end

     def set_email
        @email = Email.find(params[:id])
        authorize @email # For Pundit
     end
end


