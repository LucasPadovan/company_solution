var JsModals = {
  openClasses: 'modal active',

  closedClasses: 'modal',

  handleAutoOpen: function() {
    var target = location.hash.split('#')[1];

    if (target) {
      JsModals.openModal(target);
    }
  },

  handleOpen: function(e) {
    e.preventDefault();

    var target = this.dataset.modalOpen;

    JsModals.openModal(target);
  },

  openModal: function(target) {
    var modal = document.querySelector('[data-modal=' + target + ']');

    if (modal) {
      modal.className = JsModals.openClasses;
    }

    Utils.focusField(modal);
  },

  handleClose: function(e) {
    e.preventDefault();

    JsModals.closeModal();
  },

  closeModal: function() {
    var openModal = document.getElementsByClassName(JsModals.openClasses)[0];

    if (openModal) {
      openModal.className = JsModals.closedClasses;
    }
  },

  bindEvents: function() {
    var modalTriggers = document.querySelectorAll('[data-modal-open]'),
        modalClosers = document.querySelectorAll('[data-modal-close]'),
        modalOverlays = document.getElementsByClassName('modal-overlay');

    for (var i = 0, modalTrigger, modalCloser, modalOverlay; modalTrigger = modalTriggers[i]; i++) {
      modalTrigger.addEventListener('click', JsModals.handleOpen);

      modalCloser = modalClosers[i];
      modalCloser.addEventListener('click', JsModals.handleClose);

      modalOverlay = modalOverlays[i];
      modalOverlay.addEventListener('click', JsModals.closeModal);
    }

    window.addEventListener('keydown', function(e) {
      if (e.key === 'Escape') {
        JsModals.closeModal();
      }
    });

    JsModals.handleAutoOpen();
  }
};