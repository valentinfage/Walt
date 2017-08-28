class ReminderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user) #pour recuperer les reminders de l'user en cours de session
      # scope.all # pour recuperer tous les reminders de tous les users.
    end
  end

  def update?
    record.user == user
  end

  def create?
    true
  end

  def destroy?
    record.user == user
  end
end
