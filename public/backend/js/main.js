Array.prototype.contains = function(obj) {
    var i = this.length;
    while (i--) {
        if (this[i].trim() === obj.trim()) {
            return true;
        }
    }
    return false;
};

function initHiddabbleControls() {
    // find all cond item
    $('[data-cond-item]').each(function() {
        var box = $(this).parents('form');
        
        var class_name = $(this).attr('data-cond-item');
        var control = box.find(class_name);
        
        if(control.hasClass('icheck')) {
            control.each(function() {
                var control_item = $(this);
                control_item.on("ifChecked", function() {
                    value = $(this).val();
                    box.find('[data-cond-item="' + class_name + '"]').each(function() {
                        if(!$(this).attr('data-cond-value').split(',').contains(value)) {
                            $(this).hide();
                        } else {
                            $(this).show();
                        }
                    });
                });
                if(control_item.is(':checked')) {
                    value = control_item.val();
                    box.find('[data-cond-item="' + class_name + '"]').each(function() {                    
                        if(!$(this).attr('data-cond-value').split(',').contains(value)) {
                            $(this).hide();
                        } else {
                            $(this).show();
                        }
                    });
                }
            });
                
        } else {            
            control.on("change", function() {
                value = $(this).val();
                box.find('[data-cond-item="' + class_name + '"]').each(function() {
                    if(!$(this).attr('data-cond-value').split(',').contains(value)) {
                        $(this).hide();
                    } else {
                        $(this).show();
                    }
                });
            });
            control.trigger('change');
        }
    });
}

function jsForAjaxContent(container) {
    // date picker
    container.find('.date-picker').each(function() {
      $(this).datepicker({
          rtl: App.isRTL(),
          orientation: "left",
          autoclose: true
      });
    });
    
    // icheck
    container.find('.icheck').each(function() {
      var checkboxClass = $(this).attr('data-checkbox') ? $(this).attr('data-checkbox') : 'icheckbox_minimal-grey';
      var radioClass = $(this).attr('data-radio') ? $(this).attr('data-radio') : 'iradio_minimal-grey';
  
      if (checkboxClass.indexOf('_line') > -1 || radioClass.indexOf('_line') > -1) {
          $(this).iCheck({
              checkboxClass: checkboxClass,
              radioClass: radioClass,
              insert: '<div class="icheck_line-icon"></div>' + $(this).attr("data-label")
          });
      } else {
          $(this).iCheck({
              checkboxClass: checkboxClass,
              radioClass: radioClass
          });
      }
    });
    
    // hiddable field control
    initHiddabbleControls();
    
    // for related dataselect
    initParentControls();
    
    // auto crop image input helper
    container.find('.fileinput-preview').bind("DOMSubtreeModified",function(){
        if(!$(this).find('span').length) {
            $(this).find('img').wrap('<span></span>');
            
            // get real size of image
            var imgs = $(this).find('img');
            var img = $(this).find('img')[0]; // Get my img elem
            var pic_real_width, pic_real_height;
            var span = $(this).find('span');
            $("<img/>") // Make in memory copy of image to avoid css issues
                .attr("src", $(img).attr("src"))
                .load(function() {
                    pic_real_width = this.width;   // Note: $(this).width() will not
                    pic_real_height = this.height; // work for in memory images.
                    
                    // 
                    var box_width = span.width();
                    var box_height = span.height();
                    
                    if(box_width/box_height > pic_real_width/pic_real_height) {
                        imgs.css('width', box_width);
                        
                        var m_top = -((pic_real_height*(box_width/pic_real_width)) - box_height)/2;
                        imgs.css('margin-top', m_top);
                    } else {
                        imgs.css('height', box_height);
                        
                        var m_left = -((pic_real_width*(box_height/pic_real_height)) - box_width)/2;
                        imgs.css('margin-left', m_left);
                    }
                });
        }
    });
    
    // hightlight tab if has error form
    container.find('.form-group.has-error').each(function() {
        var tab = $(this).parents('.tab-pane');
        var tab_id = tab.attr('id');
        
        $('[href="#' + tab_id + '"], [data-target="#' + tab_id + '"]').addClass('has_error');
    });
    
    // input number helper
    container.find('.numberic').each(function() {
        var min = $(this).attr("min");
        var max = $(this).attr("max");
        var digit = $(this).attr("digit");
        var type = $(this).attr("number-type");
        
        $(this).inputmask(type, {min:parseFloat(min), max: parseFloat(max), digits: parseFloat(digit), groupSeparator: ","});
    });
    
    // select helper
    container.find('.select2').each(function() {
        $(this).select2();
    });
}

//scroll to jquery element
function scrollToElement(element, top) {
  if(typeof(top) === 'undefined') {
    top = 0;
  }
    
  $('html,body').animate({
    scrollTop: element.offset().top - top
  }, 'slow');
}

// Generate unique id
function guid() {
  function s4() {
    return Math.floor((1 + Math.random()) * 0x10000)
      .toString(16)
      .substring(1);
  }
  return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
    s4() + '-' + s4() + s4() + s4();
}

// function
function ajaxLinkRequest(link) {
    var method = link.attr('data-method');
    if(typeof(method) === 'undefined' || method.trim() === '') {
        method = 'GET';
    }
    
    var url = link.attr("href");
    var link_item = link;
    
    $.ajax({
        url: url,
        method: method,
        data: {
            'authenticity_token': AUTH_TOKEN,
            'format': 'json'
        }
    }).done(function( result ) {
        swal({
            title: result.message,
            text: '',
            type: result.type,
            allowOutsideClick: true,
            confirmButtonText: "OK"
        });
        
        // find outer datalist if exists
        if(link_item.parents('.datalist').length) {
            datalistFilter(link_item.parents('.datalist'));
        }
    });
}

// Init vars
var AUTH_TOKEN = $('meta[name=csrf-token]').attr('content');

// Main js execute when loaded page
$(document).ready(function() {
    // Datalist action link with message return
    $(document).on('click', 'a[data-confirm]', function(e) {
        e.stopImmediatePropagation();
        e.stopPropagation();
        e.preventDefault();
        
        var message = $(this).attr("data-confirm");
        var link = $(this);
        
        bootbox.confirm({
            message: message,
            buttons: {
                'cancel': {
                    label: 'Cancel',
                },
                'confirm': {
                    label: 'OK',
                }
            },
            callback: function(result) {
                if (result) {
                    if (link.parents('.datalist-list-action').length) {
                        listActionProccess(link);
                    } else if(link.hasClass('ajax-link')) {
                        ajaxLinkRequest(link);                        
                    } else {
                        window.location = link.attr('href');
                    }
                }
            }
        });
    });
    
    // Datalist action link with message return
    $(document).on('click', 'a.ajax-link', function(e) {
        e.stopImmediatePropagation();
        e.stopPropagation();
        e.preventDefault();
        
        ajaxLinkRequest($(this));
    });
    
    // Grap link with data-method attribute
    $(document).on('click', 'a.link-method[data-method]', function(e) {
        
        // return if this is list action
        if($(this).parents('.datalist-list-action').length) {
            return;
        }
        
        e.preventDefault();
        
        var method = $(this).attr("data-method");
        var action = $(this).attr("href");
        
        var newForm = jQuery('<form>', {
            'action': action,
            'method': 'POST',
            'target': '_top'
        });
        newForm.append(jQuery('<input>', {
            'name': 'authenticity_token',
            'value': AUTH_TOKEN,
            'type': 'hidden'
        }));
        newForm.append(jQuery('<input>', {
            'name': '_method',
            'value': method,
            'type': 'hidden'
        }));
        newForm.submit();
    });
    
    // Grap link with data-method attribute
    jsForAjaxContent($('body'));
    
    
});