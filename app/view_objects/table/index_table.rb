class Table::IndexTable < Table::BaseTable

  BODY_ID = "index-table-body"

  def body_id
    BODY_ID
  end

  def row_id(record)
    record.class.name.parameterize + "-" + record.id.to_s;
  end

end
