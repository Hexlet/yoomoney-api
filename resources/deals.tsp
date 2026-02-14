using TypeSpec.Http;

namespace YooKassa;

// === Deal List ===

model DealList {
  type: string;
  items: SafeDeal[];
  next_cursor?: NextCursor;
}

// === Deals API ===

@route("/deals")
@tag("Сделки")
interface Deals {
  @doc("Создание сделки")
  @post
  create(
    @header("Idempotence-Key") idempotenceKey: string,
    @body body: SafeDealRequest,
  ): {
    @statusCode statusCode: 200;
    @body body: SafeDeal;
  } | StandardErrorsWithTooMany;

  @doc("Список сделок")
  @get
  list(
    @query("created_at.gte") createdGte?: utcDateTime,
    @query("created_at.gt") createdGt?: utcDateTime,
    @query("created_at.lte") createdLte?: utcDateTime,
    @query("created_at.lt") createdLt?: utcDateTime,
    @query("expires_at.gte") expiresGte?: utcDateTime,
    @query("expires_at.gt") expiresGt?: utcDateTime,
    @query("expires_at.lte") expiresLte?: utcDateTime,
    @query("expires_at.lt") expiresLt?: utcDateTime,
    @query status?: DealStatus,
    @query full_text_search?: string,
    @query @minValue(1) @maxValue(100) limit?: int32 = 10,
    @query cursor?: string,
  ): {
    @statusCode statusCode: 200;
    @body body: DealList;
  } | StandardErrorsWithNotFoundAndTooMany;

  @doc("Информация о сделке")
  @route("{deal_id}")
  @get
  retrieve(
    @path deal_id: DealId,
  ): {
    @statusCode statusCode: 200;
    @body body: SafeDeal;
  } | StandardErrorsWithNotFoundAndTooMany;
}
