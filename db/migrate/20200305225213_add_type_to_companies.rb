class AddTypeToCompanies < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE company_type AS ENUM ('warehouse', 'shipper', 'admin');
    SQL
    add_column :companies, :company_type, :company_type, index: true
  end

  def down
    remove_column :companies, :company_type
    execute <<-SQL
      DROP TYPE company_type;
    SQL
  end
end
