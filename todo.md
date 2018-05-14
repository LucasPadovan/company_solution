# TODO list

* Option to load a pdf/xls with prices and create the new prices for each product.
    * use the from_date of the new prices list for the new prices so in the future we know when was that price updated the last time.
    * before saving show all products with the price change, the diff % per product and the diff % prom, provider_name > public_name for new products.
    * Add columns for the internal management of the products such as: (provider_code, provider_name, provider_size, trade_batch_id) should be for the trade, (public_name, public_code, public_description) should be for the product
    * Create a model: trade_batch (filename, date, firm_id) with all the views: index, show, new, create, delete
    
* Budgets
    * when on budgets/new > add a button to add all items sold to that firm
        * Products list > generate PDF > generate a budget order with all the products and its prices
    * show dates format?
    * price increase maybe can be stored in the db
    * Budget prices should create new prices for each trade/firm BUT those prices should not affect orders made prior to the new budget.
        * If possible, orders should be created with a base budget that fixes the prices
        * If creating a budget is impossible: the order should take a fixed price from the day they are ordered
    * Create a button to convert budgets in actual orders.
    * use header and body image, check usage of 'to' attribute.

* Products List should be replaced by firm/#/products_list. < WIP
    * Check urls for products_list
    * replicate products_list format
        * Special color for some elements (mark those with price differences of 2%, 4%, 6%, and 10%+, special prices for some elements in the list
    * Back on trades/8/prices?origin=firm should lead to /firms/1/products_list?type=buys|sells
    * Alert products that haven't had a price change in a while as it may not be sold anymore.

* Analyze changing date/formatted date to facilitate everything
* verify budget lines using the correct valid_from date
* Create a button to add all trades at the same time.
* move translations to budgets

* check after_initialize when values are present in the props
* Products could be marked as 'not available'

* Save in budget description the header of the pdf file to replicate it afterwards.

* Certificates and permissions (for firms and the company).
    * Upload and preview permissions pdf
    * Dashboard should alert close to finishing certificates
* Tabs system for firms and products.
* New items sold to/from a company creates trade + price relation > check next items
    * Advice that you will be creating new prices for that firm+product in the order form.
* New prices on items sold to/from a company on an order should update the price with the proper relation.
* I would like to know if I'm selling something below the purchase price as soon as I save the sale order or budget order
* - Changing the firm on an order should retrieve all prices again for each line item.
* - Investigate retrieving all prices on order (new/edit) load and use that information instead of a single fetch each time.

* There should not be a way to convert purchases in common orders that are meant to be sell orders. 
* Status change for orders. Effects on items after status changes.
    Completed/delivered should verify that all items were removed/added from stock
    Shipped should generate an invoice
    Delay should trigger an advice for clients/workers
    Paid should add payment (check, cash, future account)
* Alert for new products sold/bought in an order for a firm
* Show error on dynamic_form error
* Models and everything for delivers. A new deliver should be bound to an order and should discount from the amount of each order_line.
* Models and everything for invoices, divide them in purchase/sale types.
* Add indexes to all relations on tables.
* Daily cron to change valid prices.
* Pagination.
* Bind js models from the application.html.erb.
* Currency convertion
* Javascript helper files documentation and literal strings reorder
* Add placeholders
* Show effect on changing fields (autototals, dynamicform)
* Dashboard con ordernes abiertas, ordenes que se esperen entregar hoy y los proximos 5 dias, ordenes sin facturar, ordenes sin cobrar
* Reports and graphics
* Trigger emails
* Search should bring Orders, firms, products or invoices. Probably add a way to select one of them.
* Link to create an order directly from the product show page with the product as first order_line.
* Sometimes new price modal wont do anything when you hit save.
* Translate "1 error prohibited this ??? from being saved" and similar.
* Add contact could be a modal
* New system for modals to load them using javascript and not having them always live.
* Update spectre

* Number: check that manual editing a number doesn't generates conflict of duplicity 

* Clean css
