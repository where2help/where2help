class ProgressBar::PeopleItem < ProgressBar::Item

  private

  def text
    I18n.t 'activerecord.attributes.shift.confirmed_so_far'
  end

  def css_class
    'progress-bar -people'
  end
end
