class UserController < ApplicationController
    def login
        if request.post?
            user = User.find_by_name(params[:name]).try(:authenticate, params[:pass])
            if user
                session[:user] = user
                redirect_to("/*/welcome%20home")
            else
                flash[:error] = "ACCESS DENIED"
            end
        end
    end
end
