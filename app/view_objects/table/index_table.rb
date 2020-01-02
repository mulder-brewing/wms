class Table::IndexTable < Table::BaseTable

  BODY_ID = "index-table-body"

  delegate :row_id, to: :class

  def body_id
    BODY_ID
  end

  def self.row_id(record)
    record.class.name.parameterize + "-" + record.id.to_s;
  end

end
