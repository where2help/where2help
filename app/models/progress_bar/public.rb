class ProgressBar::Public < ProgressBar
  
  private

  def people_missing
    items = []
    percentage = (100.0 * @people / @needed).ceil

    items << Item.new(size: percentage, num: @people, type: :people)
    items << missing_item(percentage)
  end

  def full_bar
    items = []
    percentage = (100.0 * @needed / @people).ceil

    items << Item.new(size: percentage, num: @people, type: :people)
    items << full_item(percentage)
  end
end
