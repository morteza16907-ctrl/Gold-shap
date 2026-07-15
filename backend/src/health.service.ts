export function getHealthStatus() {
  return {
    success: true,
    message: "Gold ERP API is running",
    timestamp: new Date().toISOString(),
  };
}
