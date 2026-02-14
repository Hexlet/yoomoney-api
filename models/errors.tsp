using TypeSpec.Http;

namespace YooKassa;

// === Модель ошибки ===

@doc("Объект ошибки.")
model Error {
  @doc("Тип ошибки.")
  type?: string;

  @doc("Идентификатор ошибки.")
  id?: string;

  @doc("Описание ошибки.")
  description?: string;

  @doc("Параметр, в котором произошла ошибка.")
  parameter?: string;

  @doc("Время в секундах, через которое можно повторить запрос.")
  retry_after?: integer;
}

model BadRequest extends Error {}
model InvalidCredentials extends Error {}
model Forbidden extends Error {}
model NotFound extends Error {}
model Gone extends Error {}
model TooManyRequests extends Error {}

// === Общие ответы ===

alias BadRequestResponse = {
  @statusCode statusCode: 400;
  @body body: BadRequest;
};

alias InvalidCredentialsResponse = {
  @statusCode statusCode: 401;
  @body body: InvalidCredentials;
};

alias ForbiddenResponse = {
  @statusCode statusCode: 403;
  @body body: Forbidden;
};

alias NotFoundResponse = {
  @statusCode statusCode: 404;
  @body body: NotFound;
};

alias TooManyRequestsResponse = {
  @statusCode statusCode: 429;
  @body body: TooManyRequests;
};

alias InternalServerErrorResponse = {
  @statusCode statusCode: 500;
  @body body: TooManyRequests;
};

alias StandardErrors = BadRequestResponse | InvalidCredentialsResponse | ForbiddenResponse | InternalServerErrorResponse;

alias StandardErrorsWithNotFound = StandardErrors | NotFoundResponse;

alias StandardErrorsWithTooMany = StandardErrors | TooManyRequestsResponse;

alias StandardErrorsWithNotFoundAndTooMany = StandardErrors | NotFoundResponse | TooManyRequestsResponse;
