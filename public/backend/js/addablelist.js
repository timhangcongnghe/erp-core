// Get current addablelist
function getCurrentAddablelist() {
    addablelist = $('[rel="' + $('.addablelist-modal.in').last().attr('addablelist') + '"]');

    return addablelist;
}

// Submit form event
function submitAddablelistModalForm(form) {
    var addablelist = getCurrentAddablelist();
    var method = form.attr('method');
    var url = form.attr('action');
    var modal = $('#addablelist-modal-' + addablelist.attr('rel'));
    var container_selector = modal.attr('data-selector');
    var container = addablelist.find('.addablelist-container');
    var list_partial = addablelist.attr('list-partial');
    
    modal.find('.modal-body').html('<div class="text-center"><i class="fa fa-circle-o-notch fa-spin"></i></div>');
    
    // form data
    var form_data = new FormData(form[0]);
    form_data.append('partial', list_partial);
    
    $.ajax({
        type: method,
        url: url,
        processData: false,
        contentType:false,
        data: form_data, // serializes the form's elements.
        success: function(data)
        {
            // get data
            var result = $('<div>').html(data).find(container_selector);
            
            if (result.length) {
                modal.find('.modal-body').html(result[0].outerHTML);
            } else {
                data = '<div class="addablelist-row">' + data + '</div>';
                // insert new item to list
                if (CURRENT_ADDABLELIST_LINE !== 'none') {
                    CURRENT_ADDABLELIST_LINE.after(data);
                    CURRENT_ADDABLELIST_LINE.remove();
                } else {
                    container.append(data);
                }                
                jsForAjaxContent(container);
                
                modal.modal('hide');                
                scrollToElement(addablelist, 140);                
            }
            
            jsForAjaxContent(modal);
        }
    });
}

// show form modal
function showAddablelistModal(addablelist, url, title, selector) {
    var modal_size = addablelist.attr('modal-size');    
    
    // modal width
    if (typeof(modal_size) === 'undefined' || modal_size === '') {
        modal_size = 'md';
    }
    
    // create uid for addablelist if not exist
    var uid = addablelist.attr('rel');
    if (typeof(uid) === 'undefined' || uid === '') {
        uid = guid();
        addablelist.attr('rel', uid);
    }

    // create new modal if not exist
    var modal_uid = "addablelist-modal-" + uid;
    
    var modal = $('#' + modal_uid);
    if(!modal.length) {
        var html = '<div data-selector="' +selector+ '" id="' + modal_uid + '" addablelist="'+uid+'" class="modal addablelist-modal fade" tabindex="-1">' +
            '<div class="modal-dialog  modal-custom-blue modal-' + modal_size + '">' +
                '<div class="modal-content">' +
                    '<div class="modal-header">' +
                        '<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-close"></i></button>' +
                        '<h4 class="modal-title">' + title + '</h4>' +
                    '</div>' +
                    '<div class="modal-body">' +
                    '</div>' +
                '</div>' +
            '</div>' +
        '</div>';
        $('body').append(html);
        
        modal = $('#' + modal_uid);
    } else {
        modal.attr('data-selector', selector);
    }
    
    // show modal
    modal.addClass('in');
    modal.modal('show');
    modal.find('.modal-body').html('<div class="text-center"><i class="fa fa-circle-o-notch fa-spin"></i></div>');
    
    $.ajax({
        url: url,
    }).done(function( data ) {
        // get form
        html = $('<div>').html(data).find(selector)[0].outerHTML;
        modal.find('.modal-body').html(html);
        jsForAjaxContent(modal);
    });
}

var CURRENT_ADDABLELIST_LINE = 'none';
$(document).ready(function() {
    // Add button
    $(document).on('keyup focus', '.addablelist-add-button', function() {
        var addablelist = $(this).parents('.addablelist');
        var title = addablelist.attr('create-title');
        var url = addablelist.attr('create-url');
        var container_selector = addablelist.attr('container-selector');
        
        // remove current line selected
        CURRENT_ADDABLELIST_LINE = 'none';
        
        showAddablelistModal(addablelist, url, title, container_selector);
    });
    
    // modal form submit
    $(document).on('submit', '.addablelist-modal form', function(e) {
        e.preventDefault();
        
        // submit form
        submitAddablelistModalForm($(this));
    });
    
    // Edit
    $(document).on('click', '.addablelist-edit', function() {
        var addablelist = $(this).parents('.addablelist');
        var title = $(this).attr('data-title');
        var url = $(this).attr('data-url');
        var selector = $(this).attr('data-selector');
        
        // remove current line selected
        CURRENT_ADDABLELIST_LINE = $(this).parents('.addablelist-row');
        
        showAddablelistModal(addablelist, url, title, selector);
    });
    
    // modal form submit
    $(document).on('click', '.addablelist-delete', function() {        
        var link = $(this);
        var url = link.attr('data-url');
        var method = link.attr('data-method');
        
        if(typeof(method) === 'undefined' || method.trim() === '') {
            method = 'GET';
        }

        $.ajax({
            url: url,
            method: method,
            data: {
                'authenticity_token': AUTH_TOKEN
            }
        }).done(function( result ) {
            swal({
                title: result.message,
                text: '',
                type: result.type,
                allowOutsideClick: true,
                confirmButtonText: "OK"
            });
            
            // remove html
            link.parents('.addablelist-row').remove();
        });
    });
    
    // modal form submit
    $(document).on('click', '.addablelist-modal .btn-cancel', function(e) {
        e.preventDefault();
        
        // submit form
        $(this).parents('.addablelist-modal').modal('hide');
    });
});