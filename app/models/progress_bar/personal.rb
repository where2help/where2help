class ProgressBar::Personal < ProgressBar

  private

  def people_missing
    items = []
    me = (100.0 / @needed).ceil
    percentage = (100.0 * (@people - 1) / @needed).ceil

    items << Item.new(size: me, type: :you)
    items << Item.new(size: percentage, num: @people, type: :people)
    items << missing_item(percentage, me)
  end

  def full_bar
    items = []
    me = (100.0 / @people).ceil
    percentage = (100.0 * (@needed - 1) / @people).ceil

    items << Item.new(size: me, type: :you)
    items << needed_item(percentage)
    items << full_item(percentage, me)
  end
end
