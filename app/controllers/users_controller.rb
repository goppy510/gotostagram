class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    if logged_in?
      @micropost = current_user.microposts.build
      @microposts = current_user.microposts.page(params[:page])
      @feed_items = current_user.feed.page(params[:page])
      @comment = Comment.new
      @comments = @micropost.comments
    else
      redirect_to login_url
    end
  end

  def show
    @user = User.find(params[:id])
    @micropost = @user.microposts.build
    @microposts = @user.microposts.page(params[:page])
    @feed_items = current_user.feed.page(params[:page])
    @comment = Comment.new
    @comments = @micropost.comments
  end

  def new
    @user = User.new
  end

  def list
    @users = User.all
  end

  def create
    @user  = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Gotostagramへようこそ"
      redirect_to @user
    else
      render "new"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def status
  
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールが変更されました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_url
  end

  def following
    @title = "フォロー中"
    @user  = User.find(params[:id])
    @users = @user.following.page(params[:page])
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.page(params[:page])
    render 'show_follow'
  end



  private 
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :introduce)
    end

    #ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end

    #正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    #管理者かどうか
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
