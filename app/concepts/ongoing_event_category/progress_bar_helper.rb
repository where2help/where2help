module ProgressBarHelper
  def progress_bar(event)
    ProgressBar.new(
      progress: event.volunteers_count,
      total:    event.volunteers_needed
    )
  end
end
