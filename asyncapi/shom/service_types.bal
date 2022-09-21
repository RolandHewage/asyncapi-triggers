public type OrdersService service object {
    remote function onOrdersCreate(OrderEvent event) returns error?;
    remote function onOrdersCancelled(OrderEvent event) returns error?;
    remote function onOrdersFulfilled(OrderEvent event) returns error?;
    remote function onOrdersPaid(OrderEvent event) returns error?;
    remote function onOrdersPartiallyFulfilled(OrderEvent event) returns error?;
    remote function onOrdersUpdated(OrderEvent event) returns error?;
};

public type CustomersService service object {
    remote function onCustomersCreate(CustomerEvent event) returns error?;
    remote function onCustomersDisable(CustomerEvent event) returns error?;
    remote function onCustomersEnable(CustomerEvent event) returns error?;
    remote function onCustomersUpdate(CustomerEvent event) returns error?;
    remote function onCustomersMarketingConsentUpdate(CustomerEvent event) returns error?;
};

public type ProductsService service object {
    remote function onProductsCreate(ProductEvent event) returns error?;
    remote function onProductsUpdate(ProductEvent event) returns error?;
};

public type FulfillmentsService service object {
    remote function onFulfillmentsCreate(FulfillmentEvent event) returns error?;
    remote function onFulfillmentsUpdate(FulfillmentEvent event) returns error?;
};

public type GenericServiceType OrdersService|CustomersService|ProductsService|FulfillmentsService;
