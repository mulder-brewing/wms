module Concerns::Auth::ValidateUser

  private

  def user_valid
    unless @user.valid?
      errors.merge!(@user.errors)
    end
  end

end
