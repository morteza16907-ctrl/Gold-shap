export function successResponse(data: unknown, message = "Success") {
  return {
    success: true,
    message,
    data,
  };
}

export function errorResponse(message = "Error") {
  return {
    success: false,
    message,
  };
}
