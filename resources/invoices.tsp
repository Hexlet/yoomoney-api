using TypeSpec.Http;

namespace YooKassa;

// === Invoice ===

enum InvoiceStatus {
  pending,
  succeeded,
  canceled,
}

model LineItem {
  @doc("Описание товара или услуги.")
  description: string;

  @doc("Цена товара или услуги.")
  price: MonetaryAmount;

  @doc("Цена со скидкой.")
  discount_price?: MonetaryAmount;

  @doc("Количество.")
  quantity: int32;
}

model DeliveryMethodData {
  @doc("Тип способа доставки.")
  type: string;
}

model DeliveryMethodDataSelf extends DeliveryMethodData {}

model DeliveryMethodDataSms extends DeliveryMethodData {
  @doc("Номер телефона для отправки смс.")
  phone: Phone;
}

model DeliveryMethodDataEmail extends DeliveryMethodData {
  @doc("Электронная почта для отправки ссылки на счет.")
  email: Email;
}

model DeliveryMethod {
  @doc("Тип способа доставки.")
  type: string;
}

model DeliveryMethodSelf extends DeliveryMethod {
  @doc("URL страницы счета.")
  @maxLength(2048)
  url?: string;
}

model DeliveryMethodSms extends DeliveryMethod {}

model DeliveryMethodEmail extends DeliveryMethod {}

model Invoice {
  @doc("Идентификатор счета.")
  id: InvoiceId;

  @doc("Статус счета.")
  status: InvoiceStatus;

  @doc("Корзина заказа — список товаров или услуг.")
  cart: LineItem[];

  @doc("Способ доставки ссылки на счет.")
  delivery_method?: DeliveryMethodSelf | DeliveryMethodSms | DeliveryMethodEmail;

  @doc("Данные о платеже по счету.")
  payment_details?: PaymentDetails;

  @doc("Время создания счета.")
  created_at: utcDateTime;

  @doc("Срок действия счета.")
  expires_at?: utcDateTime;

  @doc("Описание счета.")
  description?: Description;

  @doc("Комментарий к статусу canceled.")
  cancellation_details?: InvoiceCancellationDetails;

  metadata?: Metadata;
}

// === Create Invoice Request ===

model CreateInvoiceRequest {
  @doc("Корзина заказа — список товаров или услуг.")
  cart: LineItem[];

  @doc("Способ доставки ссылки на счет.")
  delivery_method: DeliveryMethodDataSelf | DeliveryMethodDataSms | DeliveryMethodDataEmail;

  @doc("Данные платежа.")
  payment_data?: PaymentData;

  @doc("Срок действия счета.")
  expires_at?: utcDateTime;

  @doc("Описание заказа.")
  description?: Description;

  metadata?: Metadata;
}

// === Invoices API ===

@route("/invoices")
@tag("Счета")
interface Invoices {
  @doc("Создание счета")
  @post
  create(
    @header("Idempotence-Key") idempotenceKey: string,
    @body body: CreateInvoiceRequest,
  ): {
    @statusCode statusCode: 200;
    @body body: Invoice;
  } | StandardErrors;

  @doc("Информация о счете")
  @route("{invoice_id}")
  @get
  retrieve(
    @path invoice_id: InvoiceId,
  ): {
    @statusCode statusCode: 200;
    @body body: Invoice;
  } | StandardErrors;
}
