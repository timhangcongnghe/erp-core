# encoding: utf-8
module Erp
  class AvatarUploader < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick
    storage :file
    
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    version :system do
      process resize_to_fill: [60, 60]
    end

    version :profile do
      process resize_to_fill: [100, 100]
    end
  end
end