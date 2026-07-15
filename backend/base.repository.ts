import pool from "../config/database";

export abstract class BaseRepository {
  protected db = pool;
}
