module SMS

  class Send < ApplicationService
    def initialize(**options)
      @phone_number = "+1" + options[:phone_number]
      @message = options[:message]
    end

    def call
      if !Rails.env.test?
        sns = Aws::SNS::Client.new(
          region: ENV["AWS_REGION"],
          access_key_id: ENV["AWS_ACCESS_KEY_ID"],
          secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
        )
        sns.set_sms_attributes(
          attributes: {
            "DefaultSenderID" => "MulderWMS",
            "DefaultSMSType" => "Transactional"
          }
        )
        sns.publish(
          phone_number: @phone_number,
          message: @message)
      end
    end
  end

end
