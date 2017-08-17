var DynamicForm = {
  handleRemoveFieldset: function() {
    $('form').on('click', '.js-remove-fieldset', function (event) {
      event.preventDefault();

      DynamicForm._removeFieldset(this);
    });
  },

  handleRestoreFieldset: function() {
    $('form').on('click', '.js-nested-item-restore', function(event) {
      event.preventDefault();

      var $fieldset = $(this).data('fieldset'),
          $markAsDestroyInput =$fieldset.children('.js-nested-item-destroy');

      $(this).data('fieldset', '');

      $markAsDestroyInput.val('false');
      $markAsDestroyInput.trigger('change');

      $fieldset.show();
      $(this).parent().hide();
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
      var params = {},
          selectExtras = document.getElementsByClassName('js-fetcheable-select-extra');

      params[this.dataset.model] = this.options[this.options.selectedIndex].value;

      for(var i = 0, selectExtra; selectExtra = selectExtras[i]; i++) {
          params[selectExtra.dataset.model] = selectExtra.options[selectExtra.options.selectedIndex].value;
      }

      DynamicForm._fetchData(this.dataset.fetchUrl, params, this, fields, this.dataset.urlHasParams);
    });
  },

  /*Replicate for several fields*/
  populateForm: function(dataset, target, fields) {
    var $row = $(target).closest('tr');

    for(var i = 0, field; field = fields[i]; i++) {
      var unitSelector = '.js-nested-item-' + field,
          $field = $row.find(unitSelector);

      $field.val(dataset[field]);

      if (!fields[i + 1]) {
        $field.trigger('change');
      }
    }
  },

  createFirstLine: function() {
    $('.js-add-fieldset').click();
  },


  _addFieldset: function() {
    var $addFieldsetButton = $('.js-add-fieldset'),
        sequence = document.getElementsByClassName('js-nested-item-row').length,
        regexp = new RegExp($addFieldsetButton.data('id'), 'g'),
        target = '.js-' + $addFieldsetButton.data('association') + '-items';

    $(target).append($addFieldsetButton.data('fields').replace(regexp, sequence));
  },

  _removeFieldset: function(context) {
    var $fieldset = $(context).closest('.js-nested-item-row'),
        $markAsDestroyInput = $fieldset.children('.js-nested-item-destroy');

    $markAsDestroyInput.val('1');
    $markAsDestroyInput.trigger('change');

    DynamicForm._showRestoreButton($fieldset);
    $fieldset.hide();
  },

  _showRestoreButton: function($fieldset) {
    var $restoreButton = $('.js-nested-item-restore'),
        $restoreButtonWrapper = $restoreButton.parent(),
        newOffsetTop;

    $restoreButton.data('fieldset', $fieldset);
    $restoreButtonWrapper.show();

    newOffsetTop = $fieldset[0].offsetTop - $restoreButton[0].offsetHeight / 2 ;
    $restoreButtonWrapper.css('top', newOffsetTop);
  },

  _fetchData: function(url, params, target, fields, urlHasParams) {
    var queryParams = DynamicForm._buildQueryParams(params, urlHasParams);

    $.ajax({
      url: url + queryParams,
      contentType: 'application/json',
      dataType: 'json'
    }).done(function(response) {
      if (response) {
        DynamicForm.populateForm(response, target, fields);
      } else {
        // Show error
      }
    });
  },

  _buildQueryParams: function(params, urlHasParams) {
    var queryParams,
        keys = Object.keys(params);

    if (keys.length > 0) {
      queryParams = urlHasParams ? '&' : '?';

      for(var i = 0, key; key = keys[i]; i++) {
        queryParams += key + '=' + params[key];

        if (keys[i + 1]) {
          queryParams += '&';
        }
      }
    }

    return queryParams;
  },

  init: function() {
    this.handleAddFieldset();
    this.handleRemoveFieldset();
    this.handleRestoreFieldset();
  }
};
