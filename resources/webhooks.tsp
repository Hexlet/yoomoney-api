using TypeSpec.Http;

namespace YooKassa;

// === Webhook ===

enum NotificationEventType {
  `payment.waiting_for_capture`,
  `payment.succeeded`,
  `payment.canceled`,
  `refund.succeeded`,
}

model Webhook {
  @doc("Идентификатор webhook.")
  id: string;

  @doc("Событие, о котором нужно уведомить.")
  event: NotificationEventType;

  @doc("URL для уведомлений.")
  url: string;
}

model WebhookList {
  type: string;
  items: Webhook[];
}

// === Create Webhook Request ===

model CreateWebhookRequest {
  @doc("Событие, о котором нужно уведомить.")
  event: NotificationEventType;

  @doc("URL для уведомлений.")
  url: string;
}

// === Webhooks API ===

@route("/webhooks")
@tag("Webhooks")
interface Webhooks {
  @doc("Создание webhook")
  @post
  create(
    @header("Idempotence-Key") idempotenceKey: string,
    @body body: CreateWebhookRequest,
  ): {
    @statusCode statusCode: 200;
    @body body: Webhook;
  } | StandardErrors;

  @doc("Список webhook")
  @get
  list(): {
    @statusCode statusCode: 200;
    @body body: WebhookList;
  } | {
    @statusCode statusCode: 401;
    @body body: InvalidCredentials;
  } | ForbiddenResponse | InternalServerErrorResponse;

  @doc("Удаление webhook")
  @route("{webhook_id}")
  @delete
  remove(
    @path webhook_id: string,
  ): {
    @statusCode statusCode: 200;
    @body body: {};
  } | StandardErrors;
}
