function calculateOrderDetails(container) {
    var rows = container.find('table tbody tr:visible');
    var order_total = 0;
    rows.each(function() {
        var row = $(this);
        var quantity = parseFloat(row.find('.line_quantity').val());
        var unit_price = parseFloat(row.find('.line_unit_price').val());
        var discount_amount = 0;
        var shipping_amount = 0;
        var line_tax = 0;
        if (row.find('.line_discount_amount').val() !== '') {
            discount_amount = parseFloat(row.find('.line_discount_amount').val());
        }
        if (row.find('.line_shipping_amount').val() !== '') {
            shipping_amount = parseFloat(row.find('.line_shipping_amount').val());
        }
        
        var line_subtotal = unit_price*quantity;
        var line_total_without_tax = line_subtotal - discount_amount + shipping_amount;
        var line_total = line_total_without_tax + line_tax;
        
        // update line subtotal
        row.find('.line_subtotal').html(line_subtotal);
        
        // update line total without tax
        row.find('.line_line_total_without_tax').html(line_total_without_tax);
        
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
    
    // Click event nested remove button
    $(document).on('click', '.nested-remove-button', function(e) {
        var container = $(this).parents('.order-details');
        calculateOrderDetails(container);
    });
});