function addableformAddLine(addableform) {
    var url = addableform.attr('partial-url');
    var partial = addableform.attr('partial');
    var container = addableform.find('.addableform-container');
    
    $.ajax({
        url: url,
        data: {
            partial: partial
        }
    }).done(function( result ) {
        container.append('<span class="addableform-line">' + result + '</span>');
        
        // js for new content
        jsForAjaxContent(container.find('.addableform-line').last());
    });
}

$(document).ready(function() {
    $(document).on("click", ".addableform .add-button", function() {
        var addableform = $(this).parents('.addableform');
        
        addableformAddLine(addableform);
    });
    
    $(document).on("click", ".addableform .add-button", function() {
        var addableform = $(this).parents('.addableform');
        
        addableformAddLine(addableform);
    });
    
    $(document).on("click", ".addableform .remove-button", function() {
        var addableformline = $(this).parents('.addableform-line');
        
        addableformline.remove();
    });
});