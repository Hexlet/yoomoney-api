using TypeSpec.Http;

namespace YooKassa;

// === SBP Banks List Response ===

model SbpBanksList {
  type: string;
  items: SbpParticipantBank[];
}

// === SBP Banks API ===

@route("/sbp_banks")
@tag("Участники СБП")
interface SbpBanks {
  @doc("Список участников СБП")
  @get
  list(): {
    @statusCode statusCode: 200;
    @body body: SbpBanksList;
  } | StandardErrorsWithNotFoundAndTooMany;
}
