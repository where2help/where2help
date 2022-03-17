require "ngo/blocking"

class Ngos::BlockingController < ApplicationController
  before_action :authenticate_ngo!

  def index
    @blocks = Ngo::Blocking::List.(ngo: current_ngo)
  end

  def destroy
    Ngo::Blocking::Unblock.(ngo: current_ngo, block_id: params[:id])
    redirect_to ngos_blocking_index_url, notice: t(".removed")
  end
end
