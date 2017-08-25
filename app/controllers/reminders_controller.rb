class RemindersController < ApplicationController

  before_action :set_reminder, only: [:edit, :show, :update, :destroy]

  def new
    @reminder = Reminder.new
  end

  def create
    @reminder = Reminder.new(reminder_params)
    @reminder.user_id = current_user.id
    if @reminder.save
      flash[:notice] = "Votre reminder à bien été ajouté"
      redirect_to reminders_path
    else
      render :new
    end
  end

  def edit
  end

  def destroy
    @reminder.destroy
    redirect_to reminders_path(current_user.reminders)
  end

  def index
    @reminders = current_user.reminders
  end

private

  def set_reminder
    @reminder = Reminder.find(params[:id])
  end

  def reminder_params
    params.require(:reminder).permit(:date, :time, :recurrence, :day, :content)
  end
end
