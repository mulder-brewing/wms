class Auth::UserEditUpdateForm < Auth::UserForm

  delegate  :enabled, to: :@user

  def prep_record(params)
    @user = Auth::User.find(params[:id])
  end

  def view_path
    super(self.class.superclass)
  end

end
