# TODO list

* New items sold to/from a company should create the trade + price relation
* New prices on items sold to/from a company should update the price with the proper relation.
* I would like to know if I'm selling something below the purchase price as soon as I save the sale order or budget order 
* Print prices list or show c&p view of all prices

* Create a button to convert budgets in actual orders.
* There should not be a way to convert purchases in common orders that are meant to be sell orders. 
* Status change for orders. Effects on items after status changes.
    Completed/delivered should verify that all items were removed/added from stock
    Shipped should generate an invoice
    Delay should trigger an advice for clients/workers
    Paid should add payment (check, cash, future account)
* Alert for new products sold/bought in an order for a firm
* Show error on dynamic_form error
* Translate months and dates
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
* Menu indicator of the current section
* Trigger emails
* Search should bring Orders, firms, products or invoices. Probably add a way to select one of them.
* Link to create an order directly from the product show page with the product as first order_line.
* Sometimes new price modal wont do anything when you hit save.
* Translate "1 error prohibited this ??? from being saved" and similar.