namespace YooKassa;

// === Payment Method Type ===

enum PaymentMethodType {
  bank_card,
  cash,
  alfabank,
  webmoney,
  wechat,
  apple_pay,
  google_pay,
  qiwi,
  installments,
  yoo_money,
  sberbank,
  mobile_balance,
  b2b_sberbank,
  tinkoff_bank,
  sbp,
  sber_loan,
  electronic_certificate,
  sber_bnpl,
}

enum PaymentMethodStatus {
  pending,
  active,
  inactive,
}

// === Payment Method (response) ===

model PaymentMethod {
  @doc("Код способа оплаты.")
  type: PaymentMethodType;

  @doc("Идентификатор способа оплаты.")
  id: PaymentMethodId;

  @doc("Признак сохранения платежных данных.")
  saved: boolean;

  @doc("Статус способа оплаты.")
  status: PaymentMethodStatus;

  @doc("Название способа оплаты.")
  title?: string;
}

model PaymentMethodBankCard extends PaymentMethod {
  card?: BankCardData;
}

model PaymentMethodCash extends PaymentMethod {}

model PaymentMethodQiwi extends PaymentMethod {}

model PaymentMethodAlfabank extends PaymentMethod {
  login?: string;
}

model PaymentMethodWebmoney extends PaymentMethod {}

model PaymentMethodSberbank extends PaymentMethod {
  phone?: Phone;
}

model PaymentMethodTinkoffBank extends PaymentMethod {}

model PaymentMethodYooMoney extends PaymentMethod {
  account_number?: YooMoneyAccountNumber;
}

model PaymentMethodApplePay extends PaymentMethod {}

model PaymentMethodGooglePay extends PaymentMethod {}

model PaymentMethodMobileBalance extends PaymentMethod {
  phone?: Phone;
}

model PaymentMethodInstallments extends PaymentMethod {}

model PaymentMethodB2bSberbank extends PaymentMethod {
  payment_purpose?: PaymentPurpose;
  vat_data?: B2bSberbankVatData;
  payer_bank_details?: B2bSberbankPayerBankDetails;
}

model PaymentMethodWeChat extends PaymentMethod {}

model PaymentMethodSbp extends PaymentMethod {
  @doc("Идентификатор операции в СБП (НСПК).")
  sbp_operation_id?: string;

  payer_bank_details?: SbpPayerBankDetails;
}

model PaymentMethodSberLoan extends PaymentMethod {}

model PaymentMethodElectronicCertificate extends PaymentMethod {
  electronic_certificate?: ElectronicCertificatePayment;
  articles?: ElectronicCertificateApprovedPaymentArticle[];
}

model PaymentMethodSberBnpl extends PaymentMethod {}

// === Payment Method Data (request) ===

model PaymentMethodData {
  @doc("Код способа оплаты.")
  type: PaymentMethodType;
}

model PaymentMethodDataBankCard extends PaymentMethodData {
  card?: CardRequestDataWithCsc;
}

model PaymentMethodDataCash extends PaymentMethodData {
  @doc("Телефон пользователя для смс с кодом платежа.")
  phone?: string;
}

model PaymentMethodDataSberbank extends PaymentMethodData {
  @doc("Телефон пользователя.")
  phone?: Phone;
}

model PaymentMethodDataTinkoffBank extends PaymentMethodData {}

model PaymentMethodDataYooMoney extends PaymentMethodData {}

model PaymentMethodDataMobileBalance extends PaymentMethodData {
  phone?: Phone;
}

model PaymentMethodDataB2bSberbank extends PaymentMethodData {
  @doc("Назначение платежа.")
  payment_purpose: PaymentPurpose;

  @doc("Данные об НДС.")
  vat_data: B2bSberbankCalculatedVatData | B2bSberbankUntaxedVatData | B2bSberbankMixedVatData;
}

model PaymentMethodDataSbp extends PaymentMethodData {}

model PaymentMethodDataSberLoan extends PaymentMethodData {}

model PaymentMethodDataElectronicCertificate extends PaymentMethodData {
  electronic_certificate?: ElectronicCertificatePaymentData;
  articles?: ElectronicCertificateArticle[];
}

model PaymentMethodDataSberBnpl extends PaymentMethodData {}

// === Save Payment Method ===

enum SavePaymentMethodType {
  bank_card,
}

enum PaymentMethodsConfirmationType {
  redirect,
}

model PaymentMethodsConfirmationData {
  type: PaymentMethodsConfirmationType;
}

model PaymentMethodsConfirmationDataRedirect extends PaymentMethodsConfirmationData {
  return_url: ReturnUrl;
}

model PaymentMethodsConfirmation {
  type: PaymentMethodsConfirmationType;
}

model PaymentMethodsConfirmationRedirect extends PaymentMethodsConfirmation {
  confirmation_url?: ConfirmationUrl;
}

model SavePaymentMethodData {
  type: SavePaymentMethodType;
  holder?: BankCardHolderName;
  client_ip?: ClientIp;
  confirmation?: PaymentMethodsConfirmationDataRedirect;
}

model SavePaymentMethodDataBankCard extends SavePaymentMethodData {
  card?: CardRequestDataWithCsc;
}

model SavePaymentMethod {
  type: SavePaymentMethodType;
  id: PaymentMethodId;
  saved: boolean;
  status: PaymentMethodStatus;
  holder: BankCardHolderName;
  title?: string;
  confirmation?: PaymentMethodsConfirmationRedirect;
}

model SavePaymentMethodBankCard extends SavePaymentMethod {
  card?: BankCardData;
}
