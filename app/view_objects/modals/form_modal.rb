class Modals::FormModal < Modals::BaseModal

  attr_accessor :form

  def initialize(form)
    @form = form
  end

  def form?
    true
  end

end
