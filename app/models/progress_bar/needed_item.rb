class ProgressBar::NeededItem < ProgressBar::Item

  private

  def text
    I18n.t 'activerecord.attributes.shift.needed'
  end

  def css_class
    'progress-bar -people'
  end
end
