// All this doesn't work for more than one line FK

var AutoTotals = {
  listenItemChanges: function() {
    var lineFields = [
          '.js-nested-item-amount',
          '.js-nested-item-unit_price',
          '.js-nested-item-tax_rate',
          '.js-nested-item-destroy'
        ];

    $.each(lineFields, function(index, lineField) {
      $(document).on('change', lineField, function() {
        AutoTotals._setLineSubtotal(this);
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

  _setLineSubtotal: function(context) {
    var lineValues = AutoTotals._calculateLineSubtotal(context),
        $fieldset = $(context).parents('.js-nested-item-row'),
        $taxField = $fieldset.find('.js-nested-item-tax'),
        $subtotalField = $fieldset.find('.js-nested-item-subtotal'),
        $lineTotalField = $fieldset.find('.js-nested-item-line-total'),
        lineTotal = lineValues['tax'] + lineValues['subtotal'];

    $taxField.val(lineValues['tax'].toFixed(2));
    $subtotalField.val(lineValues['subtotal'].toFixed(2));
    $lineTotalField.val(lineTotal.toFixed(2));

    // Probably will have to merge these two.
    $taxField.trigger('change');
    $subtotalField.trigger('change');
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

  _calculateLineSubtotal: function(context) {
    var $fieldset = $(context).parents('.js-nested-item-row'),
        isFieldsetValid = $fieldset.find('.js-nested-item-destroy').val() !== '1',
        amount,
        unitPrice,
        taxRate,
        tax = 0,
        subtotal = 0;

    if (isFieldsetValid) {
      amount = parseFloat($fieldset.find('.js-nested-item-amount').val()) || 0;
      unitPrice = parseFloat($fieldset.find('.js-nested-item-unit_price').val()) || 0;
      taxRate = parseFloat($fieldset.find('.js-nested-item-tax_rate').val()) || 0;

      subtotal = amount * unitPrice;
      tax = subtotal * taxRate / 100;
    }

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
