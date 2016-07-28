class ProgressBar::Item
  include ActionView::Helpers::TagHelper

  def initialize(size: 0, num: nil, type: :you)
    @txt = text(num, type)
    @css = "progress-bar -#{type.to_s}"
    @size = "width: #{size}%"
  end

  def render
    content_tag :div, @txt.html_safe, class: @css, style: @size
  end

  private

  attr_reader :txt, :css, :size

  def text(num, type)
    num ||= smile
    desc = I18n.t "activerecord.attributes.shift.#{type.to_s}"
    "#{num} #{desc}"
  end

  def smile
    content_tag(:i, '', class: 'fa fa-smile-o')
  end
end
