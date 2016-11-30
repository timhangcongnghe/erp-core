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
    
});