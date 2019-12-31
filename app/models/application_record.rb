class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  attr_accessor :save_success

  after_save :update_save_boolean

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

  def self.select_options(company_id, record_id)
    options = enabled_where_company(company_id)
    unless record_id.nil?
      options = options.or(where(id: record_id))
    end
    return options
  end

  def self.disabled_where_company(current_company_id)
    where_company(current_company_id).disabled
  end

  # this is to uniquely id a table of records.
  def self.table_body_id
    self.name.pluralize.parameterize + "-table-body";
  end

  # this is the uniquely id a record in a table of record.
  def table_row_id
    self.class.name.parameterize + "-" + self[:id].to_s;
  end

  def self.record_name
    self.name.underscore.sub("/", "_")
  end

  def record_name
    self.class.record_name
  end

  def form_input_id(attribute)
    record_name + "_" + attribute.to_s
  end

  # this is the path to the view folder, ready to append filename or subfolder.
  def self.view_folder_path
    table_name + "/"
  end

  def title(type_s)
    table_name + ".title." + type_s
  end

  def modal_title
    table_name + ".title."
  end

  def self.table_name
    self.name.tableize
  end

  def table_name
    self.class.table_name
  end

  private
    # get only the digits from a string.
    def digits_only(string)
      string.to_s.scan(/\d/).join('')
    end

    # This helps in knowing whether save was successful in the controller, JS, or views.
    def update_save_boolean
      self.save_success = true
    end
end
