class ProgressBar::Item
  include ActionView::Helpers::TagHelper

  def initialize(percentage=0, num=0)
    @txt = "#{num} #{text}"
    @css = css_class
    @size = "width: #{percentage}%"
  end

  attr_reader :txt, :css, :size

  def render
    content_tag :div, @txt.html_safe, class: @css, style: @size
  end

  def text_for(section)
    # sections: you
    I18n.t "activerecord.attributes.shift.#{section}"
  end

  def text
    raise NotImplementedError, "text not implemented for #{self.class}"
  end

  def css_class
    raise NotImplementedError, "css_class not implemented for #{self.class}"
  end
end
