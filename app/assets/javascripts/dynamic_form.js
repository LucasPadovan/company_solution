var DynamicForm = {
  handleAddFieldset: function() {
    $('form').on('click', '.js-remove-fieldset', function (event) {
      event.preventDefault();

      $(this).prev('input[type=hidden]').val('1');
      $(this).closest('.js-item-row').hide();
    });
  },

  handleRemoveFieldset: function() {
    $('form').on('click', '.js-add-fieldset', function (event) {
      event.preventDefault();

      var regexp, sequence, target;

      sequence = document.getElementsByClassName('js-item-row').length;
      regexp = new RegExp($(this).data('id'), 'g');
      target = '.js-' + $(this).data('association') + '-items';

      $(target).append($(this).data('fields').replace(regexp, sequence));
    })
  },

  init: function() {
    this.handleAddFieldset();
    this.handleRemoveFieldset();
  }
}
