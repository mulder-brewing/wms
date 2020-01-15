class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  delegate :table_name, to: :class

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  NORMAL_LENGTH = 50
  EMAIL_LENGTH = 255

  scope :enabled, -> { where(enabled: true) }
  scope :disabled, -> { where(enabled: false) }

  def self.where_company(company_id)
    where("company_id = ?", company_id)
  end

  def self.where_enabled(enabled)
    where("enabled = ?", enabled)
  end

  def self.enabled_where_company(current_company_id)
    where_company(current_company_id).enabled
  end

  def self.disabled_where_company(current_company_id)
    where_company(current_company_id).disabled
  end

  def self.select_options(company_id, record_id)
    options = enabled_where_company(company_id)
    unless record_id.nil?
      options = options.or(where(id: record_id))
    end
    return options
  end

end
