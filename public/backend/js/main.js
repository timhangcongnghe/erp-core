Array.prototype.contains = function(obj) {
    var i = this.length;
    while (i--) {
        if (this[i] === obj) {
            return true;
        }
    }
    return false;
};

function initHiddabbleControls() {
    // find all cond item
    $('[data-cond-item]').each(function() {
        box = $(this).parents('form');
        
        var class_name = $(this).attr('data-cond-item');
        var control = box.find(class_name);
        
        if(control.hasClass('icheck')) {
            control.on("ifChecked", function() {
                value = $(this).val();
                box.find('[data-cond-item="' + class_name + '"]').each(function() {                    
                    if($(this).attr('data-cond-value') !== value) {
                        $(this).hide();
                    } else {
                        $(this).show();
                    }
                });
            });
            if(control.is(':checked')) {
                value = control.val();
                box.find('[data-cond-item="' + class_name + '"]').each(function() {                    
                    if($(this).attr('data-cond-value') !== value) {
                        $(this).hide();
                    } else {
                        $(this).show();
                    }
                });
            }
        } else {            
            control.on("change", function() {
                value = $(this).val();
                box.find('[data-cond-item="' + class_name + '"]').each(function() {
                    if($(this).attr('data-cond-value') !== value) {
                        $(this).hide();
                    } else {
                        $(this).show();
                    }
                });
            });
            control.trigger('change');
        }
    });

    
    ////
    //items.forEach(function(item) {
    //    if($(item).hasClass('icheck')) {
    //        value = $(item + ':checked').val();
    //        $('[data-cond-item="' + item + '"]').each(function() {
    //            if($(this).attr('data-cond-value') !== value) {
    //                $(this).hide();
    //            } else {
    //                $(this).show();
    //            }
    //        });
    //        $(document).on("ifChecked", item, function() {
    //            value = $(this).val();
    //            $('[data-cond-item="' + item + '"]').each(function() {
    //                if($(this).attr('data-cond-value') !== value) {
    //                    $(this).hide();
    //                } else {
    //                    $(this).show();
    //                }
    //            });
    //        });            
    //    } else {
    //        $(document).on("change", item, function() {
    //            value = $(this).val();
    //            $('[data-cond-item="' + item + '"]').each(function() {
    //                if($(this).attr('data-cond-value') !== value) {
    //                    $(this).hide();
    //                } else {
    //                    $(this).show();
    //                }
    //            });
    //        });
    //        $(item).trigger('change');
    //    }        
    //});
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
    $(document).on('click', 'a[data-method]', function(e) {
        
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
    initHiddabbleControls();
});