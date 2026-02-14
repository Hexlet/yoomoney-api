import "@typespec/http";

using TypeSpec.Http;

@doc("HTTP Basic аутентификация клиента ЮKassa")
model BasicAuth {
  type: AuthType.http;
  scheme: "basic";
}

@doc("Авторизация клиента ЮKassa с использованием OAuth-токена")
model OAuth2 is OAuth2Auth<[{
  type: OAuth2FlowType.implicit,
  authorizationUrl: "https://yookassa.ru/oauth/v2/authorize",
  scopes: [
    "checkout:payments_create",
    "checkout:payments_capture",
    "checkout:payments_cancel",
    "checkout:payments_get",
    "checkout:refunds_create",
    "checkout:refunds_get",
    "checkout:receipts_get",
    "checkout:get_fees",
  ],
}]>;
