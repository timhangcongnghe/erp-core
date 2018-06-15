$.fn.autolist = function(action, param) {
    box = this;
    container = box.find('.autolist-container');
    line_url = box.attr('data-line-url');

    // Event
    // Click remove button
    $(document).on('click', '.autolist .remove-line', function() {
        var line = $(this).closest('.autolist-line');

        line.find('.destroy_input').val('true');
        line.find('input, select').addClass('jvalidate_ignore');
        line.hide();
    });
    // Click add button
    $(document).on('click', '.autolist .add-line', function() {
        $.ajax({
            url: line_url,
            method: 'GET'
        }).done(function( row ) {
            container.append( row );
            jsForAjaxContent(container.find('.autolist-line').last());
        });
    });
    // Auto update line
    $(document).on('change', '.autolist select, .autolist input', function() {
        var input = $(this);
        var line = input.closest('.autolist-line');

        setTimeout(function() {
            var formData = new FormData();
            line.find('input, select, textarea').each(function() {
                formData.append($(this).attr('name'), $(this).val());
            });
            line.css('opacity', 0.5);
            
            formData.append('current_control', input.attr('name'));

            $.ajax({
                url: line_url,
                method: 'POST',
                data: formData,
                processData: false,
                contentType: false,
            }).done(function( row ) {
                line.html( $('<div>').html(row).find('.autolist-line').html() );

                line.css('opacity', 1);

                jsForAjaxContent(line);
            });
        }, 150);
    });

    // action / param
    if (typeof(action) !== 'undefined') {
        switch(action) {
            // Update value for dataselect
            case 'val':

                break;
        }

        return;
    }

    return box;
};
