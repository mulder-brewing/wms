class Modals::EditUpdateModal < Modals::FormRecordModal

  def initialize(*)
    super
    @role = :edit_update
    @footer = Modals::Footers::EditUpdateFooter.new
  end

  def views_path
    VIEWS_PATH + "edit_update_modal/"
  end

  def timestamps_path
    views_path + "timestamps"
  end

  def title
    super + "edit_update"
  end


end
