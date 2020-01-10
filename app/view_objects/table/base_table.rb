class Table::BaseTable
  include Auth::SessionsHelper
  include SimpleFormHelper

  attr_accessor :current_user, :columns

  def initialize(current_user)
    @current_user = current_user
    @columns = []
  end

end
