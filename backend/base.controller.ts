import { Request, Response } from "express";

export abstract class BaseController {
  protected ok(res: Response, data: unknown) {
    return res.status(200).json({
      success: true,
      data,
    });
  }

  protected created(res: Response, data: unknown) {
    return res.status(201).json({
      success: true,
      data,
    });
  }

  protected notFound(res: Response, message = "Not Found") {
    return res.status(404).json({
      success: false,
      message,
    });
  }

  protected badRequest(res: Response, message = "Bad Request") {
    return res.status(400).json({
      success: false,
      message,
    });
  }
}
