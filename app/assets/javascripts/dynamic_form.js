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

      var regexp, time, target;

      time = new Date().getTime();
      regexp = new RegExp($(this).data('id'), 'g');
      target = '.js-' + $(this).data('association') + '-items';

      $(target).before($(this).data('fields').replace(regexp, time));
    })
  },

  init: function() {
    this.handleAddFieldset();
    this.handleRemoveFieldset();
  }
}
