class Table::GenericTable

  attr_accessor :columns

  def initialize(column_array_hash)
    @columns = []
    column_array_hash.each do |column|
      new_column = Table::GenericTableColumn.new(
        column[:name],
        column[:text_key_qualifier] || :global
        )
      new_column.add_edit_button = true if column[:edit_button] == true
      new_column.add_become_button = true if column[:become_button] == true
      new_column.text_key = column[:text_key]
      new_column.send_chain = column[:send_chain]

      @columns << new_column
    end
  end

end
