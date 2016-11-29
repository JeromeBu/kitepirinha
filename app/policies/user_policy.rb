class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    true
  end

  def edit?
    user == @user
  end

  def update?
    user == @user
  end
end
