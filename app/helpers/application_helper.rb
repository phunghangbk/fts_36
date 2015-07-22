module ApplicationHelper
  def full_title page_title = ""
    base_title = I18n.t "ruby"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def link_to_remove_fields label, f
    field = f.hidden_field :_destroy
    link = link_to label, "#", onclick: "remove_fields(this)", remote: true
    field + link
  end
  
  def link_to_add_fields label, f, assoc
    new_obj = f.object.class.reflect_on_association(assoc).klass.new
    fields = f.fields_for assoc, new_obj,child_index: "new_#{assoc}" do |builder|
      render "#{assoc.to_s.singularize}_fields", f: builder
    end
    link_to label, "#", onclick: "add_fields(this, \"#{assoc}\",
      \"#{escape_javascript(fields)}\")", remote: true
  end

  def bootstrap_class_for flash_type
    {
      success: t("alertsuccess"),
      error: t("alertdanger"),
      alert: t("alertwarning"), 
      notice: t("alertinfo")
    }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages opts = {}
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} 
        alert-dismissible", role: "alert") do
          concat(content_tag(:button, class: "close", data: {dismiss: "alert"}) do
            concat content_tag :span, "&times;".html_safe, "aria-hidden" => true
            concat content_tag :span, "Close", class: "sr-only"
          end)
          concat message
      end)
    end
    nil
  end
end
