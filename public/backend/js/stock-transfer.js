function calculateTransferDetails(container) {
    var rows = container.find('table tbody tr:visible');
    var quantity_total = 0;
    var total_stock_source = 0;
    var total_stock_destination = 0;
    var total_stock_source_after = 0;
    var total_stock_destination_after = 0;
    rows.each(function() {
        var row = $(this);
        var quantity = 0;
        if (row.find('.line_quantity').val() !== '') {
            quantity = customParseFloat(row.find('.line_quantity').val());
        }
        var stock_source = customParseFloat(row.find('.line_stock_source').html());
        var stock_destination = customParseFloat(row.find('.line_stock_destination').html());

        var stock_source_after = stock_source-quantity;
        var stock_destination_after = stock_destination+quantity;

        // update line stock source after
        row.find('.line_stock_source_after').html(stock_source_after);

        // update line total without tax
        row.find('.line_stock_destination_after').html(stock_destination_after);

        // add/remove class html
        if (stock_source_after < 0) {
            row.find('.line_stock_source_after').addClass('font-yellow-gold');
        } else {
            row.find('.line_stock_source_after').removeClass('font-yellow-gold');
        }

        // Update quantity total
        if (quantity) {
            quantity_total += quantity;
        }

        if (stock_source) {
            total_stock_source += stock_source;
        }

        if (stock_destination) {
            total_stock_destination += stock_destination;
        }

        total_stock_source_after += stock_source_after;
        total_stock_destination_after += stock_destination_after;
    });
    // update total
    $('.transfer-details .total_transfer').html(formatNumber(quantity_total));
    $('.transfer-details .total_stock_source_before').html(formatNumber(total_stock_source));
    $('.transfer-details .total_stock_source_after').html(formatNumber(total_stock_source_after));
    $('.transfer-details .total_stock_destination_before').html(formatNumber(total_stock_destination));
    $('.transfer-details .total_stock_destination_after').html(formatNumber(total_stock_destination_after));
}

// Main js execute when loaded page
$(document).ready(function() {
    $('.transfer-details').each(function() {
        calculateTransferDetails($(this));
    });

    // Change event on order line
    $(document).on('change keyup', '.transfer-details input', function(e) {
        var container = $(this).parents('.transfer-details');
        calculateTransferDetails(container);
    });

    // Click event nested remove button
    $(document).on('click', '.nested-remove-button', function(e) {
        var container = $(this).parents('.transfer-details');
        calculateTransferDetails(container);
    });
});
