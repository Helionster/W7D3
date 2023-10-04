class UsersController < ApplicationController
    before_action :require_logged_out, only: [:new,:create]
    before_action :require_logged_in, only: [:destroy]

    def new 
        @user = User.new 
        render :new
    end

    def create  
        @user = User.new(user_params)
        
        if @user.save!
            login(@user)
            redirect_to user_url(@user)
        else 
            flash.now[:errors] = @user.errors.full_messages
            render :new
        end
    end

    def show 
        @user = User.find_by(params[:id])

        if @user
            render :show
        else  
            redirect_to users_url
        end
    end

    def index
        @users = User.all 
        render :index
    end

    private 
    def user_params
        params.require(:user).permit(:username,:password)
    end
end