class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: [:destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "投稿しました"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/post'
    end
  end

  def hashtag
    @user = current_user
    @tag = Hashtag.find_by(hashname: params[:name])
    @microposts = @tag.microposts.build
    @micropost  = @tag.microposts.page(params[:page])
    @comment    = Comment.new
    @comments   = @microposts.comments
  end
  
  def destroy
    @micropost.destroy
    flash[:success] = "削除されました"
    redirect_to request.referrer || current_user
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
