using TypeSpec.Http;

namespace YooKassa;

// === Refund ===

enum RefundStatus {
  pending,
  succeeded,
  canceled,
}

enum RefundMethodType {
  sbp,
  electronic_certificate,
}

model RefundSourcesData {
  @doc("Идентификатор магазина.")
  account_id: AccountId;

  @doc("Сумма возврата.")
  amount: MonetaryAmount;

  @doc("Комиссия, которую вы удержали при оплате.")
  platform_fee_amount?: MonetaryAmount;
}

model RefundCancellationDetails {
  party: string;
  reason: string;
}

model RefundAuthorizationDetails {
  rrn?: Rrn;
}

// === Refund Method ===

model RefundMethodData {
  type: RefundMethodType;
}

model ElectronicCertificateRefundDataRequest {
  amount: MonetaryAmount;
  basket_id: BasketId;
}

model ElectronicCertificateRefundArticle {
  article_number: int32;
  payment_article_number: int32;
  tru_code: string;
  quantity: int32;
}

model ElectronicCertificateRefundMethodData extends RefundMethodData {
  electronic_certificate?: ElectronicCertificateRefundDataRequest;
  articles?: ElectronicCertificateRefundArticle[];
}

model RefundMethod {
  type: RefundMethodType;
}

model SbpRefundMethod extends RefundMethod {
  @doc("Идентификатор операции в СБП (НСПК).")
  sbp_operation_id?: string;
}

model ElectronicCertificateRefundDataResponse {
  basket_id: BasketId;
  amount: MonetaryAmount;
}

model ElectronicCertificateRefundMethod extends RefundMethod {
  electronic_certificate?: ElectronicCertificateRefundDataResponse;
  articles?: ElectronicCertificateRefundArticle[];
}

// === Refund ===

model Refund {
  @doc("Идентификатор возврата.")
  id: RefundId;

  @doc("Идентификатор платежа.")
  payment_id: PaymentId;

  @doc("Статус возврата.")
  status: RefundStatus;

  @doc("Комментарий к статусу canceled.")
  cancellation_details?: RefundCancellationDetails;

  @doc("Статус регистрации чека.")
  receipt_registration?: ReceiptRegistrationStatus;

  @doc("Время создания возврата.")
  created_at: utcDateTime;

  @doc("Сумма возврата.")
  amount: MonetaryAmount;

  @doc("Описание возврата.")
  description?: Description;

  @doc("Источники средств для возврата.")
  sources?: RefundSourcesData[];

  @doc("Данные о сделке.")
  deal?: RefundDealInfo;

  @doc("Способ возврата.")
  refund_method?: SbpRefundMethod | ElectronicCertificateRefundMethod;

  @doc("Данные об авторизации возврата.")
  refund_authorization_details?: RefundAuthorizationDetails;

  metadata?: Metadata;
}

model RefundList {
  type: string;
  items: Refund[];
  next_cursor?: NextCursor;
}

// === Create Refund Request ===

model CreateRefundRequest {
  @doc("Идентификатор платежа для возврата.")
  payment_id: PaymentId;

  @doc("Сумма возврата.")
  amount: MonetaryAmount;

  @doc("Описание возврата.")
  description?: Description;

  @doc("Данные для формирования чека.")
  receipt?: ReceiptData;

  @doc("Источники для возврата.")
  sources?: RefundSourcesData[];

  @doc("Данные о сделке.")
  deal?: RefundDealData;

  @doc("Данные о способе возврата.")
  refund_method_data?: ElectronicCertificateRefundMethodData;

  metadata?: Metadata;
}

// === Refunds API ===

@route("/refunds")
@tag("Возвраты")
interface Refunds {
  @doc("Создание возврата")
  @post
  create(
    @header("Idempotence-Key") idempotenceKey: string,
    @body body: CreateRefundRequest,
  ): {
    @statusCode statusCode: 200;
    @body body: Refund;
  } | StandardErrors;

  @doc("Список возвратов")
  @get
  list(
    @query("created_at.gte") createdGte?: utcDateTime,
    @query("created_at.gt") createdGt?: utcDateTime,
    @query("created_at.lte") createdLte?: utcDateTime,
    @query("created_at.lt") createdLt?: utcDateTime,
    @query payment_id?: PaymentId,
    @query status?: RefundStatus,
    @query @minValue(1) @maxValue(100) limit?: int32 = 10,
    @query cursor?: string,
  ): {
    @statusCode statusCode: 200;
    @body body: RefundList;
  } | StandardErrors;

  @doc("Информация о возврате")
  @route("{refund_id}")
  @get
  retrieve(
    @path refund_id: RefundId,
  ): {
    @statusCode statusCode: 200;
    @body body: Refund;
  } | StandardErrorsWithNotFound;
}
