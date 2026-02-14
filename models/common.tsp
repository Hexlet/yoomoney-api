using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace YooKassa;

// === Скалярные типы ===

scalar PaymentId extends string;
scalar RefundId extends string;
scalar ReceiptId extends string;
scalar DealId extends string;
scalar PayoutId extends string;
scalar InvoiceId extends string;
scalar PaymentMethodId extends string;
scalar PersonalDataId extends string;
scalar SelfEmployedId extends string;
scalar AccountId extends string;
scalar GatewayId extends string;
scalar BasketId extends string;
scalar NextCursor extends string;
scalar PaymentToken extends string;
scalar ReturnUrl extends string;
scalar ConfirmationUrl extends string;
scalar MerchantCustomerId extends string;
scalar Description extends string;
scalar RussianItn extends string;
scalar GlobalItn extends string;
@format("email") scalar Email extends string;
scalar Phone extends string;
scalar Rrn extends string;
scalar ClientIp extends string;
scalar BankCardFirst6 extends string;
scalar BankCardLast4 extends string;
scalar BankCardExpiryYear extends string;
scalar BankCardExpiryMonth extends string;
scalar BankCardIssuerCountry extends string;
scalar BankCardIssuerName extends string;
scalar BankCardHolderName extends string;
scalar PaymentPurpose extends string;
scalar YooMoneyAccountNumber extends string;
scalar SbpBankId extends string;
scalar SbpBankBic extends string;
scalar LastName extends string;
scalar FirstName extends string;
scalar MiddleName extends string;
scalar MarkMode extends string;
scalar Kbk extends string;
scalar Oktmo extends string;
scalar ReceiptItemDescription extends string;
scalar ReceiptItemCountryOfOriginCode extends string;
scalar ReceiptItemCustomsDeclarationNumber extends string;
scalar ReceiptItemExcise extends string;
scalar ReceiptItemProductCode extends string;
scalar IncomeReceiptServiceName extends string;
scalar NpdIncomeReceiptId extends string;
scalar IncomeReceiptUrl extends string;

// === Enums ===

enum CurrencyCode {
  RUB,
  EUR,
  USD,
  KZT,
  BYN,
  UAH,
  UZS,
  TRY,
  INR,
  MDL,
  AZN,
  AMD,
}

enum Locale {
  ru_RU,
  en_US,
}

// === Общие модели ===

model MonetaryAmount {
  @doc("Сумма в выбранной валюте. Выражается в виде строки и пишется через точку, например 10.00.")
  value: string;

  @doc("Код валюты в формате ISO-4217.")
  currency: CurrencyCode;
}

@doc("Любые дополнительные данные, которые нужны вам для работы (например, номер заказа). Передаются в виде набора пар «ключ-значение» и возвращаются в ответе от ЮKassa. Ограничения: максимум 16 ключей, имя ключа не больше 32 символов, значение ключа не больше 512 символов, тип данных — строка в формате UTF-8.")
model Metadata is Record<string>;

model Recipient {
  @doc("Идентификатор субаккаунта. Используется для разделения потоков платежей в рамках одного аккаунта.")
  gateway_id: GatewayId;
}

model ThreeDSecureDetails {
  @doc("Отображает, была ли пройдена аутентификация по 3-D Secure.")
  applied: boolean;
}

model AuthorizationDetails {
  rrn?: Rrn;
  auth_code?: string;
  three_d_secure: ThreeDSecureDetails;
}

model BankCardProduct {
  @doc("Код продукта.")
  code: string;

  @doc("Название продукта.")
  name?: string;
}

enum BankCardDataSource {
  apple_pay,
  google_pay,
  mir_pay,
}

model BankCardData {
  first6?: BankCardFirst6;
  last4: BankCardLast4;
  expiry_year: BankCardExpiryYear;
  expiry_month: BankCardExpiryMonth;
  card_type: BankCardType;
  card_product?: BankCardProduct;
  issuer_country?: BankCardIssuerCountry;
  issuer_name?: BankCardIssuerName;
  source?: BankCardDataSource;
}

enum BankCardType {
  MasterCard,
  Visa,
  Mir,
  UnionPay,
  JCB,
  AmericanExpress,
  DinersClub,
  DiscoverCard,
  InstaPayment,
  InstaPaymentTM,
  Laser,
  Dankort,
  Solo,
  Switch,
  Unknown,
}

model CardRequestData {
  @doc("Номер банковской карты.")
  number: string;

  @doc("Срок действия, год. Формат: YYYY.")
  expiry_year: string;

  @doc("Срок действия, месяц. Формат: MM.")
  expiry_month: string;

  @doc("Имя владельца карты.")
  cardholder?: BankCardHolderName;
}

model CardRequestDataWithCsc extends CardRequestData {
  @doc("Код CVC2 или CVV2, 3 или 4 символа, печатается на обратной стороне карты.")
  csc?: string;
}

model InvoicingBankCardData {
  first6: BankCardFirst6;
  last4: BankCardLast4;
  expiry_year: BankCardExpiryYear;
  expiry_month: BankCardExpiryMonth;
  card_type: BankCardType;
}

model SbpPayerBankDetails {
  bank_id: SbpBankId;
  bic: SbpBankBic;
}

model CardDataForPayoutDestination {
  @doc("Номер банковской карты.")
  number: string;
}

// === Airline (авиабилеты) ===

model AirlinePassenger {
  first_name: string;
  last_name: string;
}

model AirlineLeg {
  departure_airport: string;
  destination_airport: string;
  departure_date: string;
  carrier_code?: string;
}

model Airline {
  ticket_number?: string;
  booking_reference?: string;
  passengers?: AirlinePassenger[];
  legs?: AirlineLeg[];
}

// === Transfer ===

enum TransferStatus {
  pending,
  waiting_for_capture,
  succeeded,
  canceled,
}

model TransferData {
  @doc("Идентификатор магазина, в пользу которого вы принимаете оплату.")
  account_id: AccountId;

  @doc("Сумма, которую необходимо перевести магазину.")
  amount: MonetaryAmount;

  @doc("Комиссия за проданные товары и оказанные услуги, которую вы удерживаете при оплате.")
  platform_fee_amount?: MonetaryAmount;
}

model TransferDataPayment extends TransferData {
  @doc("Описание транзакции.")
  description?: string;

  metadata?: Metadata;
}

model TransferDataCapture extends TransferData {}

model Transfer {
  @doc("Идентификатор магазина, в пользу которого вы принимаете оплату.")
  account_id: AccountId;

  @doc("Сумма, которую необходимо перевести магазину.")
  amount: MonetaryAmount;

  @doc("Статус распределения денег.")
  status: TransferStatus;

  @doc("Комиссия за проданные товары и оказанные услуги, которую вы удерживаете при оплате.")
  platform_fee_amount?: MonetaryAmount;

  @doc("Описание транзакции.")
  description?: string;

  metadata?: Metadata;
}

// === Settlement ===

enum SettlementItemType {
  payout,
}

model SettlementPaymentItem {
  type: SettlementItemType;
  amount: MonetaryAmount;
}

model SettlementPayoutPayment extends SettlementPaymentItem {}

model SettlementRefundItem {
  type: SettlementItemType;
  amount: MonetaryAmount;
}

model SettlementPayoutRefund extends SettlementRefundItem {}

model Settlement {
  @doc("Тип расчета.")
  type: string;

  @doc("Сумма расчета.")
  amount: MonetaryAmount;
}

// === Payment Order ===

model PaymentPeriod {
  month: integer;
  year: integer;
}

model PaymentOrderBankUtilities {
  name: string;
  bic: string;
  account: string;
  correspondent_account: string;
}

model PaymentOrderRecipientUtilities {
  name: string;
  inn: string;
  kpp: string;
  bank: PaymentOrderBankUtilities;
}

model PaymentOrderData {
  @doc("Тип платежного поручения.")
  type: string;
}

model PaymentOrderDataUtilities extends PaymentOrderData {
  @doc("Получатель платежа.")
  recipient?: PaymentOrderRecipientUtilities;

  @doc("КБК.")
  kbk?: Kbk;

  @doc("ОКТМО.")
  oktmo?: Oktmo;

  @doc("Назначение платежа.")
  purpose?: string;

  @doc("Период оплаты.")
  payment_period?: PaymentPeriod;
}

// === Receiver ===

enum ReceiverType {
  mobile_balance,
  digital_wallet,
  bank_account,
}

model Receiver {
  @doc("Тип получателя.")
  type: ReceiverType;
}

model ReceiverMobileBalance extends Receiver {
  @doc("Номер телефона для пополнения.")
  phone: Phone;
}

model ReceiverDigitalWallet extends Receiver {
  @doc("Идентификатор электронного кошелька для пополнения.")
  @maxLength(20)
  account_number: string;
}

model ReceiverBankAccount extends Receiver {
  @doc("Номер банковского счета.")
  @maxLength(20)
  account_number: string;

  @doc("Банковский идентификационный код (БИК) банка.")
  @maxLength(9)
  bic: string;
}

// === Statement ===

model Statement {
  @doc("Тип справки.")
  type: string;
}

enum PaymentOverviewStatementDeliveryMethodType {
  email,
}

model PaymentOverviewStatementDeliveryMethod {
  type: PaymentOverviewStatementDeliveryMethodType;
}

model PaymentOverviewStatementEmailDeliveryMethod extends PaymentOverviewStatementDeliveryMethod {
  @doc("Электронная почта пользователя для отправки справки.")
  email: Email;
}

model PaymentOverviewStatementData extends Statement {
  @doc("Способ доставки справки.")
  delivery_method: PaymentOverviewStatementEmailDeliveryMethod;
}

// === Cancellation Details ===

model PaymentCancellationDetails {
  @doc("Участник процесса платежа, принявший решение об отмене.")
  party: string;

  @doc("Причина отмены платежа.")
  reason: string;
}

// === B2B Sberbank VAT ===

enum B2bSberbankVatDataType {
  calculated,
  untaxed,
  mixed,
}

model B2bSberbankVatData {
  type: B2bSberbankVatDataType;
}

model B2bSberbankCalculatedVatData extends B2bSberbankVatData {
  @doc("Налоговая ставка (в процентах).")
  rate: string;

  @doc("Сумма НДС.")
  amount: MonetaryAmount;
}

model B2bSberbankUntaxedVatData extends B2bSberbankVatData {}

model B2bSberbankMixedVatData extends B2bSberbankVatData {
  @doc("Сумма НДС.")
  amount: MonetaryAmount;
}

model B2bSberbankPayerBankDetails {
  full_name: string;
  short_name: string;
  address: string;
  inn: string;
  bank_name: string;
  bank_branch: string;
  bank_bik: string;
  account: string;
  kpp?: string;
}

// === Electronic Certificate ===

model ElectronicCertificatePayment {
  amount: MonetaryAmount;
  basket_id: BasketId;
}

model ElectronicCertificateApprovedPaymentArticle {
  article_number: int32;
  tru_code: string;
  article_code?: string;
  certificates: ElectronicCertificate[];
}

model ElectronicCertificate {
  certificate_id: string;
  tru_quantity: int32;
  available_compensation: MonetaryAmount;
  applied_compensation: MonetaryAmount;
}

model ElectronicCertificatePaymentData {
  amount: MonetaryAmount;
  basket_id: BasketId;
}

model ElectronicCertificateArticle {
  article_number: int32;
  tru_code: string;
  article_code?: string;
  article_name: string;
  quantity: int32;
  price: MonetaryAmount;
  metadata?: Metadata;
}

// === Income Receipt ===

model IncomeReceipt {
  service_name: IncomeReceiptServiceName;
  npd_receipt_id?: NpdIncomeReceiptId;
  url?: IncomeReceiptUrl;
  amount?: MonetaryAmount;
}

// === SBP Participant Bank ===

model SbpParticipantBank {
  @doc("Идентификатор участника СБП.")
  bank_id: SbpBankId;

  @doc("Название участника СБП.")
  name: string;

  @doc("БИК участника СБП.")
  bic: SbpBankBic;
}

// === Payment Data (для Invoice) ===

model PaymentData {
  amount: MonetaryAmount;
  receipt?: ReceiptData;
  recipient?: Recipient;
  save_payment_method?: boolean;
  capture?: boolean;
  client_ip?: ClientIp;
  description?: Description;
  metadata?: Metadata;
}

// === Fiscalization ===

enum FiscalizationProvider {
  atol,
  avanpost,
  a_qsi,
  business_ru,
  digital_kassa,
  evotor,
  first_ofd,
  kit_invest,
  komtet,
  life_pay,
  mertrade,
  modul_kassa,
  rocket,
  shtrih_m,
}

model FiscalizationData {
  enabled: boolean;
  provider: FiscalizationProvider;
}

// === Mark Code Info ===

model MarkCodeInfo {
  mark_code_raw?: string;
  `unknown`?: string;
  ean_8?: string;
  ean_13?: string;
  itf_14?: string;
  gs_10?: string;
  gs_1m?: string;
  short?: string;
  fur?: string;
  egais_20?: string;
  egais_30?: string;
}

model MarkQuantity {
  numerator: int32;
  denominator: int32;
}

// === Payment Details (для Invoice) ===

model PaymentDetails {
  id: string;
  status: string;
}

// === Invoice Cancellation Details ===

model InvoiceCancellationDetails {
  party: string;
  reason: string;
}
