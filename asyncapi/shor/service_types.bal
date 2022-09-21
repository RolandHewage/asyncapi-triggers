public type OrdersService service object {
    remote function onOrdersCreate(OrderEvent event) returns error?;
};

public type GenericServiceType OrdersService;
