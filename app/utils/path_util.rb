

module PathUtil

  def self.path(path, **args)
    Rails.application.routes.url_helpers.send(path, args)
  end

  def self.show(record)
    Rails.application.routes.url_helpers.polymorphic_url(record,
      routing_type: :path)
  end

  def self.new(record)
    Rails.application.routes.url_helpers.polymorphic_url(record,
      routing_type: :path, action: :new)
  end

  def self.edit(record)
    Rails.application.routes.url_helpers.polymorphic_url(record,
      routing_type: :path, action: :edit)
  end

  def self.record(record)
    Rails.application.routes.url_helpers.polymorphic_url(record,
      routing_type: :path)
  end

  def self.controller_action(controller, action, **args)
    options = {
      only_path: true,
      controller: controller,
      action: action
    }.merge(args)
    Rails.application.routes.url_helpers.url_for(options)
  end

end
