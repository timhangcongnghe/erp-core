module Erp
  module ApplicationHelper
    def erp_text_field(options={})
      render partial: "erp/backend/helpers/form/text", locals: { options: options }
    end
  end
end
