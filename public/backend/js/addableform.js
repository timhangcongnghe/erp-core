function addableformAddLine(addableform) {
    var url = addableform.attr('partial-url');
    var partial = addableform.attr('partial');
    var container = addableform.find('.addableform-container');
    var type = addableform.attr('type');
    var add_control = addableform.find(addableform.attr('add-control-selector'));
    var items = container.find('.item-id');

    if(typeof(add_control) === 'undefined') {
        add_value = '';
    } else {
        add_value = add_control.val();
    }

    if(typeof(type) === 'undefined') {
        type = 'normal';
    }

    var exist_ids = [];
    if(items.length) {
        items.each(function () {
            var id = $(this).attr('value');
            exist_ids.push(id);
        });
    }

    // More global filter
    var form_data = {};
    arr = addableform.closest('form').serializeArray();
    for (var i = 0; i < arr.length; i++){
        if (i <= 10 ) {
            var name = arr[i]['name'];
            if (name.indexOf('[]') !== -1) {
                name = name.substr(0,name.length-2)
            }
            if (form_data[name]) {
                if (form_data[name].constructor !== Array) {
                    form_data[name] = [form_data[name]];
                }
                form_data[name].push(arr[i]['value']);
            } else {
                form_data[name] = arr[i]['value'];
            }
        }
    }

    if(add_value != '') {
        $.ajax({
            url: url,
            data: {
                partial: partial,
                add_value: add_value,
                exist_ids: exist_ids,
                form: form_data
            }
        }).done(function( result ) {
            if(type !== 'table') {
                container.prepend('<span class="addableform-line">' + result + '</span>');
            } else {
                if ($('<div>').html(result).find('tr').length) {
                    container.prepend(result);
                } else {
                    container.prepend('<tr class="addableform-line">' + result + '</tr>');
                }
            }

            clearDataselectControlText(add_control.parents('.dataselect'));
            clearDataselectValue(add_control.parents('.dataselect'));

            // js for new content
            jsForAjaxContent(container.find('.addableform-line').first());
        });
    }
}

$(document).ready(function() {
    $(document).on("click", ".addableform .add-button", function() {
        var addableform = $(this).parents('.addableform');

        addableformAddLine(addableform);
    });

    $(document).on("click", ".addableform .remove-button", function() {
        var addableformline = $(this).parents('.addableform-line');

        addableformline.next('.addableform-more').remove();
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

        addableformline.next('.addableform-more').hide();
        addableformline.hide();
        addableformline.find('input, select').addClass('jvalidate_ignore');
    });

    // addable form enter
    $(document).on("keyup", "body", function(e) {
        if (e.which == 13) {
            $('.addableform').each(function() {
                var input = $(this).find('.dataselect-control');

                if(input.length && input.val() != '') {
                    $(this).find('.add-button').click();
                }
            });
        }
    });
});
