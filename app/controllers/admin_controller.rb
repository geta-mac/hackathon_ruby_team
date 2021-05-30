class AdminController < ApplicationController

  before_action :except_non_administrator
  before_action :find_user, only: [:show_user, :delete_user]

  def users_index
    @users = User.all.page(params[:page]).per(50)
  end

  def posts_index
    @post = Post.new
    @posts = Post.all.page(params[:page]).per(100)
  end

  def posts_search
    @post = Post.new
    s_time = params[:post][:start_time]
    e_time = params[:post][:end_time]
    s_date = params[:post][:start_date]
    e_date = params[:post][:end_date]
    direction = params[:post][:direction]
    station = params[:post][:station]
    @posts = Post.s_duration(s_date).e_duration(e_date).s_time(s_time).e_time(e_time).direction(direction).station(station)
  end

  def show_user
    @posts = @user.posts
  end

  def delete_user
    if @user.destroy
      flash[:notice] = "ユーザーを削除しました"
    else
      flash[:alert] = "削除できません"
    end
    redirect_to users_index_path
  end

  def delete_post
    @post = Post.find(params[:id])
    if @post.delete
      flash[:notice] = "投稿を削除しました"
    else
      flash[:alert] = "削除できません"
    end
    redirect_back fallback_location: posts_index_path
  end

  private
    def except_non_administrator
      if current_user.admin != 1
        redirect_to root_path
      end
    end

    def find_user
      @user = User.find_by(id: params[:id])
    end
end
