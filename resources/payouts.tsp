using TypeSpec.Http;

namespace YooKassa;

// === Payouts API ===

@route("/payouts")
@tag("Выплаты")
interface Payouts {
  @doc("Создание выплаты")
  @post
  create(
    @header("Idempotence-Key") idempotenceKey: string,
    @body body: PayoutRequest,
  ): {
    @statusCode statusCode: 200;
    @body body: Payout;
  } | StandardErrorsWithTooMany;

  @doc("Список выплат")
  @get
  list(
    @query("created_at.gte") createdGte?: utcDateTime,
    @query("created_at.gt") createdGt?: utcDateTime,
    @query("created_at.lte") createdLte?: utcDateTime,
    @query("created_at.lt") createdLt?: utcDateTime,
    @query("payout_destination.type") payoutDestinationType?: PayoutDestinationType,
    @query status?: PayoutStatus,
    @query @minValue(1) @maxValue(100) limit?: int32 = 10,
    @query cursor?: string,
  ): {
    @statusCode statusCode: 200;
    @body body: PayoutsList;
  } | StandardErrorsWithNotFoundAndTooMany;

  @doc("Поиск выплат по метаданным")
  @route("search")
  @get
  search(
    @query("created_at.gte") createdGte?: utcDateTime,
    @query("created_at.gt") createdGt?: utcDateTime,
    @query("created_at.lte") createdLte?: utcDateTime,
    @query("created_at.lt") createdLt?: utcDateTime,
    @query @minValue(1) @maxValue(100) limit?: int32 = 10,
    @query cursor?: string,
  ): {
    @statusCode statusCode: 200;
    @body body: PayoutsList;
  } | StandardErrorsWithNotFoundAndTooMany;

  @doc("Информация о выплате")
  @route("{payout_id}")
  @get
  retrieve(
    @path payout_id: PayoutId,
  ): {
    @statusCode statusCode: 200;
    @body body: Payout;
  } | StandardErrorsWithNotFoundAndTooMany;
}
