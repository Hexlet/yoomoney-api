namespace YooKassa;

// === Receipt Enums ===

enum ReceiptItemMeasure {
  piece,
  gram,
  kilogram,
  ton,
  centimeter,
  decimeter,
  meter,
  square_centimeter,
  square_decimeter,
  square_meter,
  milliliter,
  liter,
  cubic_meter,
  kilowatt_hour,
  gigacalorie,
  day,
  hour,
  minute,
  second,
  kilobyte,
  megabyte,
  gigabyte,
  terabyte,
  another,
}

enum ReceiptItemPaymentSubject {
  commodity,
  excise,
  job,
  service,
  gambling_bet,
  gambling_prize,
  lottery,
  lottery_prize,
  intellectual_activity,
  payment,
  agent_commission,
  property_right,
  non_operating_gain,
  insurance_premium,
  sales_tax,
  resort_fee,
  composite,
  another,
  fine,
  tax,
  lien,
  cost,
  pension_insurance_without_payouts,
  pension_insurance_with_payouts,
  health_insurance_without_payouts,
  health_insurance_with_payouts,
  health_insurance,
  casino,
  agent_withdrawals,
  non_marked_excise,
  marked_excise,
  marked,
  non_marked,
}

enum ReceiptItemPaymentMode {
  full_prepayment,
  partial_prepayment,
  advance,
  full_payment,
  partial_payment,
  credit,
  credit_payment,
}

enum ReceiptRegistrationStatus {
  pending,
  succeeded,
  canceled,
}

enum ReceiptType {
  payment,
  refund,
}

enum ReceiptItemAgentType {
  banking_payment_agent,
  banking_payment_subagent,
  payment_agent,
  payment_subagent,
  attorney,
  commissioner,
  agent,
}

// === Receipt Models ===

model ReceiptDataCustomer {
  full_name?: string;
  inn?: RussianItn;
  email?: Email;
  phone?: Phone;
}

model IndustryDetails {
  federal_id: string;
  document_date: string;
  document_number: string;
  value: string;
}

model OperationalDetails {
  operation_id: int32;
  value: string;
  created_at: utcDateTime;
}

model ReceiptDataItem {
  @doc("Название товара.")
  description: ReceiptItemDescription;

  @doc("Сумма.")
  amount: MonetaryAmount;

  @doc("Ставка НДС.")
  vat_code: int32;

  @doc("Количество.")
  quantity: float64;

  measure?: ReceiptItemMeasure;
  mark_quantity?: MarkQuantity;
  payment_subject?: ReceiptItemPaymentSubject;
  payment_mode?: ReceiptItemPaymentMode;
  country_of_origin_code?: ReceiptItemCountryOfOriginCode;
  customs_declaration_number?: ReceiptItemCustomsDeclarationNumber;
  excise?: ReceiptItemExcise;
  product_code?: ReceiptItemProductCode;
  planned_status?: int32;
  mark_code_info?: MarkCodeInfo;
  mark_mode?: MarkMode;
  payment_subject_industry_details?: IndustryDetails[];
}

model ReceiptData {
  customer?: ReceiptDataCustomer;
  items: ReceiptDataItem[];
  internet?: boolean;
  tax_system_code?: int32;
  timezone?: string;
  receipt_industry_details?: IndustryDetails[];
  receipt_operational_details?: OperationalDetails;
}

model ReceiptItemSupplier {
  name?: string;
  phone?: Phone;
}

model ReceiptItemSupplierWithInn extends ReceiptItemSupplier {
  inn?: RussianItn;
}

model ReceiptItem {
  description: ReceiptItemDescription;
  quantity: float64;
  amount: MonetaryAmount;
  vat_code: int32;
  payment_subject?: ReceiptItemPaymentSubject;
  payment_mode?: ReceiptItemPaymentMode;
  country_of_origin_code?: ReceiptItemCountryOfOriginCode;
  customs_declaration_number?: ReceiptItemCustomsDeclarationNumber;
  excise?: ReceiptItemExcise;
  supplier?: ReceiptItemSupplierWithInn;
  agent_type?: ReceiptItemAgentType;
  mark_code_info?: MarkCodeInfo;
  measure?: ReceiptItemMeasure;
  payment_subject_industry_details?: IndustryDetails[];
  product_code?: ReceiptItemProductCode;
  planned_status?: int32;
  mark_mode?: MarkMode;
  mark_quantity?: MarkQuantity;
}

model ReceiptAdditionalUserProps {
  name: string;
  value: string;
}

model PostReceiptDataItem extends ReceiptDataItem {
  @doc("Дополнительный реквизит предмета расчета.")
  additional_payment_subject_props?: string;

  supplier?: ReceiptItemSupplierWithInn;
  agent_type?: ReceiptItemAgentType;
}

model PostReceiptItemSupplierWithInn extends ReceiptItemSupplier {
  inn?: RussianItn;
}
