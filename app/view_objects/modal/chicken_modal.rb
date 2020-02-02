class Modal::ChickenModal < Modal::FormRecordModal

  attr_accessor :chicken_msg_target

  def form?
    false
  end

  def render_record
    nil
  end

  def render_path
    if form.post_submit?
      Modal::FormRecordModal::SAVE_RESULT_PATH
    else
      Modal::FormRecordModal::JS_PATH
    end
  end

  def chicken_message(action)
    I18n.t("modal.chicken_message", :action=> action, :target=> chicken_msg_target)
  end

end
