class Api::V1::EmailsController < Api::V1::BaseController
   acts_as_token_authentication_handler_for User

    before_action :set_email, only: [ :show, :index, :update, :destroy, :sendsms ]

  def index
      @emails = policy_scope(Email)
      # ici lors de l'index on fait appel à pundit pour verifier les authorisations
      # policy_scope renvoit donc sur reminder_policy.rb
  end

  def show
  end

  def create
    @email = Email.new({
        content: email_params[:content],
        # object: email_params[:object],
        user: current_user,
        phone_notification: reminder_params[:phone_notification],
        web_notification: reminder_params[:web_notification]
      })
      # on autorise @reminder pour Pundit
      authorize @email
      @email.user_id = current_user.id

  end

  def update
    if @email.update(email_params)
        render :index
    else
        render_error
    end
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


