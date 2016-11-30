// Init vars
var AUTH_TOKEN = $('meta[name=csrf-token]').attr('content');

// Main js execute when loaded page
$(document).ready(function() {
    // Datalist action link with message return
    $(document).on('click', 'a.ajax-link', function(e) {
        e.stopImmediatePropagation();
        e.stopPropagation();
        e.preventDefault();
        
        var method = $(this).attr('data-method');
        if(typeof(method) === 'undefined' || method.trim() === '') {
            method = 'GET';
        }
        
        var url = $(this).attr("href");
        var link_item = $(this);
        
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