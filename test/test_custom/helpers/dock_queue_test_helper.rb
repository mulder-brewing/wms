module DockQueueTestHelper

  def assert_stale_alert(record)
    verify_alert_message(
      Constants::Alert::DANGER,
      I18n.t("errors.stale.data"),
      I18n.t(
        "errors.stale.status",
        record: record.primary_reference,
        status: record.human_attribute_name("status.#{record.status}")
      )
    )
  end

end
