class SecuredMessagesController < ApplicationController

  layout false

  before_filter :set_message, only: [:show]

  def show

  end

  private

  def set_message
    @message = SecuredMessage.joins(:post).where(post: { user_id: current_user.id }).find(params[:id])
    @key = params[:key]
    @message.decrypt_message @key if @key.present?
  end

  def item_index
    params[:index] || 0
  end

end
