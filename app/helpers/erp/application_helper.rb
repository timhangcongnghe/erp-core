module Erp
  module ApplicationHelper
    # text field builder
    def erp_text_field(options={})
      render partial: "erp/helpers/form_builders/text", locals: { options: options }
    end
    
    # list actions button for list
    def erp_list_actions_button(actions=[])
      render partial: "erp/helpers/list/list_actions_button", locals: { actions: actions }
    end
    
    # list actions button for each row of list
    def erp_row_actions_button(actions=[])
      render partial: "erp/helpers/list/row_actions_button", locals: { actions: actions }
    end
    
    # filters button for list
    def erp_filters_button(actions=[])
      render partial: "erp/helpers/list/filters_button", locals: { actions: actions }
    end
    
    # columns button for list
    def erp_columns_button(actions=[])
      render partial: "erp/helpers/list/columns_button", locals: { actions: actions }
    end
    
    # columns button for list
    def erp_list_container(options=[])
      render partial: "erp/helpers/list/list_container", locals: { options: options }
    end
  end
end
