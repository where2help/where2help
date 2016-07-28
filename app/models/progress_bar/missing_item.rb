class ProgressBar::MissingItem < ProgressBar::Item

  private

  def text
    I18n.t 'activerecord.attributes.shift.missing'
  end

  def css_class
    'progress-bar -missing'
  end
end
