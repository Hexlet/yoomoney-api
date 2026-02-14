using TypeSpec.Http;

namespace YooKassa;

// === Payment ===

enum PaymentStatus {
  pending,
  waiting_for_capture,
  succeeded,
  canceled,
}

model Payment {
  @doc("Идентификатор платежа.")
  id: PaymentId;

  @doc("Статус платежа.")
  status: PaymentStatus;

  @doc("Сумма платежа.")
  amount: MonetaryAmount;

  @doc("Сумма платежа, которую получит магазин.")
  income_amount?: MonetaryAmount;

  @doc("Описание транзакции.")
  description?: Description;

  @doc("Получатель платежа.")
  recipient: Recipient;

  @doc("Способ оплаты.")
  payment_method?: PaymentMethodBankCard | PaymentMethodCash | PaymentMethodQiwi | PaymentMethodAlfabank | PaymentMethodWebmoney | PaymentMethodSberbank | PaymentMethodTinkoffBank | PaymentMethodYooMoney | PaymentMethodApplePay | PaymentMethodGooglePay | PaymentMethodMobileBalance | PaymentMethodInstallments | PaymentMethodB2bSberbank | PaymentMethodWeChat | PaymentMethodSbp | PaymentMethodSberLoan | PaymentMethodElectronicCertificate | PaymentMethodSberBnpl;

  @doc("Время подтверждения платежа.")
  captured_at?: utcDateTime;

  @doc("Время создания заказа.")
  created_at: utcDateTime;

  @doc("Время, до которого вы можете бесплатно отменить или подтвердить платеж.")
  expires_at?: utcDateTime;

  @doc("Выбранный способ подтверждения платежа.")
  confirmation?: ConfirmationRedirect | ConfirmationExternal | ConfirmationQr | ConfirmationEmbedded | ConfirmationMobileApplication;

  @doc("Признак тестовой операции.")
  test: boolean;

  @doc("Сумма, возвращенная пользователю.")
  refunded_amount?: MonetaryAmount;

  @doc("Признак оплаты заказа.")
  paid: boolean;

  @doc("Возможность провести возврат по API.")
  refundable: boolean;

  @doc("Статус доставки данных для чека.")
  receipt_registration?: ReceiptRegistrationStatus;

  metadata?: Metadata;

  @doc("Комментарий к статусу canceled.")
  cancellation_details?: PaymentCancellationDetails;

  @doc("Данные об авторизации платежа.")
  authorization_details?: AuthorizationDetails;

  @doc("Данные о распределении денег.")
  transfers?: Transfer[];

  @doc("Данные о сделке.")
  deal?: PaymentDealInfo;

  @doc("Идентификатор покупателя в вашей системе.")
  merchant_customer_id?: MerchantCustomerId;

  @doc("Данные о счете, который оплачивается.")
  invoice_details?: string;
}

model PaymentList {
  @doc("Тип списка.")
  type: string;

  @doc("Список платежей.")
  items: Payment[];

  @doc("Курсор для получения следующей страницы.")
  next_cursor?: NextCursor;
}

// === Create Payment Request ===

model CreatePaymentRequest {
  @doc("Сумма платежа.")
  amount: MonetaryAmount;

  @doc("Описание транзакции.")
  description?: Description;

  @doc("Данные для формирования чека.")
  receipt?: ReceiptData;

  @doc("Получатель платежа.")
  recipient?: Recipient;

  @doc("Одноразовый токен для оплаты банковской картой.")
  payment_token?: PaymentToken;

  @doc("Идентификатор сохраненного способа оплаты.")
  payment_method_id?: PaymentMethodId;

  @doc("Данные для оплаты конкретным способом.")
  payment_method_data?: PaymentMethodDataBankCard | PaymentMethodDataCash | PaymentMethodDataSberbank | PaymentMethodDataTinkoffBank | PaymentMethodDataYooMoney | PaymentMethodDataMobileBalance | PaymentMethodDataB2bSberbank | PaymentMethodDataSbp | PaymentMethodDataSberLoan | PaymentMethodDataElectronicCertificate | PaymentMethodDataSberBnpl;

  @doc("Данные, необходимые для инициирования выбранного сценария подтверждения платежа пользователем.")
  confirmation?: ConfirmationDataRedirect | ConfirmationDataExternal | ConfirmationDataQr | ConfirmationDataEmbedded | ConfirmationDataMobileApplication;

  @doc("Сохранение платежных данных.")
  save_payment_method?: boolean;

  @doc("Автоматический прием поступившего платежа.")
  capture?: boolean;

  @doc("IPv4 или IPv6-адрес пользователя.")
  client_ip?: ClientIp;

  metadata?: Metadata;

  @doc("Данные для продажи авиабилетов.")
  airline?: Airline;

  @doc("Данные о распределении денег.")
  transfers?: TransferDataPayment[];

  @doc("Данные о сделке.")
  deal?: PaymentDealInfo;

  @doc("Идентификатор покупателя в вашей системе.")
  merchant_customer_id?: MerchantCustomerId;

  @doc("Данные платежного поручения.")
  payment_order?: PaymentOrderDataUtilities;

  @doc("Получатель перевода.")
  receiver?: ReceiverMobileBalance | ReceiverDigitalWallet | ReceiverBankAccount;

  @doc("Данные для отправки справки.")
  statements?: PaymentOverviewStatementData[];
}

// === Capture Payment Request ===

model PaymentCaptureRequest {
  @doc("Подтверждаемая сумма платежа.")
  amount?: MonetaryAmount;

  @doc("Данные для формирования чека.")
  receipt?: ReceiptData;

  @doc("Данные о распределении денег.")
  transfers?: TransferDataCapture[];

  @doc("Данные о сделке.")
  deal?: PaymentDealInfo;

  @doc("Данные для продажи авиабилетов.")
  airline?: Airline;
}

// === Payments API ===

@route("/payments")
@tag("Платежи")
interface Payments {
  @doc("Создание платежа")
  @post
  create(
    @header("Idempotence-Key") idempotenceKey: string,
    @body body: CreatePaymentRequest,
  ): {
    @statusCode statusCode: 200;
    @body body: Payment;
  } | StandardErrors;

  @doc("Список платежей")
  @get
  list(
    @query("created_at.gte") createdGte?: utcDateTime,
    @query("created_at.gt") createdGt?: utcDateTime,
    @query("created_at.lte") createdLte?: utcDateTime,
    @query("created_at.lt") createdLt?: utcDateTime,
    @query("captured_at.gte") capturedGte?: utcDateTime,
    @query("captured_at.gt") capturedGt?: utcDateTime,
    @query("captured_at.lte") capturedLte?: utcDateTime,
    @query("captured_at.lt") capturedLt?: utcDateTime,
    @query payment_method?: PaymentMethodType,
    @query status?: PaymentStatus,
    @query @minValue(1) @maxValue(100) limit?: int32 = 10,
    @query cursor?: string,
  ): {
    @statusCode statusCode: 200;
    @body body: PaymentList;
  } | StandardErrors;

  @doc("Информация о платеже")
  @route("{payment_id}")
  @get
  retrieve(
    @path payment_id: PaymentId,
  ): {
    @statusCode statusCode: 200;
    @body body: Payment;
  } | StandardErrorsWithNotFound;

  @doc("Подтверждение платежа")
  @route("{payment_id}/capture")
  @post
  capture(
    @path payment_id: PaymentId,
    @header("Idempotence-Key") idempotenceKey: string,
    @body body: PaymentCaptureRequest,
  ): {
    @statusCode statusCode: 200;
    @body body: Payment;
  } | StandardErrors;

  @doc("Отмена платежа")
  @route("{payment_id}/cancel")
  @post
  cancel(
    @path payment_id: PaymentId,
    @header("Idempotence-Key") idempotenceKey: string,
  ): {
    @statusCode statusCode: 200;
    @body body: Payment;
  } | StandardErrors;
}
