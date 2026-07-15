import { Request, Response } from "express";

export const healthCheck = (
  req: Request,
  res: Response
): void => {
  res.status(200).json({
    success: true,
    message: "Gold ERP API is running",
    timestamp: new Date().toISOString(),
  });
};
