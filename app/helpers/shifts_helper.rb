module ShiftsHelper
  def opt_button_for(shift, user)
    if shift.users.include? user
      link_to t('shifts.opt_out_btn'), shift_opt_out_path(shift),
        method: :delete,
        data: { confirm: t('shifts.are_you_sure'), disable_with: "<i class='fa fa-spinner fa-spin'></i>" },
        class: 'btn btn-danger btn-lg btn-block'
    else
      link_to t('shifts.opt_in_btn'), shift_opt_in_path(shift),
        method: :post,
        data: { disable_with: "<i class='fa fa-spinner fa-spin'></i>" },
        class: 'btn btn-primary btn-lg btn-block'
    end
  end

  def load_more_shifts_btn(shifts, params={})
    link_to_next_page shifts, t('shifts.load_more'),
      params: params,
      remote: true,
      data: { disable_with: "<i class='fa fa-spinner fa-spin'></i>", behavior: 'shift-pagination' },
      class: 'btn'
  end

  def progress_bar(signed_up: 0, needed: 1, current_user: false)
    content_tag :div, class: "progress" do
      if current_user
        if signed_up <= needed
          me = (100.0 / needed).ceil
          percentage = (100.0 * (signed_up - 1) / needed).ceil
          content_tag(:div, content_tag(:i, "", class: "fa fa-smile-o") +
                            " " + I18n.t("activerecord.attributes.shift.you"),
                      class: "progress-bar massive-font progress-bar-striped progress-bar-info", style: "width: #{me}%" ) +
          content_tag(:div, signed_up.to_s + " " + I18n.t("activerecord.attributes.shift.confirmed_so_far"),
                      class: "progress-bar massive-font progress-bar-striped progress-bar-success", style: "width: #{percentage}%" ) +
          content_tag(:div, (needed - signed_up).to_s + " " + I18n.t("activerecord.attributes.shift.missing"),
                      class: "progress-bar massive-font progress-bar-striped", style: "width: #{100 - percentage - me}%; background-color: #656D78")
        else
          me = (100.0 / signed_up).ceil
          percentage = (100.0 * (needed - 1) / signed_up).ceil
          content_tag(:div, content_tag(:i, "", class: "fa fa-smile-o") +
                            " " + I18n.t("activerecord.attributes.shift.you"),
                      class: "progress-bar massive-font progress-bar-striped progress-bar-info", style: "width: #{me}%" ) +
          content_tag(:div, (needed - 1).to_s + " " + I18n.t("activerecord.attributes.shift.needed"),
                      class: "progress-bar massive-font progress-bar-striped progress-bar-success", style: "width: #{percentage}%" ) +
          content_tag(:div, (signed_up - needed).to_s + " " + I18n.t("activerecord.attributes.shift.surplus"),
                      class: "progress-bar massive-font progress-bar-striped progress-bar-warning", style: "width: #{100 - percentage - me}%")
        end
      else
        if signed_up <= needed
          percentage = (100.0 * signed_up / needed).ceil
          content_tag(:div, signed_up.to_s + " " + I18n.t("activerecord.attributes.shift.confirmed_so_far"),
                      class: "progress-bar massive-font progress-bar-striped progress-bar-success", style: "width: #{percentage}%" ) +
          content_tag(:div, (needed - signed_up).to_s + " " + I18n.t("activerecord.attributes.shift.missing"),
                      class: "progress-bar massive-font progress-bar-striped", style: "width: #{100 - percentage}%; background-color: #656D78")
        else
          percentage = (100.0 * needed / signed_up).ceil
          content_tag(:div, needed.to_s + " " + I18n.t("activerecord.attributes.shift.needed"),
                      class: "progress-bar massive-font progress-bar-striped progress-bar-success", style: "width: #{percentage}%" ) +
          content_tag(:div, (signed_up - needed ).to_s + " " + I18n.t("activerecord.attributes.shift.surplus"),
                      class: "progress-bar massive-font progress-bar-striped progress-bar-warning", style: "width: #{100 - percentage}%")
        end
      end
    end
  end
end
