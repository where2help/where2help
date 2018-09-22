class ProgressBar
  def initialize(progress:, total:, offset: 0)
    @progress = progress.to_i
    @total    = total
    @offset   = offset
  end

  # This will be used for rendering purposes
  def items
    @items ||= build_items
  end

  def to_partial_path
    'progress_bar/progress_bar'
  end

  private

  attr_reader :progress, :total, :offset

  # Each of these represent a part of the final progress bar
  def build_items
    items = []
    items << offset_item unless offset.zero?
    items << progress_item
    items << rest_item
  end

  def offset_item
    Item.new(width: offset_pct, type: :offset)
  end

  def progress_item
    amount = [@progress, @total].min - @offset
    Item.new(width: progress_pct, amount: amount, type: :progress)
  end

  def rest_item
    min, max = [@progress, @total].minmax
    amount = max - min
    Item.new(width: rest_pct, amount: amount, type: rest_type)
  end

  def rest_type
    @progress > @total ? :full : :rest
  end

  def progress_pct
    min, max = [@progress, @total].minmax
    if max != 0
      (100.0 * (min - @offset) / max).ceil
    else
      0
    end
  end

  def rest_pct
    100 - progress_pct - offset_pct
  end

  def offset_pct
    return 0 if @offset.zero?

    total = [@progress, @total].max
    (100.0 / total).ceil
  end
end
