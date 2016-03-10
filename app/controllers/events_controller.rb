class EventsController < ApplicationController
  before_filter :authenticate_ngo!, only: :new

  def new
  end
end
