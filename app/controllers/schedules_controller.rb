# frozen_string_literal: true

require "schedule/operation"

class SchedulesController < ApplicationController
  before_action :authenticate_user!

  def show
    @collection =
      ScheduleOperation::Index
      .present(filter: params[:filter], current_user: current_user)
      .model
      .page(params[:page])
  end
end
