// Listener related configurations should be included here
public type ListenerConfigs record {
};

public type TotalPriceSet record {
    Price shop_money?;
    Price presentment_money?;
};

public type Price record {
    # The variant's price or compare-at price in the presentment currency.
    string amount?;
    # The three-letter code (ISO 4217 format) for one of the shop's enabled presentment currencies.
    string? currency_code?;
};

public type OrderEvent record {
    TotalPriceSet? total_price_set?;
    # An array of tax line objects, each of which details a tax applicable to the order. When creating an order through the API, tax lines can be specified on the order or the line items but not both. Tax lines specified on the order are split across the taxable line items in the created order.
    TaxLine[]? tax_lines?;
    # The rate of tax to be applied.
    decimal? rate?;
    # The total tax applied to the order in shop and presentment currencies.
    record  { Price shop_money?; Price? presentment_money?;} ? total_tax_set?;
    # The ID of the order, used for API purposes. This is different from the order_number property, which is the ID used by the shop owner and customer.
    int? id?;
    # Confirmation status
    boolean? confirmed?;
    # The customer's email address.
    string? email?;
};

public type TaxLine record {
    # Whether the channel that submitted the tax line is liable for remitting. A value of null indicates unknown liability for the tax line.
    boolean channel_liable?;
    # The rate of tax to be applied.
    decimal rate?;
    # The amount of tax to be charged in the shop currency.
    string price?;
    # The name of the tax.
    string? title?;
};

public type GenericDataType TotalPriceSet|Price|OrderEvent|TaxLine;
