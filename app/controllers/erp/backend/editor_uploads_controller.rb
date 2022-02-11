module Erp
  module Backend
    class EditorUploadsController < Erp::Backend::BackendController
      def upload
        @editor_upload = EditorUpload.new(editor_upload_params)
        @editor_upload.save
        render plain: @editor_upload.image_url
      end

      private
        def editor_upload_params
          params.fetch(:editor_upload, {}).permit(:image_url)
        end
    end
  end
end