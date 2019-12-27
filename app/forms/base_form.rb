class BaseForm
  include ActiveModel::Model
  include Auth::SessionsHelper
  include FindObjectHelper

  attr_accessor :id, :current_user, :save_success

  delegate :record_name, to: :class

  def title(type_s)
    self.model_name.to_s.underscore + ".title." + type_s
  end

  def self.record_name
    self.model_name.to_s.underscore.sub("/", "_")
  end

end
