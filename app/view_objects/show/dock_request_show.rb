class Show::DockRequestShow < Show::RecordShow

  def initialize(*)
    super
    @attributes.push(
      RA.new(label: han(:primary_reference), value: record.primary_reference),
      RA.new(label: han(:status), value: han("status.#{record.status}")),
      RA.new(label: DockGroup.model_name.human, value: record.dock_group.description),
      RA.new(label: han(:phone_number), value: number_to_phone(record.phone_number, area_code: true)),
      RA.new(label: han(:text_message), value: BooleanUtil.yes_no(record.text_message)),
      RA.new(label: han(:note), value: record.note),
      RA.new(label: han("status.checked_in"), value: record.created_at)
    )
    unless record.status_voided?
      @attributes.push(
        RA.new(label: han("status.dock_assigned"), value: record.dock_assigned_at),
        RA.new(label: Dock.model_name.human, value: record.dock_number_if_assigned),
        RA.new(label: han("status.checked_out"), value: record.checked_out_at),
      )
    end
    if record.status_voided?
      @attributes << RA.new(label: han("status.voided"), value: record.voided_at)
    end
    @attributes << RA.new(label: han(:total_time), value: record.total_time)

  end
end
