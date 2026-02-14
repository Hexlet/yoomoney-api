using TypeSpec.Http;

namespace YooKassa;

// === Receipt ===

model Receipt {
  @doc("Идентификатор чека.")
  id: ReceiptId;

  @doc("Тип чека.")
  type: ReceiptType;

  @doc("Идентификатор платежа.")
  payment_id?: PaymentId;

  @doc("Идентификатор возврата.")
  refund_id?: RefundId;

  @doc("Статус регистрации чека.")
  status: ReceiptRegistrationStatus;

  @doc("Номер фискального документа.")
  fiscal_document_number?: string;

  @doc("Номер фискального накопителя.")
  fiscal_storage_number?: string;

  @doc("Фискальный признак.")
  fiscal_attribute?: string;

  @doc("Дата и время регистрации чека.")
  registered_at?: utcDateTime;

  @doc("Идентификатор провайдера фискализации.")
  fiscal_provider_id?: string;

  @doc("Позиции чека.")
  items: ReceiptItem[];

  @doc("Флаг расчета в интернете.")
  internet?: boolean;

  @doc("Данные расчетов.")
  settlements?: Settlement[];

  @doc("Идентификатор магазина.")
  on_behalf_of?: string;

  @doc("Код системы налогообложения.")
  tax_system_code?: int32;

  @doc("Часовой пояс.")
  timezone?: string;

  @doc("Отраслевой реквизит чека.")
  receipt_industry_details?: IndustryDetails[];

  @doc("Операционный реквизит чека.")
  receipt_operational_details?: OperationalDetails;
}

// === Create Receipt Request ===

model PostReceiptData {
  @doc("Тип чека.")
  type: ReceiptType;

  @doc("Идентификатор платежа.")
  payment_id?: PaymentId;

  @doc("Идентификатор возврата.")
  refund_id?: RefundId;

  @doc("Данные покупателя.")
  customer: ReceiptDataCustomer;

  @doc("Позиции чека.")
  items: PostReceiptDataItem[];

  @doc("Флаг расчета в интернете.")
  internet?: boolean;

  @doc("Признак отправки чека пользователю.")
  send: boolean;

  @doc("Код системы налогообложения.")
  tax_system_code?: int32;

  @doc("Часовой пояс.")
  timezone?: string;

  @doc("Дополнительный реквизит пользователя.")
  additional_user_props?: ReceiptAdditionalUserProps;

  @doc("Отраслевой реквизит чека.")
  receipt_industry_details?: IndustryDetails[];

  @doc("Операционный реквизит чека.")
  receipt_operational_details?: OperationalDetails;

  @doc("Данные расчетов.")
  settlements: Settlement[];

  @doc("Идентификатор магазина.")
  on_behalf_of?: string;
}

// === Receipt List ===

model ReceiptList {
  type: string;
  items: Receipt[];
  next_cursor?: NextCursor;
}

// === Receipts API ===

@route("/receipts")
@tag("Чеки")
interface Receipts {
  @doc("Создание чека")
  @post
  create(
    @header("Idempotence-Key") idempotenceKey: string,
    @body body: PostReceiptData,
  ): {
    @statusCode statusCode: 200;
    @body body: Receipt;
  } | StandardErrors;

  @doc("Список чеков")
  @get
  list(
    @query("created_at.gte") createdGte?: utcDateTime,
    @query("created_at.gt") createdGt?: utcDateTime,
    @query("created_at.lte") createdLte?: utcDateTime,
    @query("created_at.lt") createdLt?: utcDateTime,
    @query status?: ReceiptRegistrationStatus,
    @query payment_id?: PaymentId,
    @query refund_id?: RefundId,
    @query @minValue(1) @maxValue(100) limit?: int32 = 10,
    @query cursor?: string,
  ): {
    @statusCode statusCode: 200;
    @body body: ReceiptList;
  } | StandardErrors;

  @doc("Информация о чеке")
  @route("{receipt_id}")
  @get
  retrieve(
    @path receipt_id: ReceiptId,
  ): {
    @statusCode statusCode: 200;
    @body body: Receipt;
  } | StandardErrors;
}
