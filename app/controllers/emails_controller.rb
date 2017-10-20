class EmailsController < ApplicationController
   acts_as_token_authentication_handler_for User

    before_action :set_email, only: [ :show, :update, :destroy, :sendsms ]

  def index
    flash[:notice] = "Voici tous vos emails"
    @emails = current_user.emails
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


