include Auth::SessionsHelper
include SimpleFormHelper
include TranslationHelper

class Table::BaseTable

  attr_accessor :current_user, :columns, :insert_method

  def initialize(current_user)
    @current_user = current_user
    @columns = []
  end

end
