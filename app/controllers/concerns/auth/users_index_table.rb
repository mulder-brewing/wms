module Auth::UsersIndexTable
  private

  def table_array_hash
    array = []
    array << { name: :actions, edit_button: true, become_button: true }
    array << { name: :username, text_key: "auth/users.name.username" }
    array << { name: :company, text_key: "companies.company",
              send_chain: ["company", "name"] } if logged_in_app_admin?
    array << { name: :enabled, text_key_qualifier: :enabled }
  end
end
