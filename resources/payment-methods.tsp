using TypeSpec.Http;

namespace YooKassa;

// === Payment Methods API ===

model CreatePaymentMethodRequest {
  @doc("Тип способа оплаты.")
  type: SavePaymentMethodType;

  @doc("Данные для проверки и сохранения способа оплаты.")
  payment_method_data: SavePaymentMethodDataBankCard;

  @doc("Данные платежа, который будет создан после сохранения способа оплаты.")
  payment_data?: PaymentData;

  @doc("Данные для формирования чека.")
  receipt?: ReceiptData;
}

@route("/payment_methods")
@tag("Способы оплаты")
interface PaymentMethods {
  @doc("Создание способа оплаты")
  @post
  create(
    @header("Idempotence-Key") idempotenceKey: string,
    @body body: CreatePaymentMethodRequest,
  ): {
    @statusCode statusCode: 200;
    @body body: SavePaymentMethodBankCard;
  } | StandardErrorsWithTooMany;

  @doc("Информация о способе оплаты")
  @route("{payment_method_id}")
  @get
  retrieve(
    @path payment_method_id: PaymentMethodId,
  ): {
    @statusCode statusCode: 200;
    @body body: SavePaymentMethodBankCard;
  } | StandardErrorsWithNotFoundAndTooMany;
}
