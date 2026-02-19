import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";
import "@typespec/rest";

import "./auth.tsp";
import "./models/common.tsp";
import "./models/errors.tsp";
import "./models/payment-methods-models.tsp";
import "./models/confirmations.tsp";
import "./models/receipts-models.tsp";
import "./models/deals-models.tsp";
import "./models/payouts-models.tsp";

import "./resources/payments.tsp";
import "./resources/payment-methods.tsp";
import "./resources/invoices.tsp";
import "./resources/refunds.tsp";
import "./resources/receipts.tsp";
import "./resources/deals.tsp";
import "./resources/payouts.tsp";
import "./resources/sbp-banks.tsp";
import "./resources/personal-data.tsp";
import "./resources/webhooks.tsp";
import "./resources/me.tsp";

using TypeSpec.Http;
using TypeSpec.OpenAPI;
using TypeSpec.Rest;

@service(
  #{
    title: "Справочник API ЮKassa",
  }
)
@info(#{
  version: "1.0.0",
})
@server("https://api.yookassa.ru/v3", "Production")
// OAuth2 intentionally excluded from generated spec for now.
@useAuth(global.BasicAuth)
namespace YooKassa;
