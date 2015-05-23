class PostsController < ApplicationController

  include Concerns::Paginated

  respond_to :html, :json

  before_action :set_post, only: [:show, :edit, :update, :destroy]

  PAGE_SIZE = 10

  def index
    scope = current_user.posts.by_tags(*params[:search].try(:split, ' '))
    @posts = scope.includes(:secured_messages, :images).page(page, per_page: PAGE_SIZE).ordered
    @remain_pages = scope.pages(PAGE_SIZE) - page
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    respond_to do |format|
      format.html { render nothing: true, layout: true }
      format.json { render :show }
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
    respond_to do |format|
      format.html { render nothing: true, layout: true }
      format.json { render :show }
    end
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params.merge(:user_id => current_user.id))

    respond_to do |format|
      if @post.save
        format.html { redirect_to root_path, notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'edit' }
        format.json { render json: { errors: @post.errors, messages: @post.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to root_path, notice: 'Post was successfully updated.' }
        format.json { render :show }
      else
        format.html { render action: 'edit' }
        format.json { render json: { errors: @post.errors, messages: @post.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
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
