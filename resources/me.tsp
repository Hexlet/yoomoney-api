using TypeSpec.Http;

namespace YooKassa;

// === Me (Настройки) ===

model Me {
  @doc("Идентификатор аккаунта.")
  account_id: AccountId;

  @doc("Статус аккаунта.")
  status: string;

  @doc("Признак тестового аккаунта.")
  test: boolean;

  @doc("Данные о фискализации.")
  fiscalization?: FiscalizationData;

  @doc("Признак подключенной фискализации.")
  fiscalization_enabled?: boolean;

  @doc("Доступные способы оплаты.")
  payment_methods?: PaymentMethodType[];

  @doc("ИНН.")
  itn?: GlobalItn;

  @doc("Способы выплат.")
  payout_methods?: PayoutMethodType[];

  @doc("Название магазина.")
  name?: string;

  @doc("Баланс для выплат.")
  payout_balance?: MonetaryAmount;
}

// === Me API ===

@route("/me")
@tag("Настройки")
interface MeResource {
  @doc("Получение настроек магазина или шлюза")
  @get
  retrieve(
    @query on_behalf_of?: string,
  ): {
    @statusCode statusCode: 200;
    @body body: Me;
  } | StandardErrors;
}
