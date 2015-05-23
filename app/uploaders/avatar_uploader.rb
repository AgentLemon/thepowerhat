# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :file

  def default_url
    "/assets/no_avatar.png"
  end

  def store_dir
    "avatars/#{model.id}/"
  end

  def filename
    if file.present?
      "#{model.id}.#{file.extension}"
    else
      nil
    end
  end

  process :resize_to_fill => [256, 256]

end
