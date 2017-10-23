function customParseFloat(num) {
    if (typeof(num) == 'undefined') {
        return 0.0;
    } else {
        return parseFloat(num.replace(/,/g,""));
    }
}
function priceInput(element) {
    element.inputmask("decimal", { radixPoint: ".", autoGroup: true, groupSeparator: ",", digits: 2, groupSize: 3 });
}
function formatNumber(num) {
    return num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
}
function hideSidebar() {
    $('body').addClass('page-sidebar-closed');
    $('.page-sidebar-menu').addClass('page-sidebar-menu-closed');
}

function showSidebar() {
    $('body').removeClass('page-sidebar-closed');
    $('.page-sidebar-menu').removeClass('page-sidebar-menu-closed');
}

function showAlert(type, message, title) {
    toastr.options = {
        "closeButton": true,
        "debug": false,
        "positionClass": "toast-bottom-right",
        "onclick": null,
        "showDuration": "1000",
        "hideDuration": "1000",
        "timeOut": "5000",
        "extendedTimeOut": "1000",
        "showEasing": "swing",
        "hideEasing": "linear",
        "showMethod": "fadeIn",
        "hideMethod": "fadeOut"
    };
    toastr[type](message, title);
}

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
    container.find('.date-picker-erp').each(function() {
      $(this).datepicker({
          rtl: App.isRTL(),
          orientation: "left",
          autoclose: true,
          format: LANG_DATE_FORMAT_JS
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
    container.find('.fileinput-preview').trigger("DOMSubtreeModified");

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

        priceInput($(this)); // .inputmask(type, {min:parseFloat(min), max: parseFloat(max), digits: parseFloat(digit), groupSeparator: ","});
    });

    // select helper
    container.find('.select2').each(function() {
        $(this).select2();
    });

    // For tooltip
    container.find('.tooltips').tooltip();

    // Row has child ajax content
    container.find('.has-child-table .expand').bind("click", function() {
        var row = $(this).closest('tr');
        var url = row.attr('data-url');
        var cols = row.find('td').length;

        $.ajax({
            url: url,
            method: 'GET'
        }).done(function( result ) {
            var exist = row.next();
            if(!exist.hasClass('child-row')) {
                row.after(
                    '<tr class="child-row">' +
                        '<td class="child-td" colspan="' + cols + '">' +
                            result +
                        '</td>' +
                    '</tr>'
                );
                row.addClass('opened');

                child = row.next();
                jsForAjaxContent(child);
            } else {
                if(exist.is(':visible')) {
                    exist.remove();
                    row.removeClass('opened');
                } else {
                    exist.show();
                    row.addClass('opened');
                }
            }
        });
    });

    // ajax-box
    container.find('.ajax-box').each(function() {
        var box = $(this);
        var url = box.attr('data-url');
        var controls = $(box.attr('data-control'));

        controls.change(function() {
            str = box.attr('data-control');
            //console.log(str);

            var datas = [];
            str.split(',').forEach(function(str) {
                datas.push($(str).val());
            });

            $.ajax({
                url: url,
                method: 'GET',
                data: {
                    datas: datas
                }
            }).done(function( result ) {
                box.html(result);
                jsForAjaxContent(box);
            });
        });

        controls.eq(0).trigger('change');
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
            confirmButtonText: LANG_OK
        });

        // find outer datalist if exists
        if(link_item.parents('.datalist').length) {
            datalistFilter(link_item.parents('.datalist'));
        }
    });
}

// Auto count quantity for addableform-table (line-form)
function autoAddItemsLine(container) {
    var rows = container.find('table tbody tr:visible');
    var qtytotal = 0;
    rows.each(function() {
        var row = $(this);
        var quantity = parseFloat(row.find('.line_quantity').val());
        // Update items total
        if(quantity) {
            qtytotal += quantity;
        }
    });
    // update line total
    container.find('.quantity_total').html(qtytotal);
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
                    label: LANG_CANCEL,
                },
                'confirm': {
                    label: LANG_OK,
                }
            },
            callback: function(result) {
                if (result) {
                    if (link.parents('.datalist-list-action').length) {
                        listActionProccess(link);
                    } else if(link.hasClass('ajax-link')) {
                        ajaxLinkRequest(link);
                    } else if(link.hasClass('link-method')) {
                        link.removeAttr('data-confirm');
                        link.trigger('click');
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
        $(document.body).append(newForm);
        newForm.submit();
    });

    // Grap link with data-method attribute
    jsForAjaxContent($('body'));


    // images uploader event
    $(document).on('click', '.images-upload .image-box .thumbnail', function() {
        $(this).parents('.image-box').find('input[type=file]').trigger('click');
    });
    $(document).on('click', '.images-upload .image-box .remove-image', function() {
        $(this).parents('.image-box').find('.destroy_input').val('1');
    });
    // remove destroy if has new image
    setInterval(function() {
        $('.images-upload .image-box.fileinput-exists').each(function() {
            $(this).find('.destroy_input').val('');
        });
    }, 1000);

    // Modal link
    $(document).on('click', '.modal-link', function(e) {
        e.preventDefault();

        var url = $(this).attr('href');

        // create new modal if not exist
        var modal_uid = "link-modal-" + guid();
        var modal_size = 'full';
        var title = 'Title';

        var modal = $('#' + modal_uid);
        if(!modal.length) {
            var html = '<div id="' + modal_uid + '" class="modal addablelist-modal fade" tabindex="-1">' +
                '<div class="modal-dialog  modal-custom-blue modal-' + modal_size + '">' +
                    '<div class="modal-content">' +
                        '<div class="modal-header">' +
                            '<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-close"></i></button>' +
                            '<h4 class="modal-title">' + title + '</h4>' +
                        '</div>' +
                        '<div class="modal-body">' +
                            '<i class="icon-refresh text-semibold"></i>' +
                        '</div>' +
                    '</div>' +
                '</div>' +
            '</div>';
            $('body').append(html);

            modal = $('#' + modal_uid);
        }

        modal.modal('show');

        $.ajax({
            url: url
        }).done(function( html ) {
            modal.find('.modal-body').html(html);
        });
    });

    // Save current sidebar state
    $(document).on('click', '.menu-toggler.sidebar-toggler', function(e) {
        if($('body').hasClass('page-sidebar-closed')) {
            Cookies.set('sidebar_state', 'hide');
        } else {
            Cookies.set('sidebar_state', 'show');
        }
    });
    // show hide sidebar
    var sidebar_state = Cookies.get('sidebar_state');
    if(typeof(sidebar_state) !== 'undefined' && sidebar_state === 'hide') {
        hideSidebar();
    }

    // Product property form
    // $('.product-property-container').
    $(document).on('change', '[name="product[category_id]"]', function() {
        var input = $(this);
        var value = input.val();
        var container = input.parents('form').find('.product-property-container');
        var url = container.attr('data-url');

        if(value == '') {
            container.html('');
        } else {
            $.ajax({
                url: url,
                method: 'GET',
                data: {
                    category_id: value
                }
            }).done(function( data ) {
                container.html(data);
            });
        }
    });

    // show alert for input errors
    $('.help-block.alert').each(function() {
        showAlert('error', $(this).html());
    });

    // global_filter_action
    $(document).on('click', '.global_filter_action', function(e) {
        e.preventDefault();

        var form = $(this).parents('form');
        var url = $(this).attr('href');

        form.attr('action', url);

        form.submit();
    });

    // Auto list
    $('.autolist').autolist();

    // -- Auto count quantity for addableform-table (line-form)
    $('.add-items-line').each(function() {
        autoAddItemsLine($(this));
    });

    // Change event on order line
    $(document).on('change keyup', '.add-items-line input', function(e) {
        var container = $(this).parents('.add-items-line');
        autoAddItemsLine(container);
    });

    // Click event nested remove button
    $(document).on('click', '.nested-remove-button', function(e) {
        var container = $(this).parents('.add-items-line');
        setTimeout(function() {autoAddItemsLine(container);}, 100);
    });
    // -END- Auto count quantity for addableform-table (line-form)

    // warehouses-stock-info
    $('.warehouses-stock-info').each(function() {
        var box = $(this);
        var form = box.closest('form');
        var url = box.attr('data-url');
        var control_selector = box.attr('data-control');

        $(control_selector).change(function() {
            var values = [];
            $(control_selector).each(function() {
                console.log($(this).val());
                values.push($(this).val());
            });

            console.log(values);
            // box.html('<div class="loader"><div class="ball-pulse"><div></div><div></div><div></div></div></div>');

            $.ajax({
                method: "GET",
                url: url,
                data: {
                    ids: values.join(',')
                }
            }).done(function( data ) {
                box.html(data);
                applyJs(box);
            });
        });
        $(control_selector).trigger('change');
    });
});
