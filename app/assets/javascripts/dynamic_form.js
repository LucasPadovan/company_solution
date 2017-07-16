var DynamicForm = {
  handleRemoveFieldset: function() {
    $('form').on('click', '.js-remove-fieldset', function (event) {
      event.preventDefault();

      DynamicForm._removeFieldset(this);
    });
  },

  handleAddFieldset: function() {
    var $form = $('form');

    $form.on('click', '.js-add-fieldset', function (event) {
      event.preventDefault();

      DynamicForm._addFieldset();
    });

    // Should be just on the latest one.
    $form.on('focus', '.js-add-fieldset-input', function() {
      DynamicForm._addFieldset();
    });
  },

  _addFieldset: function() {
    var regexp, sequence, target,
        $addFieldsetButton = $('.js-add-fieldset');

    sequence = document.getElementsByClassName('js-nested-item-row').length;
    regexp = new RegExp($addFieldsetButton.data('id'), 'g');
    target = '.js-' + $addFieldsetButton.data('association') + '-items';

    $(target).append($addFieldsetButton.data('fields').replace(regexp, sequence));
  },

  _removeFieldset: function(context) {
    var $fieldset = $(context).closest('.js-nested-item-row');

    $fieldset.children('.js-nested-item-destroy').val('1');
    $fieldset.hide();
  },

  init: function() {
    this.handleAddFieldset();
    this.handleRemoveFieldset();
  }
}
