module LayoutsHelper
  def nav_link(link_text, link_path, klass:'')
    class_name = current_page?(link_path) ? 'active' : ''
    content_tag(:li, :class => class_name) do
      link_to link_text, link_path, class: klass
    end
  end
end