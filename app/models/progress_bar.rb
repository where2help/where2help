class ProgressBar
  include ActionView::Helpers::TagHelper

  def initialize(parent, me=false)
    @people = parent.volunteers_count
    @needed = parent.volunteers_needed
    @items = []
    me ? personal_bar : public_bar
  end

  def to_partial_path
    'progress_bar/progress_bar'
  end

  attr_reader :items, :needed, :people

  private

  def personal_bar
    if @people <= @needed
      me = (100.0 / @needed).ceil
      percentage = (100.0 * (@people - 1) / @needed).ceil

      @items << ProgressBar::YouItem.new(me)
      @items << ProgressBar::PeopleItem.new(percentage, @people)
      @items << missing_item(percentage, me)
    else
      me = (100.0 / @people).ceil
      percentage = (100.0 * (@needed - 1) / @people).ceil

      @items << ProgressBar::YouItem.new(me)
      @items << needed_item(percentage)
      @items << full_item(percentage, me)
    end
  end

  def public_bar
    if @people <= @needed
      percentage = (100.0 * @people / @needed).ceil

      @items << ProgressBar::PeopleItem.new(percentage, @people)
      @items << missing_item(percentage)
    else
      percentage = (100.0 * @needed / @people).ceil

      @items << ProgressBar::PeopleItem.new(percentage, @people)
      @items << full_item(percentage)
    end
  end

  def missing_item(percentage, me=0)
    missing = @needed - @people
    percentage = 100 - percentage - me
    ProgressBar::MissingItem.new percentage, missing
  end

  def needed_item(percentage)
    ProgressBar::NeededItem.new percentage, @needed-1
  end

  def full_item(percentage, me=0)
    surplus = @people - @needed
    percentage = 100 - percentage - me
    ProgressBar::NeededItem.new percentage, surplus
  end
end
