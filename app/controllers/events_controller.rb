class EventsController < InheritedResources::Base
  before_filter :authenticate_ngo!, only: :new

end
