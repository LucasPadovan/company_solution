var TradesList = {
  tradesListArray: [],
  tradesListArrayField: '.js-trades-list__array',
  showTradeButton: '.js-trades-list__show-trade',
  hideTradeButton: '.js-trades-list__hide-trade',

  handleToggleTrades: function() {
    this.tradesListArray = [];

    $(document).on('click', this.showTradeButton, this._showTrade);
    $(document).on('click', this.hideTradeButton, this._hideTrade);
  },

  _showTrade: function(e) {
    e.preventDefault();

    var tradeId = TradesList.tradesListArray.pop(),
        tradeRow = document.querySelector('[data-trade-id="' + tradeId + '"]');

    TradesList._updateTradesListArrayField();

    $(tradeRow).show();

    if (!TradesList.tradesListArray[0]) {
      $(this).hide();
    }
  },

  _hideTrade: function(e) {
    e.preventDefault();

    var tradeRow = e.target.parentElement.parentElement,
        tradeId  = tradeRow.dataset.tradeId;

    TradesList.tradesListArray.push(tradeId);
    TradesList._updateTradesListArrayField();

    $(tradeRow).hide();
    $(TradesList.showTradeButton).show();
  },

  _updateTradesListArrayField: function() {
    document.querySelector(this.tradesListArrayField).value = this.tradesListArray;
  },

  init: function () {
    this.handleToggleTrades()
  }
}