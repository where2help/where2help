class ProgressBar::Item
  include ActionView::Helpers::TagHelper

  def initialize(width:, amount: nil, type:)
    @width = "width: #{width}%"
    @amount = amount
    @type = type
  end

  def render
    content_tag(:div, text, class: css_class, style: @width)
  end

  private

  attr_reader :width, :amount, :type

  def css_class
    @css_class ||= "progress-bar -#{type}"
  end

  def text
    desc = I18n.t "activerecord.attributes.shift.#{type.to_s}"
    "#{amount || smiley} #{desc}".html_safe
  end

  def smiley
    content_tag(:i, '', class: 'fa fa-smile-o')
  end
end
