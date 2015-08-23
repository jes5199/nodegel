class InviteController < ApplicationController
  def index
  end

  def wish
  end

  def claim
    @invite = Invite.where(key: params[:key]).first()
    if @invite
      @invitor = @invite.from_user
    end
  end
end
