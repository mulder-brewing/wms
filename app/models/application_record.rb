class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  attr_accessor :current_user
  attr_accessor :save_success

  validate :company_check, if: :current_user_pre_check

  after_save :update_save_boolean

  scope :enabled, -> { where(enabled: true) }
  scope :disabled, -> { where(enabled: false) }

  def self.where_company(company_id)
    where("company_id = ?", company_id)
  end

  def self.enabled_where_company(current_company_id)
    where_company(current_company_id).enabled
  end

  def self.disabled_where_company(current_company_id)
    where_company(current_company_id).disabled
  end

  # this is to uniquely id a table of records.
  def self.table_body_id
    self.name.tableize.dasherize + "-table-body";
  end

  # this is the uniquely id a record in a table of record.
  def table_row_id
    self.class.name.underscore.dasherize + "-" + self[:id].to_s;
  end

  # this is the path to the view folder, ready to append filename or subfolder.
  def self.view_folder_path
    self.name.tableize + "/"
  end

  private
    # get only the digits from a string.
    def digits_only(string)
      string.to_s.scan(/\d/).join('')
    end

    # check that the current user's company matches the company of this instance
    def company_check
      if company_id != current_user.company_id
        errors.add(:company_id, "doesn't match your company")
      end
    end

    # This helps in knowing whether save was successful in the controller, JS, or views.
    def update_save_boolean
      self.save_success = true
    end

    # Current user functions
    def current_user_is_set
      !current_user.nil?
    end

    def current_user_not_seed
      current_user != "seed"
    end

    def current_user_pre_check
      current_user_is_set && current_user_not_seed
    end
end
