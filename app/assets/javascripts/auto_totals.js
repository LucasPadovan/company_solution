var AutoTotals = {
  listenItemChanges: function() {

  },

  listenFormChanges: function() {
    var subtotalFields = '.js-nested-item-subtotal',
        taxFields = '.js-nested-item-tax';

    $(document).on('change', subtotalFields, function() {
      AutoTotals._setSubtotal();
      AutoTotals._setTotal();
    });

    $(document).on('change', taxFields, function() {
      AutoTotals._setTax();
      AutoTotals._setTotal();
    });
  },

  checkFormConsistency: function() {
    // Add a red indicator when the form loads and taxes, subtotals or totals doesnt match
  },

  /* DOM handling */
  _setSubtotal: function() {
    $('.js-form-subtotal').val(AutoTotals._calculateSubtotals().toFixed(2));
  },

  _setTax: function() {
    $('.js-form-tax').val(AutoTotals._calculateTaxes().toFixed(2));
  },

  _setTotal: function() {
    $('.js-form-total').val(AutoTotals._calculateTotal().toFixed(2));
  },
  /* DOM handling */

  /* Calculations */
  _calculateSubtotals: function() {
    var $subtotalFields = $('.js-nested-item-subtotal'),
        subtotal = 0.0;

    $.each($subtotalFields, function(index, value) {
      var subtotalText = $(value).val();

      if (subtotalText) {
        subtotal += parseFloat(subtotalText);
      }
    });

    return subtotal;
  },

  _calculateTaxes: function() {
    var $taxFields = $('.js-nested-item-tax'),
        tax = 0.0;

    $.each($taxFields, function(index, value) {
      var taxText = $(value).val();

      if (taxText) {
        tax += parseFloat(taxText);
      }
    });

    return tax;
  },

  _calculateTotal: function() {
    var total,
        subtotal = $('.js-form-subtotal').val() || 0,
        tax = $('.js-form-tax').val() || 0;

    total = parseFloat(subtotal) + parseFloat(tax);

    return total;
  },
  /* Calculations */

  init: function() {
    this.listenFormChanges();
    this.listenItemChanges();
    this.checkFormConsistency();
  }
}
