module Erp
  module ApplicationHelper
    # text field builder
    def erp_form_control(type, options={})
      render partial: "erp/helpers/form_controls/#{type}", locals: { options: options }
    end
    
    # components
    def erp_component(type, options={})
      render partial: "erp/helpers/components/#{type}", locals: { options: options }
    end
    
    # list actions button for list
    def erp_datalist_list_actions(actions=[])
      render partial: "erp/helpers/list/datalist_list_actions", locals: { actions: actions }
    end
    
    # list actions button for each row of list
    def erp_datalist_row_actions(actions=[])
      render partial: "erp/helpers/list/datalist_row_actions", locals: { actions: actions }
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
    
    # Datalist check all checkbox
    def erp_datalist_check_all
      '<label class="mt-checkbox mt-checkbox-single mt-checkbox-outline">
          <input type="checkbox" class="group-checkable datalist-checkbox-all"/>
          <span></span>
      </label>'.html_safe
    end
    
    # Datalist check all checkbox
    def erp_datalist_check_row(options={})
      ('<label class="mt-checkbox mt-checkbox-single mt-checkbox-outline">
          <input type="checkbox" class="checkboxes datalist-row-checkbox" name="ids[]" value="'+options[:id].to_s+'" />
          <span></span>
      </label>').html_safe
    end
    
    # Datalist pagination
    def erp_datalist_pagination(data)
      return '' if data.empty?
      render partial: "erp/helpers/list/datalist_pagination", locals: { data: data }
    end
    
    # Get columns datalist
    def get_columns(params)
      params = params.to_unsafe_hash
      conds = []
      if params["columns"].present?
        params["columns"].each do |cl|
          cl[1].each do |cond|
            conds << "#{cond[1]["name"]}"
          end
        end
      end
      conds
    end
    
    # Get custom uniquess id
    def unique_id
      return [*5..30000].sample.to_s
    end
    
    # Format date
    def format_date(date)
      date.nil? ? '' : date.strftime(t('date_format'))
    end
    
    # Format date
    def export_partial
      "erp/elements/export.xlsx.axlsx"
    end
    
    def format_number(number, vn = false, round = false, precision = nil)
      prec = (number.to_f.round == number.to_f) ? 0 : 2
      prec = 0 if round
      
      if !precision.nil?
        prec = precision
      end
    
      if vn
        number_to_currency(number, precision: prec, separator: ",", unit: '', delimiter: ".")
      else
        number_to_currency(number, precision: prec, separator: ".", unit: '', delimiter: ",")
      end
    end
    
    
    @@mangso = ["không","một","hai","ba","bốn","năm","sáu","bảy","tám","chín"]
    def dochangchuc(so,daydu)
      chuoi = ""
      chuc = (so/10).to_i
      donvi = so%10
      
      if chuc > 1
        chuoi = " " + @@mangso[chuc] + " mươi";
        if donvi == 1
          chuoi += " mốt"
        end
      elsif chuc==1
        chuoi = " mười"
        if donvi==1
          chuoi += " một"
        end
      elsif daydu && donvi>0
        chuoi = " lẻ"
      end
      
      if donvi==5 && chuc>1
        chuoi += " lăm"
      elsif donvi>1 || ($donvi==1 && chuc==0)
          chuoi += " " + @@mangso[donvi]
      end
      return chuoi
    end
    
    def docblock(so,daydu)
      chuoi = ""
      tram = (so/100).floor
      so = so%100
      if daydu || tram>0
        chuoi = " " + @@mangso[tram] + " trăm"
        chuoi += dochangchuc(so,true)
      else
        chuoi = dochangchuc(so,false)
      end
      return chuoi;
    end
    
    def dochangtrieu(so,daydu)
      chuoi = ""
      trieu = (so/1000000).floor
      so = so%1000000
      if trieu>0
        
        chuoi = docblock(trieu,daydu) + " triệu"
        daydu = true
      end
      nghin = (so/1000).floor
      so = so%1000;
      if nghin>0
          chuoi += docblock(nghin,daydu) + " nghìn";
          daydu = true;
      end
      if so>0
          chuoi += docblock(so,daydu)
      end
      return chuoi
    end
      
    def docso(so)
      return @@mangso[0] if so==0 
      chuoi = ""
      hauto = ""
      begin
        ty = so%1000000000
        so = (so/1000000000).floor
        if so>0
          chuoi = dochangtrieu(ty,true) + hauto + chuoi
        else
          chuoi = dochangtrieu(ty,false) + hauto + chuoi
        end
        hauto = " tỷ"
      end while so>0
      
      chuoi = chuoi.strip.capitalize
      chuoi = (chuoi =~ /Triệu /) == 0 ? "Một " + chuoi : chuoi
      
      return chuoi.strip.capitalize + " đồng"
    end
    
    # Status /list page
    def status_label(status)
      status.present? ? "<span class=\'label label-sm label-#{status}\'>#{t('.' + status)}</span>".html_safe : ''
    end
    
  end
end
