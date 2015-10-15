class PostsController < ApplicationController

  include Concerns::Paginated

  respond_to :html, :json

  before_filter :render_markup_if_html, except: [:destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  PAGE_SIZE = 10

  def index
    scope = current_user.posts.by_tags(*params[:search].try(:split, ' '))
    @posts = scope.includes(:secured_messages, :images).page(page, per_page: PAGE_SIZE).ordered
    @remain_pages = scope.pages(PAGE_SIZE) - page
  end

  def show

  end

  def new
    @post = Post.new
    render :show
  end

  def edit
  end

  def create
    @post = Post.new(post_params.merge(user_id: current_user.id))
    if @post.save
      render action: 'show', status: :created, location: @post
    else
      render json: { errors: @post.errors, messages: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @post.update_attributes(post_params)
      render :show
    else
      render json: { errors: @post.errors, messages: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  private

  def set_post
    @post = current_user.posts.find(params[:id])
  end

  def post_params
    params[:post][:images_attributes] ||= []
    params[:post][:secured_messages_attributes] ||= []
    params.require(:post).permit(
      :message,
      :title,
      images_attributes: [
        :_destroy,
        :id
      ],
      secured_messages_attributes: [
        :_destroy,
        :id,
        :message,
        :key
      ]
    )
  end

end
