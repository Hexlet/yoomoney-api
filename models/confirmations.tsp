namespace YooKassa;

// === Confirmation Data Type ===

enum ConfirmationDataType {
  redirect,
  external,
  qr,
  embedded,
  mobile_application,
}

enum ConfirmationType {
  redirect,
  external,
  qr,
  embedded,
  mobile_application,
}

// === Confirmation Data (request) ===

model ConfirmationData {
  @doc("Код сценария подтверждения.")
  type: ConfirmationDataType;

  @doc("Язык интерфейса, писем и смс.")
  locale?: Locale;
}

model ConfirmationDataRedirect extends ConfirmationData {
  @doc("Требование пройти аутентификацию при оплате банковской картой по 3-D Secure.")
  enforce?: boolean;

  @doc("URL, на который необходимо перенаправить пользователя после оплаты.")
  return_url: ReturnUrl;
}

model ConfirmationDataExternal extends ConfirmationData {
  @doc("Язык интерфейса.")
  locale?: Locale;
}

model ConfirmationDataQr extends ConfirmationData {}

model ConfirmationDataEmbedded extends ConfirmationData {
  @doc("Язык интерфейса.")
  locale?: Locale;
}

model ConfirmationDataMobileApplication extends ConfirmationData {
  @doc("URL, на который необходимо перенаправить пользователя после оплаты.")
  return_url: ReturnUrl;
}

// === Confirmation (response) ===

model Confirmation {
  @doc("Код сценария подтверждения.")
  type: ConfirmationType;
}

model ConfirmationRedirect extends Confirmation {
  enforce?: boolean;
  return_url?: ReturnUrl;
  confirmation_url: ConfirmationUrl;
}

model ConfirmationExternal extends Confirmation {}

model ConfirmationQr extends Confirmation {
  confirmation_url?: ConfirmationUrl;
}

model ConfirmationEmbedded extends Confirmation {
  @doc("Токен для инициализации платежного виджета ЮKassa.")
  confirmation_token?: string;
}

model ConfirmationMobileApplication extends Confirmation {
  @doc("Ссылка для перенаправления пользователя в мобильное приложение.")
  confirmation_url?: ConfirmationUrl;
}
