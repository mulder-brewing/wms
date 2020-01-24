class Page::IndexListPage < Page::BasePage

  attr_accessor :records

  SHARED_PATH = "shared/page/"
  INDEX_HTML_PATH = SHARED_PATH + "index"
  PAGINATION_HTML_PATH = SHARED_PATH + "pagination"
  ENABLED_FILTER_HTML_PATH = SHARED_PATH + "enabled_filter"
  RECORD_HTML_PATH = SHARED_PATH + "record"
  ACTION_BAR_CLASS = "index-action-bar"

  attr_accessor :table, :enabled_param, :new_record, :show_new_link,
    :show_enabled_filter

  def initialize(*)
    super
    @show_new_link = true
    @show_enabled_filter = true
  end

  def prep_records(params)
    @records = controller_model.all
    @new_record = controller_model.new
    if show_enabled_filter?
      enabled = Util::Boolean.cast(params[:enabled])
      @records = @records.where_enabled(enabled) unless enabled.nil?
      @enabled_param = enabled
    end
    return @records
  end

  def render_path
    INDEX_HTML_PATH
  end

  def pagination_html_path
    PAGINATION_HTML_PATH
  end

  def enabled_filter_html_path
    ENABLED_FILTER_HTML_PATH
  end

  def record_html_path
    RECORD_HTML_PATH
  end

  def action_bar_class
    ACTION_BAR_CLASS
  end

  def title
    if !@title.blank?
      I18n.t(@title)
    else
      @records.model.model_name.human(count: 2)
    end
  end

  def show_new_link?
    @show_new_link
  end

  def show_enabled_filter?
    @show_enabled_filter
  end

  def button_class(button)
    case button
    when :all
      @enabled_param.nil? ? "btn-primary" : "btn-secondary"
    when :enabled
      @enabled_param ? "btn-primary" : "btn-secondary"
    when :disabled
      @enabled_param == false ? "btn-primary" : "btn-secondary"
    end
  end
end
