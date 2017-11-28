//function formatNumber(num) {
//    return num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1.");
//}

function updateDefaultPrice(row) {
    var quantity = customParseFloat(row.find('.line_quantity').val());
    if (row.find('.line_fill_price').html() !== '') {
        var price = customParseFloat(row.find('.line_fill_price').html());
        row.find('.line_unit_price').val(formatNumber(price)).change();
    }

    calculateOrderDetails(row.closest('.order-details'));
}

function updateDefaultCommission(row) {
    var line_subtotal = customParseFloat(row.find('.line_subtotal').html());
    var discount_amount = 0;

    if (row.find('.line_discount_amount').val() !== '') {
        discount_amount = customParseFloat(row.find('.line_discount_amount').val());
    }

    var c_total = line_subtotal - discount_amount;

    var customer_commission_percent;
    if (row.find('.line_customer_commission_percent').html() !== '') {
        customer_commission_percent = customParseFloat(row.find('.line_customer_commission_percent').html());
    } else {
        customer_commission_percent = 0;
    }

    var customer_commission_amount = (c_total*customer_commission_percent)/100;
    if (customer_commission_amount > 0) {
        row.find('.line_customer_commission_amount').val(formatNumber(customer_commission_amount));
    } else {
        row.find('.line_customer_commission_amount').val('');
    }

    calculateOrderDetails(row.closest('.order-details'));
}

function calculateOrderDetails(container) {
    var rows = container.find('table tbody tr:visible');
    var order_quantity = 0;
    var order_total = 0;
    rows.each(function() {
        var row = $(this);
        var quantity = customParseFloat(row.find('.line_quantity').val());
        //if (row.find('.line_fill_price').html() !== '') {
        //    var price = customParseFloat(row.find('.line_fill_price').html());
        //    row.find('.line_unit_price').val(formatNumber(price));
        //}
        var unit_price = customParseFloat(row.find('.line_unit_price').val());
        var discount_amount = 0;
        var shipping_amount = 0;
        var line_tax = 0;
        if (row.find('.line_discount_amount').val() !== '') {
            discount_amount = customParseFloat(row.find('.line_discount_amount').val());
        }
        if (row.find('.line_shipping_amount').val() !== '') {
            shipping_amount = customParseFloat(row.find('.line_shipping_amount').val());
        }

        var line_subtotal = unit_price*quantity;
        var line_total_without_tax = line_subtotal - discount_amount + shipping_amount;
        var line_total = line_total_without_tax + line_tax;

        // update line subtotal
        row.find('.line_subtotal').html(formatNumber(line_subtotal));

        // update line total without tax
        row.find('.line_line_total_without_tax').html(formatNumber(line_total_without_tax));

        // update line total
        row.find('.line_total').html(formatNumber(line_total));

        //if (row.find('.line_customer_commission_percent').html() !== '') {
        //    var customer_commission_percent = customParseFloat(row.find('.line_customer_commission_percent').html());
        //} else {
        //    var customer_commission_percent = 0;
        //}
        //
        //var customer_commission_amount = (line_total*customer_commission_percent)/100;
        //if (customer_commission_amount > 0) {
        //    row.find('.line_customer_commission_amount').val(formatNumber(customer_commission_amount));
        //} else {
        //    row.find('.line_customer_commission_amount').val();
        //}

        // Update order total
        if(quantity) {
            order_quantity += quantity;
        }
        if(line_total) {
            order_total = order_total + line_total;
        }
    });
    // update line total
    container.find('.order_quantity').html(formatNumber(order_quantity));
    container.find('.order_total').html(formatNumber(order_total));
}

// Main js execute when loaded page
$(document).ready(function() {
    $('.order-details').each(function() {
        calculateOrderDetails($(this));
    });

    //// Event DOM subtree modified
    //$(document).on('DOMSubtreeModified', '.default_price_info', function(){
    //    var row = $(this).closest('td');
    //    var quantity = customParseFloat(row.find('.line_quantity').val());
    //    if (row.find('.line_fill_price').html() !== '') {
    //        var price = customParseFloat(row.find('.line_fill_price').html());
    //        row.find('.line_unit_price').val(formatNumber(price));
    //    }
    //
    //    calculateOrderDetails($(this));
    //});
    //
    //// Event DOM subtree modified - commistion
    //$(document).on('DOMSubtreeModified', '.default_customer_commission_info', function(){
    //    var row = $(this).closest('tr');
    //
    //    var line_subtotal = customParseFloat(row.find('.line_subtotal').html());
    //    var discount_amount = 0;
    //
    //    if (row.find('.line_discount_amount').val() !== '') {
    //        discount_amount = customParseFloat(row.find('.line_discount_amount').val());
    //    }
    //
    //    var c_total = line_subtotal - discount_amount;
    //
    //    var customer_commission_percent;
    //    if (row.find('.line_customer_commission_percent').html() !== '') {
    //        customer_commission_percent = customParseFloat(row.find('.line_customer_commission_percent').html());
    //    } else {
    //        customer_commission_percent = 0;
    //    }
    //
    //    var customer_commission_amount = (c_total*customer_commission_percent)/100;
    //    if (customer_commission_amount > 0) {
    //        row.find('.line_customer_commission_amount').val(formatNumber(customer_commission_amount));
    //    } else {
    //        row.find('.line_customer_commission_amount').val('');
    //    }
    //
    //    calculateOrderDetails($(this));
    //});

    // Change event on order line
    $(document).on('change', '.order-details input:not(.line_customer_commission_amount)', function(e) {
        var container = $(this).parents('.order-details');
        calculateOrderDetails(container);
    });

    // Click event nested remove button
    $(document).on('click', '.nested-remove-button', function(e) {
        var container = $(this).parents('.order-details');
        calculateOrderDetails(container);
    });
});
