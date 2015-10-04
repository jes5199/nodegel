class UserController < ApplicationController
    def login
        welcome_home = "/*/welcome%20home"
        if current_user
            return redirect_to(welcome_home)
        end
        if request.post?
            user = User.find_by_name(params[:name]).try(:authenticate, params[:pass])
            if user
                session[:current_user_id] = user.id
                redirect_to(welcome_home)
            else
                flash[:error] = "ACCESS DENIED"
            end
        end
    end
end
