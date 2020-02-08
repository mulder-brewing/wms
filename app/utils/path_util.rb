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

end
