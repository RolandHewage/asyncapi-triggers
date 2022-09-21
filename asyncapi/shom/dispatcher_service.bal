import ballerina/http;
import ballerinax/asyncapi.native.handler;

service class DispatcherService {
    *http:Service;
    private map<GenericServiceType> services = {};
    private handler:NativeHandler nativeHandler = new ();

    isolated function addServiceRef(string serviceType, GenericServiceType genericService) returns error? {
        if (self.services.hasKey(serviceType)) {
            return error("Service of type " + serviceType + " has already been attached");
        }
        self.services[serviceType] = genericService;
    }

    isolated function removeServiceRef(string serviceType) returns error? {
        if (!self.services.hasKey(serviceType)) {
            return error("Cannot detach the service of type " + serviceType + ". Service has not been attached to the listener before");
        }
        _ = self.services.remove(serviceType);
    }

    // We are not using the (@http:payload GenericEventWrapperEvent g) notation because of a bug in Ballerina.
    // Issue: https://github.com/ballerina-platform/ballerina-lang/issues/32859
    resource function post .(http:Caller caller, http:Request request) returns error? {
        json payload = check request.getJsonPayload();
        string eventIdentifier = check request.getHeader("x-shopify-topic");
        GenericDataType genericDataType = check payload.cloneWithType(GenericDataType);
        check self.matchRemoteFunc(genericDataType, eventIdentifier);
        check caller->respond(http:STATUS_OK);
    }

    private function matchRemoteFunc(GenericDataType genericDataType, string eventIdentifier) returns error? {
        match eventIdentifier {
            "orders/create" => {
                check self.executeRemoteFunc(genericDataType, "orders/create", "OrdersService", "onOrdersCreate");
            }
            "orders/cancelled" => {
                check self.executeRemoteFunc(genericDataType, "orders/cancelled", "OrdersService", "onOrdersCancelled");
            }
            "orders/fulfilled" => {
                check self.executeRemoteFunc(genericDataType, "orders/fulfilled", "OrdersService", "onOrdersFulfilled");
            }
            "orders/paid" => {
                check self.executeRemoteFunc(genericDataType, "orders/paid", "OrdersService", "onOrdersPaid");
            }
            "orders/partially_fulfilled" => {
                check self.executeRemoteFunc(genericDataType, "orders/partially_fulfilled", "OrdersService", "onOrdersPartiallyFulfilled");
            }
            "orders/updated" => {
                check self.executeRemoteFunc(genericDataType, "orders/updated", "OrdersService", "onOrdersUpdated");
            }
            "customers/create" => {
                check self.executeRemoteFunc(genericDataType, "customers/create", "CustomersService", "onCustomersCreate");
            }
            "customers/disable" => {
                check self.executeRemoteFunc(genericDataType, "customers/disable", "CustomersService", "onCustomersDisable");
            }
            "customers/enable" => {
                check self.executeRemoteFunc(genericDataType, "customers/enable", "CustomersService", "onCustomersEnable");
            }
            "customers/update" => {
                check self.executeRemoteFunc(genericDataType, "customers/update", "CustomersService", "onCustomersUpdate");
            }
            "customers_marketing_consent/update" => {
                check self.executeRemoteFunc(genericDataType, "customers_marketing_consent/update", "CustomersService", "onCustomersMarketingConsentUpdate");
            }
            "products/create" => {
                check self.executeRemoteFunc(genericDataType, "products/create", "ProductsService", "onProductsCreate");
            }
            "products/update" => {
                check self.executeRemoteFunc(genericDataType, "products/update", "ProductsService", "onProductsUpdate");
            }
            "fulfillments/create" => {
                check self.executeRemoteFunc(genericDataType, "fulfillments/create", "FulfillmentsService", "onFulfillmentsCreate");
            }
            "fulfillments/update" => {
                check self.executeRemoteFunc(genericDataType, "fulfillments/update", "FulfillmentsService", "onFulfillmentsUpdate");
            }
        }
    }

    private function executeRemoteFunc(GenericDataType genericEvent, string eventName, string serviceTypeStr, string eventFunction) returns error? {
        GenericServiceType? genericService = self.services[serviceTypeStr];
        if genericService is GenericServiceType {
            check self.nativeHandler.invokeRemoteFunction(genericEvent, eventName, eventFunction, genericService);
        }
    }
}
