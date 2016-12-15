function clearDataselectControlText(dataselect) {
    var control = dataselect.find('.dataselect-control');    
    
    control.val('');
}

function clearDataselectValue(dataselect) {
    var value_control = dataselect.find('.dataselect-value');
    var control = dataselect.find('.dataselect-control');
    var is_multiple = control.attr('multiple');
    
    if(!is_multiple) {
        value_control.val('');
    }
}

// check things after finish dataselect control by user
function afterFinishDataselect(dataselect) {
    var modal = $('#dataselect-modal-' + dataselect.attr('rel'));
    var control = dataselect.find('.dataselect-control');
    var selected_item = findDataselectControlTextMatched(dataselect);

    if(!selected_item) {
        if(control.attr('create-url')) {
            if(!modal.hasClass('in')) {
                showModalForm(dataselect, true);
            }
        } else {
            clearDataselectControlText(dataselect);
        }
    } else {
        selectDataselectItem(selected_item);
    }

    toggleDataselectData(dataselect);
}

// Get current dataselect
function getCurrentDataselect() {
    dataselect = $('[rel="' + $('.dataselect-modal.in').last().attr('dataselect') + '"]');

    return dataselect;
}

// 
function submitDataselectModalForm(form) {
    var dataselect = getCurrentDataselect();
    var control = dataselect.find('.dataselect-control');
    var method = form.attr('method');
    var url = form.attr('action');
    var modal = $('#dataselect-modal-' + dataselect.attr('rel'));
    
    modal.find('.modal-body').html('<div class="text-center"><i class="fa fa-circle-o-notch fa-spin"></i></div>');
    
    // form data
    var form_data = form.serializeArray();
    form_data.push({name: 'format', value: 'json'});
    
    $.ajax({
        type: method,
        url: url,
        data: form_data, // serializes the form's elements.
        success: function(data)
        {
            // get data
            container = $('<div>').html(data).find(control.attr('container-selector'));
            if (container.length) {
                modal.find('.modal-body').html(container[0].outerHTML);
            } else {
                if(typeof(data.status) !== 'undefined' && data.status === 'success') {
                    updateDataselectValue(getCurrentDataselect(), data.text, data.value);
                }
                
                modal.modal('hide');
                jsForAjaxContent(modal);
            }
        }
    });
}

// show create modal
function showModalForm(dataselect, with_keyword, is_edit) {
    var url, title, container;
    var control = dataselect.find('.dataselect-control');    
    var keyword = control.val().trim();
    var modal_size = control.attr('modal-size');
    var value_control = dataselect.find('.dataselect-value');
    
    // create with keyword but keyword is empty
    if((typeof(with_keyword) !== 'undefined' || with_keyword) && keyword === '') {
        return;
    }
    
    // modal width
    if (typeof(modal_size) === 'undefined' || modal_size === '') {
        modal_size = 'md';
    }
    
    // is edit ?
    if(typeof(is_edit) !== 'undefined' && is_edit) {
        url = control.attr('edit-url');
        title = control.attr('edit-title');
        container = control.attr('edit-container-selector');
        
        // replace id with value
        url = url.replace(':value', value_control.val());
    } else {
        url = control.attr('create-url');
        title = control.attr('create-title');
        container = control.attr('create-container-selector');
    }
    
    // set current select
    CURRENT_DATASELECT = dataselect;
    
    // create uid for dataselecy if not exist
    var uid = dataselect.attr('rel');
    if (typeof(uid) === 'undefined' || uid === '') {
        uid = guid();
        dataselect.attr('rel', uid);
    }
    
    // create new modal if not exist
    var modal_uid = "dataselect-modal-" + uid;
    var html = '<div id="'+modal_uid+'" dataselect="'+uid+'" class="modal dataselect-modal fade" tabindex="-1">' +
        '<div class="modal-dialog modal-' + modal_size + '">' +
            '<div class="modal-content">' +
                '<div class="modal-header">' +
                    '<button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>' +
                    '<h4 class="modal-title">' + title + '</h4>' +
                '</div>' +
                '<div class="modal-body">' +
                '</div>' +
            '</div>' +
        '</div>' +
    '</div>';
    $('body').append(html);
    var modal = $('#' + modal_uid);
    
    // show modal
    modal.addClass('in');
    modal.modal('show');
    modal.find('.modal-body').html('<div class="text-center"><i class="fa fa-circle-o-notch fa-spin"></i></div>');
    
    $.ajax({
        url: url,
    }).done(function( data ) {
        // get form
        html = $('<div>').html(data).find(container)[0].outerHTML;
        modal.find('.modal-body').html(html);
        
        // insert keyword to form
        if(typeof(with_keyword) !== 'undefined' && with_keyword) {            
            modal.find('.modal-body').find(control.attr('input-selector')).val(keyword);
        }
        
        jsForAjaxContent(modal);
        
        scrollToElement(dataselect, 140);
    });
}

// functionfind match item from dataselect list
function findDataselectControlTextMatched(dataselect) {
    var items = dataselect.find('.dataselect-item a');
    var current_text = dataselect.find('.dataselect-control').val().trim();
    var edit_button = dataselect.find('.dataselect-edit-button');
    var found;

    // update dataselect data
    items.each(function() {
        var text = $(this).html().trim();
        if(current_text.toLowerCase() === text.toLowerCase()) {
            found = $(this);
        }        
    });
    
    // empty control value if not found
    if(!found) {
        // clear input value
        clearDataselectValue(dataselect);
        
        // hide edit button
        edit_button.hide();
    }
    
    return found;
}

// update multiple value
function updateDataselectMultipleValues(dataselect) {
    var value_control = dataselect.find('.dataselect-value');
    
    value_control.val('');
}

// Get current value
function getDataselectCurrentValue(dataselect) {
    var value_control = dataselect.find('.dataselect-value');
    var control = dataselect.find('.dataselect-control');
    var is_multiple = control.attr('multiple');
    
    if(!is_multiple) {
        return value_control.val();
    } else {
        var values = [];
        dataselect.find('.dataselect-value-box input').each(function() {
            values.push($(this).val());
        });
        
        return values.join(',');
    }
}

// remove item from dataselect
function removeDataselectValueItem(item) {
    var dataselect = item.parents('.dataselect');
    var control = dataselect.find('.dataselect-control');
    
    item.remove();
    
    control.focus();
    updateDataselectData(dataselect);
}

// insert item to dataselect value if multiple
function insertDataselectValueItem(dataselect, text, value) {
    var value_control = dataselect.find('.dataselect-value');
    var control = dataselect.find('.dataselect-control');
    var group = dataselect.find('.multiselect-values-container');

    if(!dataselect.find('.dataselect-value-box input[value="' + value + '"]').length) {
        // insert html item
        var html = '<div class="btn-group btn-group-solid dataselect-value-box">' +
            '<input type="hidden" name="' + value_control.attr('name') + '" value="' + value + '">' +
            '<button type="button" class="btn btn-sm green-meadow dataselect-value-item">' + text + '</button>' +
            '<button type="button" class="btn btn-sm green-meadow remove-button"><i class="fa fa-close"></i></button></div> ';
        group.append(html);
        
        // update values
        updateDataselectMultipleValues(dataselect);
    }
    
    // wait for other action
    control.focus();
    updateDataselectData(dataselect);
}

// insert item to dataselect value if multiple
function updateDataselectSingleValue(dataselect, text, value) {
    var control = dataselect.find('.dataselect-control');
    var value_control = dataselect.find('.dataselect-value');
    
    control.val(text);
    value_control.val(value);
}

// update dataselect value
function updateDataselectValue(dataselect, text, value) {
    var control = dataselect.find('.dataselect-control');
    var edit_button = dataselect.find('.dataselect-edit-button');
    var is_multiple = control.attr('multiple');
    
    if(!is_multiple) {
        updateDataselectSingleValue(dataselect, text, value);
    } else {
        // insert item to dataselect values
        insertDataselectValueItem(dataselect, text, value);
        clearDataselectControlText(dataselect);
    }
    
    // show edit button
    edit_button.show();
}

// dataselect select an item
function selectDataselectItem(item) {
    var dataselect = item.parents('.dataselect');
    var text = item.html();
    var value = item.attr('data-value');
    
    updateDataselectValue(dataselect, text, value);
}

//
function toggleDataselectCreateNewLine(dataselect) {
    var create_new_line = dataselect.find(".create-new");
    var create_new_name = dataselect.find(".dataselect-new-name");
    var control = dataselect.find('.dataselect-control');
    var value = control.val().trim();
    
    if(!findDataselectControlTextMatched(dataselect) && value !== '') {
        create_new_line.show();
        create_new_name.html(value);
    } else {
        create_new_line.hide();
    }
}

// update dataselect data list
function updateDataselectData(dataselect) {
    var databox = dataselect.find('.dataselect-data');
    var control = dataselect.find('.dataselect-control');
    var url = control.attr('data-url');
    var keyword = control.val();
    var dataselect_hook = databox.find('.dataselect-hook');
    
    var current_value = getDataselectCurrentValue(dataselect);
    
    if(CURRENT_DATASELECT_XHR && CURRENT_DATASELECT_XHR.readyState != 4){
		CURRENT_DATASELECT_XHR.abort();
	}
    CURRENT_DATASELECT_XHR = $.ajax({
        url: url,
        data: {
            'keyword': keyword,
            'current_value': current_value
        }
    }).done(function( options ) {
        // remove old data
        databox.find('.dataselect-item, .dataselect-empty').remove();
        
        // update dataselect data
        options.forEach(function(option) {
            var html = '<li class="dataselect-item">' +
                            '<a href="javascript:;" data-value="' + option.value + '">' + option.text + '</a>' +
                        '</li>';                        
            dataselect_hook.before(html);
        });
        
        // if options is empty
        if(!options.length) {
            var html = '<li class="dataselect-empty">' +
                            '<a href="javascript:;">' + LANG_NO_RECORD_FOUND + '</a>' +
                        '</li>';                        
            dataselect_hook.before(html);
        }
        
        // check item exists
        toggleDataselectCreateNewLine(dataselect);
    });
}

// show/hide dataselect data
function toggleDataselectData(dataselect) {
    var databox = dataselect.find('.dataselect-data');
    var control = dataselect.find('.dataselect-control');
    
    if(control.is(":focus")) {
        dataselect.addClass('active');
        databox.show();
    } else {
        dataselect.removeClass('active');
        databox.hide();
    }    
}

// Main js execute when loaded page
var CURRENT_DATASELECT;
var CURRENT_DATASELECT_XHR;
$(document).ready(function() {
    // Datalist search input
    $(document).on('keyup focus', '.dataselect .dataselect-control', function() {
        var dataselect = $(this).parents('.dataselect');
        toggleDataselectData(dataselect);
    });
    
    // Update dataselect data
    $(document).on('keyup click', '.dataselect .dataselect-control', function() {
        var dataselect = $(this).parents('.dataselect');
        updateDataselectData(dataselect);
    });
    
    // Select dataselect item
    $(document).on('click', '.dataselect .dataselect-item a', function(e) {
        e.preventDefault();
        
        var item = $(this);
        selectDataselectItem(item);
    });
    
    // when blur dataselect control
    $(document).on("blur",".dataselect .dataselect-control", function() { 
        var dataselect = $(this).parents('.dataselect');
        
        // wait for other action
        setTimeout(function() {
            afterFinishDataselect(dataselect);
        }, 200);        
    });
    
    // Show creat new modal
    $(document).on('click', '.dataselect .create-edit a', function() {
        var dataselect = $(this).parents('.dataselect');
        showModalForm(dataselect);
    });
    
    // Show creat new modal
    $(document).on('click', '.dataselect .create-new a', function() {
        var dataselect = $(this).parents('.dataselect');        
        showModalForm(dataselect, true);
    });
    
    // modal form submit
    $(document).on('submit', '.dataselect-modal form', function(e) {
        e.preventDefault();
        
        // submit form
        submitDataselectModalForm($(this));
    });
    
    // modal form submit
    $(document).on('click', '.dataselect-modal .btn-cancel', function(e) {
        e.preventDefault();
        
        // submit form
        $(this).parents('.dataselect-modal').modal('hide');
    });
    
    // edit button click
    $(document).on('click', '.dataselect-edit-button', function() {
        var dataselect = $(this).parents('.dataselect');
        
        // show edit modal
        showModalForm(dataselect, false, true);
    });
    
    // remove dataselect item
    $(document).on('click', '.dataselect-value-box .remove-button', function() {
        var item = $(this).parents('.dataselect-value-box');
        removeDataselectValueItem(item);
    });
    
    // for related dataselect
});