class Current < ActiveSupport::CurrentAttributes
  attribute :user, :access_policy
end
