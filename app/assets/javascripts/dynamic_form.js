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

    $form.on('focus', '.js-add-fieldset-input', function() {
      if (this === $('.js-add-fieldset-input').last()[0]) {
        DynamicForm._addFieldset();
      }
    });
  },

  handleFetchableSelect: function(target, fields) {
    $(document).on('change', target, function() {
      var id = this.options[this.options.selectedIndex].value;

      DynamicForm._fetchData(this.dataset.fetchUrl, id, this, fields);
    });
  },

  /*Replicate for several fields*/
  populateForm: function(dataset, target, fields) {
    var $row = $(target).closest('tr');

    for(var i = 0, field; field = fields[i]; i++) {
      var unitSelector = '.js-nested-item-' + field;

      $row.find(unitSelector).val(dataset[field]);
    }
  },

  _addFieldset: function() {
    var $addFieldsetButton = $('.js-add-fieldset'),
        sequence = document.getElementsByClassName('js-nested-item-row').length,
        regexp = new RegExp($addFieldsetButton.data('id'), 'g'),
        target = '.js-' + $addFieldsetButton.data('association') + '-items';

    $(target).append($addFieldsetButton.data('fields').replace(regexp, sequence));
  },

  _removeFieldset: function(context) {
    var $fieldset = $(context).closest('.js-nested-item-row');

    $fieldset.children('.js-nested-item-destroy').val('1');
    $fieldset.hide();
  },

  _fetchData: function(url, id, target, fields) {
    $.ajax({
      url: url + '/' + id,
      contentType: 'application/json',
      dataType: 'json'
    }).done(function(response) {
      DynamicForm.populateForm(response, target, fields);
    });
  },

  init: function() {
    this.handleAddFieldset();
    this.handleRemoveFieldset();
  }
};
