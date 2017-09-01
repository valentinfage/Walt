class RemindersController < ApplicationController

  before_action :set_reminder, only: [:edit, :show, :update, :destroy]

  def new
    @reminder = Reminder.new
  end

  def create
    @reminder = Reminder.new(reminder_params)
    @reminder.user_id = current_user.id
    @reminder.jstime = Time.new(@reminder.date.year, @reminder.date.month,
                                @reminder.date.day, @reminder.time.hour,
                                @reminder.time.min).to_i * 1000
    if @reminder.save
      flash[:notice] = "Votre reminder à bien été ajouté"
      redirect_to reminders_path
    else
      render :new
    end
    # sendsms
  end

  def update
    if @reminder.update(reminder_params)
      flash[:notice] = "Votre reminder a bien été modifié"
      redirect_to reminders_path
    else
      render :edit
    end
  end

  def edit
      # flash[:notice] = "éditer votre projet"
      # redirect_to root_path
  end

  def destroy
    @reminder.destroy
    redirect_to reminders_path(current_user.reminders)
  end

  def index
    flash[:notice] = "Voici tous vos projets"
    @reminders = current_user.reminders
  end

  # def sendsms
  #   str = current_user.phone_number
  #   numberregex = str.sub!(/^0/, "33")
  #   # s = SmsFactor.sms("Hey 📆 ~> #{@reminder.content} | ❤️ ","'#{numberregex}'")
  #   puts ("Hey 📆 ~> #{@reminder.content} | ❤️ '#{numberregex}'")
  # end



private

  def set_reminder
    @reminder = Reminder.find(params[:id])
  end

  def reminder_params
    params.require(:reminder).permit(:date, :time, :recurrence, :day, :content)
  end
end
