class PagesController < ApplicationController
  def home
  end

  def robots
    render format: "txt"
  end
end
