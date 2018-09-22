class IcalFile < BaseService
  def initialize(item: nil, attendee: nil)
    @item = item
    @attendee = attendee
    if item.is_a?(Event)
      @title, @desc = item.title, item.description
      @address = item.address
    elsif item.is_a?(Shift)
      @title, @desc = item.event.title, item.event.description
      @address = item.event.address
    else
      raise ArgumentError, 'Invalid item type'
    end
  end

  def call
    cal.export
  end

  private

  attr_reader :item, :attendee, :title, :desc, :address

  def cal
    RiCal.Calendar do |cal|
      cal.event do |event|
        event.summary      = @title
        event.description  = @desc
        event.dtstart      = @item.starts_at
        event.dtend        = @item.ends_at
        event.location     = @address
        event.url          = polymorphic_url(@item, host: host)
        event.add_attendee @attendee.try(:email)
        event.alarm do |alarm|
          alarm.description = @title
        end
      end
    end
  end
end
