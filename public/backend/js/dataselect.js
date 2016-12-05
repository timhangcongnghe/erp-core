//
function submitDataselectModalForm(form) {
    var dataselect = item.parents('.dataselect');
    var control = dataselect.find('.dataselect-control');
    var method = form.attr('method');
    var url = form.attr('action');
    
    var params = form.serializeArray();
    var dataselect = {
          name: "dataselect",
          value: "true"
    };
    params.push(dataselect);
    
    $.ajax({
        type: method,
        url: url,
        data: params, // serializes the form's elements.
        success: function(data)
        {
            // get data
            container = $('<div>').html(data).find(control.attr('container-selector'));
            if (container.length) {
                html = container.html();
                $('#dataselect-modal .modal-body').html(html);
            } else {                    
                $('#dataselect-modal').modal('hide');
                
                if(typeof(data.status) !== 'undefined' && data.status === 'success') {
                    updateDataselectValue(CURRENT_DATASELECT, data.text, data.value);
                }
            }
        }
    });
}

// show create modal
function showCreateModalContent(dataselect, with_keyword) {
    var control = dataselect.find('.dataselect-control');
    var create_url = control.attr('create-url');
    var create_title = control.attr('create-title');
    
    // set current select
    CURRENT_DATASELECT = dataselect;
    
    // show modal
    $('#dataselect-modal').addClass('in');
    $('#dataselect-modal').modal('show');
    $('#dataselect-modal .modal-body').html('<div class="text-center"><i class="fa fa-circle-o-notch fa-spin"></i></div>');
    
    $.ajax({
        url: create_url,
    }).done(function( data ) {
        $('#dataselect-modal .modal-title').html(create_title);
        
        // get form
        container = $('<div>').html(data).find(control.attr('container-selector'));
        $('#dataselect-modal .modal-body').html(container);
        
        //
        if(typeof(with_keyword) !== 'undefined' && with_keyword) {
            var value = dataselect.find('.dataselect-new-name').html().trim();
            $('#dataselect-modal .modal-body').find(control.attr('input-selector')).val(value);
        }
    });
}

// functionfind match item from dataselect list
function findDataselectControlTextMatched(dataselect) {
    var items = dataselect.find('.dataselect-item a');
    var current_text = dataselect.find('.dataselect-control').val().trim();
    var value_control = dataselect.find('.dataselect-value');
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
        value_control.val('');
    }
    
    return found;
}

// update dataselect value
function updateDataselectValue(dataselect, text, value) {
    var control = dataselect.find('.dataselect-control');
    var value_control = dataselect.find('.dataselect-value');

    control.val(text);
    value_control.val(value);
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
    
    if(CURRENT_DATASELECT_XRC && CURRENT_DATASELECT_XRC.readyState != 4){
		CURRENT_DATASELECT_XRC.abort();
	}
    CURRENT_DATASELECT_XRC = $.ajax({
        url: url,
        data: {
            'keyword': keyword
        }
    }).done(function( options ) {
        // remove old data
        databox.find('.dataselect-item').remove();
        
        // update dataselect data
        options.forEach(function(option) {
            var html = '<li class="dataselect-item">' +
                            '<a href="javascript:;" data-value="' + option.value + '">' + option.text + '</a>' +
                        '</li>';
                        
            dataselect_hook.before(html);
        });
        
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
var CURRENT_DATASELECT_XRC;
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
    $('.dataselect .dataselect-control').bind('blur', function () {
        var dataselect = $(this).parents('.dataselect');
        
        // wait for other action
        setTimeout(function() {            
            var selected_item = findDataselectControlTextMatched(dataselect);
            
            if(!selected_item) {            
                if(!$('#dataselect-modal').hasClass('in')) {
                    showCreateModalContent(dataselect, true);
                }
            } else {
                selectDataselectItem(selected_item);
            }
    
            toggleDataselectData(dataselect);
        }, 500);        
    });
    
    // Show creat new modal
    $(document).on('click', '.dataselect .create-edit a', function() {
        var dataselect = $(this).parents('.dataselect');
        showCreateModalContent(dataselect);
    });
    
    // Show creat new modal
    $(document).on('click', '.dataselect .create-new a', function() {
        var dataselect = $(this).parents('.dataselect');        
        showCreateModalContent(dataselect, true);
    });
    
    // modal form submit
    $(document).on('submit', '#dataselect-modal form', function(e) {
        e.preventDefault();
        
        // submit form
        submitDataselectModalForm($(this));
    });
    
    // modal form submit
    $(document).on('click', '#dataselect-modal .btn-cancel', function(e) {
        e.preventDefault();
        
        // submit form
        $('#dataselect-modal').modal('hide');
    });
});