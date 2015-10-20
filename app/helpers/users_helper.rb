module UsersHelper

  def admin_confirm_link(user)
    link_to user.admin_confirmed ? 'Sperren' : 'Freischalten',
            admin_confirm_user_path(user),
            method: :post,
            remote: true,
            data: { disable_with: "<i class='fa fa-spinner fa-spin'></i>" },
            id: 'admin-confirm',
            class: 'btn btn-default'
  end
end
