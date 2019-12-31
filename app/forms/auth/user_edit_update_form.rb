class Auth::UserEditUpdateForm < Auth::UserForm

  delegate  :enabled, to: :@user

  def prep_record(params)
    @user = Auth::User.find(params[:id])
  end

  def submit(params)
    @user.attributes = params
    if valid?
      @user.save!
      @save_success = true
    else
      @save_success = false
    end
  end

  def view_path
    super(self.class.superclass)
  end

end
