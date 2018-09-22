# frozen_string_literal: true

module ShiftsHelper
  def opt_button_for(shift, user)
    if shift.users.include? user
      link_to t('shifts.opt_out_btn'), shift_opt_out_path(shift),
              method: :delete,
              data: { confirm: t('shifts.are_you_sure'), disable_with: "<i class='fas fa-spinner fa-spin'></i>" },
              class: 'btn btn-danger btn-lg btn-block'
    else
      link_to t('shifts.opt_in_btn'), shift_opt_in_path(shift),
              method: :post,
              data: { disable_with: "<i class='fas fa-spinner fa-spin'></i>" },
              class: 'btn btn-primary btn-lg btn-block'
    end
  end

  def load_more_shifts_btn(shifts, params = {})
    link_to_next_page shifts, t('shifts.load_more'),
                      params: params,
                      remote: true,
                      data: { disable_with: "<i class='fas fa-spinner fa-spin'></i>", behavior: 'shift-pagination' },
                      class: 'btn'
  end
end
