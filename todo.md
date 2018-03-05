# TODO list

* Budget pdf generation. >> WIP
* Budget show dates
* Budget price increase maybe can be stored in the db
* Products List should be replaced by budgets.
* Option to load a pdf/xls with prices and create the new prices for each product.
* Budgets forms should not allow to change firm if firm_id is passed in the params.
* Budget index view should not have from_date in the list
* Analyze changing date/formatted date to facilitate everything
* verify budget lines using the correct valid_from date
* Create a button to add all trades at the same time.
* move translations to budgets
* is possible to save a budget without a firm! should not happen and should check validations before try to update prices. #fixed with before_commit, check other uses of the same thing.
* check after_initialize when values are present in the props
* Budget prices should create new prices for each trade/firm BUT those prices should not affect orders made prior to the new budget.
    * If possible, orders should be created with a base budget that fixes the prices
    * If creating a budget is impossible: the order should take the prices of the day they are ordered as the fix.
* Product list should just be a list of all products sold/purchased by a firm with all the information about them.

* Products list > generate PDF > generate a budget order with all the products and its prices
* Save in budget description the header of the pdf file to replicate it afterwards.

* Certificates and permissions (for firms and the company).
    * Upload and preview permissions pdf
    * Dashboard should alert close to finishing certificates
* Tabs system for firms and products.
* replicate products_list format
    * Special color for some elements (mark those with price differences of 2%, 4%, 6%, and 10%+, special prices for some elements in the list
* New items sold to/from a company creates trade + price relation > check next items
    * Advice that you will be creating new prices for that firm+product in the order form.
* New prices on items sold to/from a company on an order should update the price with the proper relation.
* I would like to know if I'm selling something below the purchase price as soon as I save the sale order or budget order
* - Changing the firm on an order should retrieve all prices again for each line item.
* - Investigate retrieving all prices on order (new/edit) load and use that information instead of a single fetch each time.

* Create a button to convert budgets in actual orders.
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
* Allow print view using all the headers and stuff from the company.
* Add contact could be a modal
* New system for modals to load them using javascript and not having them always live.
* Update spectre

* Budgets: use header and body image, check usage of 'to' attribute.

* Number: check that manual editing a number doesn't generates conflict of duplicity 
