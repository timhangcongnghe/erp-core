// functionfind match item from dataselect list
function findDataselectMatchedItem(dataselect) {
    var items = dataselect.find('.dataselect-item a');
    var current_text = dataselect.find('.dataselect-control').val().trim();
    var found = false;

    // update dataselect data
    items.each(function() {
        var text = $(this).html().trim();
        if(current_text.toLowerCase() === text.toLowerCase()) {
            selectDataselectItem($(this));
            found = true;
        }        
    });
    
    // deselect if not found
    if(!found) {
        dataselect.find('.dataselect-value').val('');
    }
}

// dataselect select an item
function selectDataselectItem(item) {
    var dataselect = item.parents('.dataselect');
    var control = dataselect.find('.dataselect-control');
    var value_control = dataselect.find('.dataselect-value');
    var text = item.html();
    var value = item.attr('data-value');
    
    control.val(text);
    value_control.val(value);
}

//
function checkDataselectEmptyOrNot(dataselect) {
    var empty = dataselect.find(".dataselect-item").length === 0;
    var create_new_line = dataselect.find(".create-new");
    var create_new_name = dataselect.find(".dataselect-new-name");
    var control = dataselect.find('.dataselect-control');
    var value = control.val();
    
    if(empty) {
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
    
    $.ajax({
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
        checkDataselectEmptyOrNot(dataselect);
        
        // find match item from dataselect list
        if(!control.is(":focus")) {
            findDataselectMatchedItem(dataselect);
        }
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
    }
    
}

// Main js execute when loaded page
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
    
    $('.dataselect .dataselect-control').bind('blur', function () {
        var dataselect = $(this).parents('.dataselect');
        findDataselectMatchedItem(dataselect);
        toggleDataselectData(dataselect);
    });
    
    // dataslect hide when click outside
    $(document).mouseup(function (e)
    {
        var container = $(".dataselect-control");
        var helper = $(".dataselect-data");
        
        // if the target of the click isn't the container...
        if (!container.is(e.target) && container.has(e.target).length === 0) // ... nor a descendant of the container
        {
            helper.hide();
        }
    });
    
    // Select dataselect item
    $(document).on('click', '.dataselect .dataselect-item a', function() {
        var item = $(this);
        selectDataselectItem(item);
    });
});