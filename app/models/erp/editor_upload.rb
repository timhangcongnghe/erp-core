module Erp
  class EditorUpload < ApplicationRecord
    mount_uploader :image_url, Erp::EditorUploadUploader
  end
end
