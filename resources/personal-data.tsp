using TypeSpec.Http;

namespace YooKassa;

// === Personal Data ===

enum PersonalDataType {
  payout_statement_recipient,
  sbp_payout_recipient,
}

model PersonalDataCancellationDetails {
  party: string;
  reason: string;
}

model PersonalData {
  @doc("Идентификатор персональных данных.")
  id: PersonalDataId;

  @doc("Тип персональных данных.")
  type: PersonalDataType;

  @doc("Статус хранения персональных данных.")
  status: string;

  @doc("Комментарий к статусу canceled.")
  cancellation_details?: PersonalDataCancellationDetails;

  @doc("Время создания персональных данных.")
  created_at: utcDateTime;

  @doc("Срок жизни персональных данных.")
  expires_at?: utcDateTime;

  metadata?: Metadata;
}

// === Personal Data Request ===

model PersonalDataRequest {
  @doc("Тип персональных данных.")
  type: PersonalDataType;

  metadata?: Metadata;
}

model SbpPayoutRecipientPersonalDataRequest extends PersonalDataRequest {
  @doc("Фамилия.")
  last_name: LastName;

  @doc("Имя.")
  first_name: FirstName;

  @doc("Отчество.")
  middle_name?: MiddleName;
}

model PayoutStatementRecipientPersonalDataRequest extends PersonalDataRequest {
  @doc("Фамилия.")
  last_name: LastName;

  @doc("Имя.")
  first_name: FirstName;

  @doc("Отчество.")
  middle_name?: MiddleName;
}

// === Personal Data API ===

@route("/personal_data")
@tag("Персональные данные")
interface PersonalDataResource {
  @doc("Создание персональных данных")
  @post
  create(
    @header("Idempotence-Key") idempotenceKey: string,
    @body body: SbpPayoutRecipientPersonalDataRequest | PayoutStatementRecipientPersonalDataRequest,
  ): {
    @statusCode statusCode: 200;
    @body body: PersonalData;
  } | StandardErrorsWithTooMany;

  @doc("Информация о персональных данных")
  @route("{personal_data_id}")
  @get
  retrieve(
    @path personal_data_id: PersonalDataId,
  ): {
    @statusCode statusCode: 200;
    @body body: PersonalData;
  } | StandardErrorsWithNotFoundAndTooMany;
}
