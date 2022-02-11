# encoding: utf-8
module Erp
  class EditorUploadUploader < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick
    storage :file

    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end
end