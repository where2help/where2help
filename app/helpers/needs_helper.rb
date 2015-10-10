module NeedsHelper

  def icon_for(need)
    image_tag("needs/#{need.category}.png", class: 'img-responsive')
  end
end
