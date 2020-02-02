class DockQueue::BaseDockQueueForm < BasicRecordForm

  validate :status_before_change

  attr_accessor :valid_status_before_change

  delegate  :status, :status=,
            to: :@record

  def initialize(*)
    super
    @table_class = Table::DockRequestsIndexTable
    @page_class = Page::DockRequestsPage
    @valid_status_before_change = []
  end

  def status_fresh_check(modal)
    unless status_fresh?
      modal.error = true
      modal.error_msg = I18n.t("errors.stale.data")
      modal.secondary_error_msg = I18n.t("errors.stale.status",
        :record=> record.primary_reference,
        :status=> record.human_attribute_name("status.#{record.status}"))
    end
  end

  private

  def save
    ActiveRecord::Base.transaction do
      record.save!
      audit
    end
  end

  def create_audit_history_entry(**options)
    attributes = {:dock_request_id => record.id,
                  :company_id => record.company_id,
                  :user_id => current_user.id }.merge(options)
    DockQueue::DockRequestAuditHistory.create!(attributes)
  end

  def status_valid?(*args)
    args.include? record.status_was
  end

  def status_fresh?
    status_valid?(*valid_status_before_change)
  end

  def status_before_change
    unless status_fresh?
      errors.add(:status)
    end
  end

end
