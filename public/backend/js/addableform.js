function addableformAddLine(addableform) {
    var url = addableform.attr('partial-url');
    var partial = addableform.attr('partial');
    var container = addableform.find('.addableform-container');
    var type = addableform.attr('type');
    var add_control = $(addableform.attr('add-control-selector'));
    
    if(typeof(add_control) === 'undefined') {
        add_value = '';
    } else {
        add_value = add_control.val();
    }
    
    if(typeof(type) === 'undefined') {
        type = 'normal';
    }
    
    $.ajax({
        url: url,
        data: {
            partial: partial,
            add_value: add_value
        }
    }).done(function( result ) {
        if(type !== 'table') {
            container.append('<span class="addableform-line">' + result + '</span>');
        } else {
            container.append('<tr class="addableform-line">' + result + '</tr>');
        }
        
        // js for new content
        jsForAjaxContent(container.find('.addableform-line').last());
    });
}

$(document).ready(function() {
    $(document).on("click", ".addableform .add-button", function() {
        var addableform = $(this).parents('.addableform');
        
        addableformAddLine(addableform);
    });
    
    $(document).on("click", ".addableform .remove-button", function() {
        var addableformline = $(this).parents('.addableform-line');
        
        addableformline.remove();
    });
    
    $(document).on("click", ".addableform .nested-remove-button", function() {
        var addableformline = $(this).parents('.addableform-line');
        
        addableformline.find('input').each(function() {
            var name = $(this).attr('name');
            if(typeof(name) != 'undefined' && name.indexOf('_destroy') >= 0) {
                $(this).val('1');                
            }
        });
        
        addableformline.hide();
    });
});