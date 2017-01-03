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
        container.append(result);
    });
}

$(document).ready(function() {
    $(document).on("click", ".addableform .add-button", function() {
        var addableform = $(this).parents('.addableform');
        
        addableformAddLine(addableform);
    });
});