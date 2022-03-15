require "ongoing_event/user_operation"
require "ongoing_event_category/user_operation"
require "event/block"

class OngoingEventsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_event, only: [:show]
  before_action :redirect_blocked_unless_participating, only: [:show]

  def index
    @ongoing_event_categories = []

    if params[:ongoing_event_category_id].present?
      @operation = OngoingEventOperation::User::Index.present(
        ongoing_event_category_id: params[:ongoing_event_category_id],
        user: current_user,
      )
      @events = @operation.model.page(params[:page].to_i - 1).offset(3)
    else
      @operation =
        OngoingEventCategoryOperation::User::Index.present(user: current_user)
      @ongoing_event_categories = @operation.model

      @category_events = (@ongoing_event_categories.each_with_object({}) do |category, category_events|
        category_events[category.id] = OngoingEventOperation::User::Index.present(
          ongoing_event_category_id: category.id,
          user: current_user,
        ).model.page(1).per(3)
      end)
    end
  end

  def show
    @operation = OngoingEventOperation::User::Show.present(event_id: params[:id])
    @event = @operation.model
  end

  def opt_in
    @event = OngoingEventOperation::User::OptIn
      .(current_user: current_user, event_id: params[:id])
      .model
  end

  def opt_out
    @event = OngoingEventOperation::User::OptOut
      .(current_user: current_user, event_id: params[:id])
      .model
    redirect_to schedule_path, notice: t(".notice")
  end

  private

  def load_event
    @operation = OngoingEventOperation::User::Show.present(event_id: params[:id])
    @event = @operation.model
  end

  def redirect_blocked_unless_participating
    if Event::Block.blocked_ongoing_non_participant?(user_id: current_user.id, event: @event)
      redirect_to ongoing_events_url, notice: t(".not_exist")
    end
  end
end
