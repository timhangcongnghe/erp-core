module Erp
  module ApplicationHelper
    def erp_text_field(options={})
      render partial: "erp/helpers/form_builders/text", locals: { options: options }
    end
  end
end
