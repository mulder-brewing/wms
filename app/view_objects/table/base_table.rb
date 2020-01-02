class Table::BaseTable
  include Auth::SessionsHelper

  attr_accessor :current_user, :columns

  def initialize(current_user)
    @current_user = current_user
    @columns = []
  end

end
