class ImagesController < ApplicationController

  layout false

  before_filter :load_image

  def upload
    Image.find(@image.id).update_attributes! file: params[:file]
    render json: { thumbUrl: file_image_path(@image, :small) }
  end

  def file
    file = @image.file
    version = params[:version].try(:to_sym)
    file = file.send(version) if version.present? && file.respond_to?(version)
    send_file file.path, type: "image/jpeg", disposition: "inline", filename: file.filename
  end

  private

  def load_image
    @image = Image.joins(:post).where(post: { user_id: current_user.id }).find(params[:id])
  end

  def item_index
    params[:index] || 0
  end

end
