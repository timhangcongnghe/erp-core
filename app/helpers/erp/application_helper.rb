module Erp
  module ApplicationHelper
    # text field builder
    def erp_form_control(type, options={})
      render partial: "erp/helpers/form_builders/#{type}", locals: { options: options }
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
    def erp_datalist_filters(actions=[])
      render partial: "erp/helpers/list/datalist_filters", locals: { actions: actions }
    end
    
    # columns button for list
    def erp_datalist_columns_select(actions=[])
      render partial: "erp/helpers/list/datalist_columns_select", locals: { actions: actions }
    end
    
    # Datalist main helper
    def erp_datalist(options=[])
      render partial: "erp/helpers/list/datalist", locals: { options: options }
    end
    
    # Datalist pagination
    def erp_datalist_pagination(data)
      render partial: "erp/helpers/list/datalist_pagination", locals: { data: data }
    end
  end
end
