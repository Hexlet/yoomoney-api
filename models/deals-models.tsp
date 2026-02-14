namespace YooKassa;

// === Deal Enums ===

enum DealType {
  safe_deal,
}

enum DealStatus {
  opened,
  closed,
}

enum FeeMoment {
  payment_succeeded,
  deal_closed,
}

// === Deal Models ===

model BaseDeal {
  @doc("Тип сделки.")
  type: DealType;
}

model SafeDeal extends BaseDeal {
  @doc("Идентификатор сделки.")
  id: DealId;

  @doc("Момент удержания вознаграждения.")
  fee_moment: FeeMoment;

  @doc("Описание сделки.")
  description?: Description;

  @doc("Баланс сделки.")
  balance: MonetaryAmount;

  @doc("Сумма вознаграждения продавца.")
  payout_balance: MonetaryAmount;

  @doc("Статус сделки.")
  status: DealStatus;

  @doc("Время создания сделки.")
  created_at: utcDateTime;

  @doc("Время автоматического закрытия сделки.")
  expires_at: utcDateTime;

  metadata?: Metadata;

  @doc("Признак тестовой операции.")
  test: boolean;
}

model SafeDealRequest {
  @doc("Тип сделки.")
  type: DealType;

  @doc("Момент удержания вознаграждения.")
  fee_moment: FeeMoment;

  metadata?: Metadata;

  @doc("Описание сделки.")
  description?: Description;
}

model PaymentDealInfo {
  @doc("Идентификатор сделки.")
  id: DealId;

  @doc("Данные о распределении денег.")
  settlements: SettlementPaymentItem[];
}

model PayoutDealInfo {
  @doc("Идентификатор сделки.")
  id: DealId;
}

model RefundDealData {
  @doc("Данные о распределении денег.")
  refund_settlements: SettlementRefundItem[];
}

model RefundDealInfo {
  @doc("Идентификатор сделки.")
  id: DealId;

  @doc("Данные о распределении денег.")
  refund_settlements: SettlementRefundItem[];
}
