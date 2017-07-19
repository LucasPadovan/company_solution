// All this doesn't work for more than one line FK

var AutoTotals = {
  listenItemChanges: function() {
    var lineFields = [
        '.js-nested-item-amount',
        '.js-nested-item-unit_price',
        '.js-nested-item-tax_rate',
        ];

    $.each(lineFields, function(index, lineField) {
      $(document).on('change', lineField, function() {
        AutoTotals._setLineSubtotal();
      });
    });
  },

  listenFormChanges: function() {
    var subtotalFields = '.js-nested-item-subtotal',
        taxFields = '.js-nested-item-tax';

    $(document).on('change', subtotalFields, function() {
      AutoTotals._setFormSubtotal();
      AutoTotals._setFormTotal();
    });

    $(document).on('change', taxFields, function() {
      AutoTotals._setFormTax();
      AutoTotals._setFormTotal();
    });
  },

  checkFormConsistency: function() {
    // Add a red indicator when the form loads and taxes, subtotals or totals doesnt match
  },

  /* DOM handling */
  _setFormSubtotal: function() {
    $('.js-form-subtotal').val(AutoTotals._calculateFormSubtotals().toFixed(2));
  },

  _setFormTax: function() {
    $('.js-form-tax').val(AutoTotals._calculateFormTaxes().toFixed(2));
  },

  _setFormTotal: function() {
    $('.js-form-total').val(AutoTotals._calculateFormTotal().toFixed(2));
  },

  _setLineSubtotal: function() {
    var lineValues = AutoTotals._calculateLineSubtotal();

    $('.js-nested-item-tax').val(lineValues['tax'].toFixed(2));
    $('.js-nested-item-subtotal').val(lineValues['subtotal'].toFixed(2));

    // For some reason this set doesn't trigger onchange on listenFormChanges
    AutoTotals._setFormTax();
    AutoTotals._setFormSubtotal();
    AutoTotals._setFormTotal();
  },
  /* DOM handling */

  /* Calculations */
  _calculateFormSubtotals: function() {
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

  _calculateFormTaxes: function() {
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

  _calculateFormTotal: function() {
    var total,
        subtotal = $('.js-form-subtotal').val() || 0,
        tax = $('.js-form-tax').val() || 0;

    total = parseFloat(subtotal) + parseFloat(tax);

    return total;
  },

  _calculateLineSubtotal: function() {
    var amount = parseFloat($('.js-nested-item-amount').val()) || 0,
        unitPrice = parseFloat($('.js-nested-item-unit_price').val()) || 0,
        taxRate = parseFloat($('.js-nested-item-tax_rate').val()) || 0,
        tax,
        netValue,
        subtotal;

    netValue = amount * unitPrice;
    tax = netValue * taxRate / 100;
    subtotal = netValue + tax;

    return {
      tax: tax,
      subtotal: subtotal
    };
  },
  /* Calculations */

  init: function() {
    this.listenFormChanges();
    this.listenItemChanges();
    this.checkFormConsistency();
  }
}
