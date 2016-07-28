class ProgressBar::MeItem < ProgressBar::Item

  def initialize(percentage=0, num=0)
    super percentage, smile
  end

  private

  def smile
    content_tag(:i, '', class: 'fa fa-smile-o')
  end

  def text
    I18n.t 'activerecord.attributes.shift.you'
  end

  def css_class
    'progress-bar -me'
  end
end
