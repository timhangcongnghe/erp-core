module Erp
  module Backend
    class EditorUploadsController < Erp::Backend::BackendController
      # upload image
      def upload
        @editor_upload = EditorUpload.new(editor_upload_params)
        @editor_upload.save

        render plain: @editor_upload.image_url
      end

      private
        # Only allow a trusted parameter "white list" through.
        def editor_upload_params
          params.fetch(:editor_upload, {}).permit(:image_url)
        end
    end
  end
end
