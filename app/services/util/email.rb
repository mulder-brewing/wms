module Util::Email

  class SendPossible < ApplicationService
    def initialize(email, send_email)
      @email = email
      @send_email = send_email
    end

    def call
      @send_email = Util::Boolean::Cast.call(@send_email)
      return false if @email.blank? && @send_email
      return true
    end
  end

end
