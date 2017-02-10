function calculateOrderDetails(container) {
    var rows = container.find('table tbody tr');
    var order_total = 0;
    rows.each(function() {
        var row = $(this);
        var quantity = parseFloat(row.find('.line_quantity').val());
        var unit_price = parseFloat(row.find('.line_unit_price').val());
        var line_total = unit_price*quantity;
        
        // update line total
        row.find('.line_total').html(line_total);
        
        // Update order total
        if(line_total) {
            order_total = order_total + line_total;
        }
    });
    // update line total
    container.find('.order_total').html(order_total);
}

// Main js execute when loaded page
$(document).ready(function() {
    $('.order-details').each(function() {
        calculateOrderDetails($(this));
    });
    
    // Change event on order line
    $(document).on('change keyup', '.order-details input', function(e) {
        var container = $(this).parents('.order-details');
        calculateOrderDetails(container);
    });
});