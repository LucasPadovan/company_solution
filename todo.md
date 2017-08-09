# TODO list

* Create a separated section for "budgets" presupuestos. Create a button to convert budgets in actual orders.
* Status change for orders. Effects on items after status changes.
    Completed/delivered should verify that all items were removed/added from stock
    Shipped should generate an invoice
    Delay should trigger an advice for clients/workers
    Paid should add payment (check, cash, future account)
* Alert for new products sold/bought in an order for a firm
* Translations for new prices created
* Show error on dynamic_form error
* Translate months and dates
* New items sold to/from a company should create the proper relation.
* New prices on items sold to/from a company should update the price with the proper relation.
* Models and everything for delivers. A new deliver should be bound to an order and should discount from the amount of each order_line.
* Models and everything for invoices, divide them in purchase/sale types.
* Add indexes to all relations on tables.
* Daily cron to change valid prices.
* Pagination.
* Bind js models from the application.html.erb.
* Currency convertion
* Retrieve prices while building an order should differenciate sale from purchase orders
* Javascript helper files documentation and literal strings reorder
* Add placeholders
* Show effect on changing fields (autototals, dynamicform)
* Dashboard con ordernes abiertas, ordenes que se esperen entregar hoy y los proximos 5 dias, ordenes sin facturar, ordenes sin cobrar
* Differenciate purchase from sale orders
* Reports and graphics
* Menu indicator of the current section
* Trigger emails
* Welcome message breaks the orders filter
