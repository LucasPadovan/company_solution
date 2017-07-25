# TODO list

* Retrieve unit price for each product sold to each firm.
* New items sold to/from a company should create the proper relation.
* New prices on items sold to/from a company should update the price with the proper relation.
* Status for orders.
* Models and everything for delivers. A new deliver should be bound to an order and should discount from the amount of each order_line.
* Models and everything for invoices, divide them in purchase/sale types.
* Add indexes to all relations on tables.

Price

trade:references price:numeric min_quantity:numeric valid_to:datetime currency:string 