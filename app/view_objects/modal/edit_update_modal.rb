class Modal::EditUpdateModal < Modal::FormRecordModal

  def initialize(*)
    super
    @role = :edit_update
    @save_result = Table::SaveResult::UPDATE
    @footer = Modal::Footer::EditUpdateFooter.new(@form)
    @title_suffix = "edit_update"
  end

  def views_path
    VIEWS_PATH + "edit_update_modal/"
  end

  def timestamps_path
    views_path + "timestamps"
  end

end
