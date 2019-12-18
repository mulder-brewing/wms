class NilClassPolicy < ApplicationPolicy

  def new?
    raise ApplicationController::RecordNotFound
  end

  def create?
    raise ApplicationController::RecordNotFound
  end

  def edit?
    raise ApplicationController::RecordNotFound
  end

  def update?
    raise ApplicationController::RecordNotFound
  end

  def index?
    raise ApplicationController::RecordNotFound
  end
end
