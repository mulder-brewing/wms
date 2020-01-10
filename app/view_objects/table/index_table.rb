class Table::IndexTable < Table::BaseTable

  TABLE_CLASS = "index-table"
  HEAD_CLASS = "index-table-head"
  BODY_CLASS = "index-table-body"

  delegate :row_id, to: :class

  def table_class
    TABLE_CLASS
  end

  def head_class
    HEAD_CLASS
  end

  def body_class
    BODY_CLASS
  end

  def self.row_id(record)
    record.class.name.parameterize + "-" + record.id.to_s;
  end

end
