ActiveAdmin.register User do
  include Concerns::Views
  include Concerns::ParanoidScopes
  include Concerns::ParanoidFind

  menu priority: 3
  actions :all
  includes :languages, :abilities

  filter :email
  filter :first_name
  filter :last_name
  filter :admin
  filter :languages
  filter :abilities
  filter :created_at

  permit_params :email,
                :first_name,
                :last_name,
                :phone,
                :admin,
                :locale,
                ability_ids: [],
                language_ids: []

  # hidden in menu, just for direct linking
  scope :by_participation_count, if: proc { false } do |users|
    event_type_condition = (
      case params[:participation_type]
      when"shift"
        "shift_id"
      when "ongoing_event"
        "ongoing_event_id"
      else
        raise "Unknown participation_type #{params[:participation_type]}"
      end
    )
    users = users.unscoped
                 .joins("LEFT JOIN participations ON (participations.user_id = users.id AND participations.#{event_type_condition} IS NOT NULL)")
                 .group("users.id")
    if params[:max].present?
      users.having(
        "COUNT(participations.id) >= :min AND COUNT(users.id) < :max",
        min: params[:min].to_i,
        max: params[:max].to_i
      )
    else
      users.having(
        "COUNT(participations.id) >= :min",
        min: params[:min].to_i
      )
    end
  end

  # hidden in menu, just for direct linking
  scope :by_invested_hours, if: proc { false } do |users|
    users = users.unscoped
                 .joins("LEFT JOIN participations ON (participations.user_id = users.id)")
                 .joins("LEFT JOIN shifts ON (shifts.id = participations.shift_id)")
                 .group("users.id")
    duration_sql = "COALESCE(SUM(ends_at - starts_at), INTERVAL '0')"
    if params[:max].present?
      users.having(
        "#{duration_sql} >= ':min HOURS' AND #{duration_sql} < ':max HOURS'",
        min: params[:min].to_f,
        max: params[:max].to_f
      )
    else
      users.having(
        "#{duration_sql} >= ':min HOURS'",
        min: params[:min].to_f
      )
    end
  end

  member_action :lock, method: :put do
    UserOperation::Lock.(user: resource)
    redirect_to resource_path, notice: t(".successful")
  end

  member_action :unlock, method: :put do
    UserOperation::Unlock.(user: resource)
    redirect_to resource_path, notice: t(".successful")
  end

  action_item :lock, only: :show do
    if resource.locked?
      link_to t(".user.unlock"), unlock_admin_user_path(resource), method: :put
    else
      link_to t(".user.lock"),   lock_admin_user_path(resource),   method: :put
    end
  end

  controller do
    after_create do
      @user.send_confirmation_instructions
    end
  end
end
