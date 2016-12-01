class SpotPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    return true
  end

  def show?
    return true
  end

  def create?
    true
  end

  def update?
    # record.user == user --> à modifier par user = ambassadeur
    true #--> utilisé pour les besoins de tests par Julie. A remplacer par ambassadeur
  end

  def destroy?
    record.user == user
  end
end
