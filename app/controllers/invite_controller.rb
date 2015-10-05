class InviteController < ApplicationController
  def index
    @invites = Invite.where(from_user: current_user)
    @total = @invites.count
    @unused = @invites.where(created_user: nil)
  end

  def wish
  end

  def claim
    @invite = Invite.where(key: params[:key]).first()
    if @invite
      @invitor = @invite.from_user
    end
    @claimable = @invite && !@invite.created_user
  end

  def activate
    invite_index = params[:invite_number].to_i
    @invite = Invite.where(from_user: current_user).all[invite_index]
    @invite.activate
    redirect_to "/%20/invite"
  end
end
