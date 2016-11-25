// Init vars
var AUTH_TOKEN = $('meta[name=csrf-token]').attr('content');

// Main js execute when loaded page
$(document).ready(function() {
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
    
    // Filters group link click    
    $(document).on('click', '.btn-group-checkable .dropdown-menu>li>a', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        if($(this).hasClass('checked')) {
            $(this).removeClass('checked');
        } else {            
            $(this).addClass('checked');
        }
    });
});