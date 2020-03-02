module TableHelper

  def new_table(table_class)
    return table_class.new(current_user, self)
  end

  def new_table_prep_records(table_class)
    table = new_table(table_class)
    table.prep_records(params)
    return table
  end

  def authorize_records(table, **options)
    authorize table.records
  end

  def scope_records(table, **options)
    table.records = policy_scope(table.records, policy_scope_class: options[:scope_class])
  end

  def authorize_scope_records(table, **options)
    authorize_records(table, options)
    scope_records(table, options)
  end

  def render_table(table)
    respond_to do |format|
      format.js {
        render  :template => table.js_path,
                :locals => { table: table }
      }
    end
  end

end
