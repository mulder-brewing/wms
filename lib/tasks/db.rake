# using structure.sql but want to see schema as well.
Rake::Task["db:migrate"].enhance do
  if ActiveRecord::Base.schema_format == :sql
    Rake::Task["db:schema:dump"].invoke
  end
end
