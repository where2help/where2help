class ProgressBar
  attr_reader :items, :needed, :people

  def initialize(parent)
    @people = parent.volunteers_count
    @needed = parent.volunteers_needed
    @items = build_items
  end

  def to_partial_path
    'progress_bar/progress_bar'
  end

  private

  def build_items
    @people <= @needed ? people_missing : full_bar
  end

  def missing_item(size, me=0)
    missing = @needed - @people
    size = 100 - size - me
    Item.new size: size, num: missing, type: :missing
  end

  def needed_item(size)
    Item.new size: size, num: @needed-1, type: :needed
  end

  def full_item(size, me=0)
    surplus = @people - @needed
    size = 100 - size - me
    Item.new size: size, num: surplus, type: :needed
  end

  def people_missing
    raise NotImplementedError, "people_missing not implemented for #{self.class}"
  end

  def full_bar
    raise NotImplementedError, "full_bar not implemented for #{self.class}"
  end
end
