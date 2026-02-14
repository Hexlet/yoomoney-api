namespace YooKassa;

// === Payout Enums ===

enum PayoutDestinationDataType {
  yoo_money,
  bank_card,
  sbp,
}

enum PayoutStatus {
  pending,
  succeeded,
  canceled,
}

enum PayoutDestinationType {
  bank_card,
  yoo_money,
  sbp,
}

enum PayoutMethodType {
  bank_card,
  yoo_money,
  sbp,
}

// === Payout Destination Data (request) ===

model PayoutDestinationData {
  @doc("Тип метода для проведения выплаты.")
  type: PayoutDestinationDataType;
}

model PayoutToYooMoneyDestinationData extends PayoutDestinationData {
  @doc("Номер кошелька ЮMoney.")
  account_number: YooMoneyAccountNumber;
}

model PayoutToBankCardDestinationData extends PayoutDestinationData {
  @doc("Данные банковской карты.")
  card: CardDataForPayoutDestination;
}

model PayoutToSbpDestinationData extends PayoutDestinationData {
  @doc("Идентификатор банка.")
  bank_id: SbpBankId;

  @doc("Номер телефона.")
  phone: Phone;
}

// === Payout Destination (response) ===

model PayoutDestination {
  @doc("Тип метода для проведения выплаты.")
  type: PayoutDestinationType;
}

model PayoutToCardDestination extends PayoutDestination {
  card?: PayoutCardData;
}

model PayoutToYooMoneyDestination extends PayoutDestination {
  account_number: YooMoneyAccountNumber;
}

model PayoutToSbpDestination extends PayoutDestination {
  bank_id?: SbpBankId;
  phone?: Phone;
}

model PayoutCardData {
  first6: BankCardFirst6;
  last4: BankCardLast4;
  card_type: BankCardType;
  issuer_country?: BankCardIssuerCountry;
  issuer_name?: BankCardIssuerName;
}

// === Payout Cancellation Details ===

model PayoutCancellationDetails {
  party: string;
  reason: string;
}

// === Payout Self Employed ===

model PayoutSelfEmployedInfo {
  id: SelfEmployedId;
}

model PayoutsPersonalData {
  id: PersonalDataId;
}

// === Payout ===

model PayoutRequest {
  @doc("Сумма выплаты.")
  amount: MonetaryAmount;

  @doc("Данные для проведения выплаты.")
  payout_destination_data?: PayoutToYooMoneyDestinationData | PayoutToBankCardDestinationData | PayoutToSbpDestinationData;

  @doc("Токен для проведения выплаты.")
  payout_token?: string;

  @doc("Идентификатор сохраненного способа оплаты.")
  payment_method_id?: PaymentMethodId;

  @doc("Описание выплаты.")
  description?: Description;

  @doc("Данные о сделке.")
  deal?: PayoutDealInfo;

  @doc("Персональные данные получателя выплаты.")
  personal_data?: PayoutsPersonalData[];

  metadata?: Metadata;
}

model Payout {
  @doc("Идентификатор выплаты.")
  id: PayoutId;

  @doc("Сумма выплаты.")
  amount: MonetaryAmount;

  @doc("Статус выплаты.")
  status: PayoutStatus;

  @doc("Данные о назначении выплаты.")
  payout_destination: PayoutToCardDestination | PayoutToYooMoneyDestination | PayoutToSbpDestination;

  @doc("Описание выплаты.")
  description?: Description;

  @doc("Время создания выплаты.")
  created_at: utcDateTime;

  @doc("Время проведения выплаты.")
  succeeded_at?: utcDateTime;

  @doc("Данные о сделке.")
  deal?: PayoutDealInfo;

  @doc("Данные о самозанятом.")
  self_employed?: PayoutSelfEmployedInfo;

  @doc("Данные о чеке.")
  receipt?: IncomeReceipt;

  @doc("Детали отмены выплаты.")
  cancellation_details?: PayoutCancellationDetails;

  metadata?: Metadata;

  @doc("Признак тестовой операции.")
  test: boolean;
}

model PayoutsList {
  @doc("Тип списка.")
  type: string;

  @doc("Список выплат.")
  items: Payout[];

  @doc("Курсор для получения следующей страницы.")
  next_cursor?: NextCursor;
}
