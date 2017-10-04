# TODO list

* Certificates and permissions (for firms and the company).
    * Certificate
        Name
        Description
        Website
        email
        wait_time
        certifications -> model linking certificate and product
            product_id
            certificate_id
            note
    * Permission
        From date
        To date
        certifications -> model linking the firm or the same company and the certificate certifications
        contact_person -> someone in charge of this
    * Certificates in menu, permissions in each firm
    * Dashboard should alert close to finishing certificates
    * Generating an order with a product that needs certification should alert:
        * Everything ok, firm has the certificate
        * Something off, firm has the cert but it is outdated
        * NO GO, firm doesn't have the certificate
        
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
* Menu indicator of the current section
* Trigger emails
* Search should bring Orders, firms, products or invoices. Probably add a way to select one of them.
* Link to create an order directly from the product show page with the product as first order_line.
* Sometimes new price modal wont do anything when you hit save.
* Translate "1 error prohibited this ??? from being saved" and similar.
* Allow print view using all the headers and stuff from the company.
* Add contact could be a modal
* New system for modals to load them using javascript and not having them always live.
* Update spectre
