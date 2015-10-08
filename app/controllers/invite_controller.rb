class InviteController < ApplicationController
  def index
    if !current_user
      return redirect_to("/%20/sign%20up")
    end
    @invites = Invite.where(from_user: current_user)
    @total = @invites.count
    @unused = @invites.where(created_user: nil)
  end

  def wish
  end

  def claim
    if request.post? and params[:secret]
      session[:secret] = params[:secret]
    end
    @invite = Invite.where(key: session[:secret]).first()
    if @invite
      @invitor = @invite.from_user
    end
    @claimable = @invite && !@invite.created_user
    if !@claimable && @invite.from_user = current_user
      return redirect_to '/*/welcome%20home'
    end
    if not @claimable
      flash[:error] = "Access Denied"
      session[:secret] = nil
      return redirect_to '/%20/invite/'
    end
    if request.post? and params[:name]
      if User.where(name: params[:name]).any?
        flash[:error] = "Sorry, that name was already taken. Try another?"
        return
      end
      user = User.new(name: params[:name], password: params[:pass], password_confirmation: params[:confirm])
      if params[:pass] != params[:confirm]
        flash[:error] = "Password confirmation has to match the password."
        return
      end
      if not user.valid?
        flash[:error] = "Usernames should only contain letters, numbers, symbols from !?.,-_' and spaces (but no crazy spacing okay)"
        return
      end
      user.save!
      @invite.created_user = user
      @invite.save!
      flash[:error] = ""
      session[:current_user_id] = user.id
      return redirect_to("/*/welcome%20home")
    end
  end

  def activate
    invite_index = params[:invite_number].to_i
    @invite = Invite.where(from_user: current_user).all[invite_index]
    @invite.activate
    redirect_to "/%20/invite"
  end
end
