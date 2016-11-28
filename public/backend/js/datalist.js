
// check checkable li item
function checkCheckableItem(li) {
    if(li.hasClass('checked')) {
        li.removeClass('checked');
    } else {            
        li.addClass('checked');
    }
}

function getUrlParameter(url, sParam) {
    var sPageURL = decodeURIComponent(url.split('?')[1]),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
}

// Add item to list search
function addItemToListSearch(list, ors, label) {
    var box = list.find('.list-search-items');
    var html = '';
    var texts = [];
    var ids = [];
    
    ors.forEach(function(entry) {
        texts.push(entry.text);
        ids.push(entry.id);
    });
    
    html = '<div class="btn-group btn-group-solid list-search-item" data-ids="' + ids.join(',') + '">' +
        '<button type="button" class="btn btn-sm green-meadow">' +
            label +
        '</button>' +
        '<button type="button" class="btn btn-sm grey">' +
            texts.join(' <span class="or-cond">' + LANG_OR +'</span> ') +
        '</button>' +
        '<button type="button" class="btn btn-sm grey cancel-button"><i class="fa fa-close"></i></button>' +
    '</div>';
    
    box.append(html);
}

// Add filters to list search items
function addItemsToListSearch(list, items, label) {
    items.forEach(function(ors) {
        addItemToListSearch(list, ors, label);
    });
}

// Get values from checkable list items
function getValuesFromCheckableList(items) {
    var conditions = [];
    var ors = [];
    items.each(function() {
        var id = $(this).attr('data-id');
        var name = $(this).attr('name');
        var value = $(this).attr('value');
        var text = $(this).find('a').html();
        var checked = $(this).hasClass('checked');
        
        // Push conditions to ors array
        if(typeof(name) !== 'undefined' && name.trim() !== '') {
            if(checked) {
                if(typeof(text) == 'undefined') {
                    text = '';
                }
                ors.push({'id': id, 'name': name, 'value': value, 'text': text.trim()});
            }
        }
        
        // Check if end of ors
        if($(this).hasClass('divider') && ors.length) {
            conditions.push(ors);
            ors = [];
        }
    });
    // Add last one
    if(ors.length) {
        conditions.push(ors);
    }
    
    return conditions;
}

// Filter all datalists in current page
function datalistFilterAll() {
    $('.datalist').each(function() {
        datalistFilter($(this));
    });
}

// Filter a datalist
function datalistFilter(list, page) {
    var url = list.attr('data-url');
    var id = list.attr('data-id');
    
    // check page
    if(typeof(page) == 'undefined') {
        page = 1;
    }
    
    // save current page
    list.attr('data-page', page);
    
    // Clear list search
    list.find('.list-search-items').html('');
    
    // Filters
    var filters = getValuesFromCheckableList(list.find('.datalist-filters li'));
    addItemsToListSearch(list, filters, '<i class="fa fa-filter"></i>');
    
    // Columns
    var columns = getValuesFromCheckableList(list.find('.datalist-columns-select li'));
    
    // ajax update custom sort
	if(datalists[id] && datalists[id].readyState != 4){
		datalists[id].abort();
	}
    datalists[id] = $.ajax({
        url: url,
        method: 'POST',
        data: {
            'authenticity_token': AUTH_TOKEN,
            'filters': filters,
            'columns': columns,
            'page': page
        },
    }).done(function( html ) {
        list.find(".datalist-container" ).html( html );
    });
}

var datalists= {};
// Main js execute when loaded page
$(document).ready(function() {
    // Filter all datalists in first load
    datalistFilterAll();
    
    // Filters group link click    
    $(document).on('click', '.btn-group-checkable .dropdown-menu>li>a', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        var li = $(this).parents('li');
        
        checkCheckableItem(li);
    });
    
    // Filter when click checkable items
    $(document).on('click', '.btn-group-checkable .dropdown-menu>li>a', function() {
        var list = $(this).parents('.datalist');
        datalistFilter(list);
    });
    
    // Change page
    $(document).on("click", ".datalist .pagination a", function(e) {
        var url = $(this).attr("href");
        var list = $(this).parents('.datalist');
        var page = getUrlParameter(url, 'page');
        
        datalistFilter(list, page);

        e.preventDefault();
        e.stopPropagation();
        e.stopImmediatePropagation();
    });
    
    // Remove item from search list
    $(document).on("click", ".list-search-item .cancel-button", function(e) {
        var item = $(this).parents('.list-search-item');
        var ids = item.attr('data-ids');
        var list = $(this).parents('.datalist');
        
        ids.split(",").forEach(function(id) {
            checkCheckableItem($('[data-id="' + id + '"]'));
        });
        
        datalistFilter(list);
    });
});
