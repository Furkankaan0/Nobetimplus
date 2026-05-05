import cors from "cors";
import express from "express";
import helmet from "helmet";
import authRouter from "./routes/auth.js";
import usersRouter from "./routes/users.js";
import teamsRouter from "./routes/teams.js";
import shiftsRouter from "./routes/shifts.js";
import announcementsRouter from "./routes/announcements.js";
import swapRequestsRouter from "./routes/swapRequests.js";
import { errorHandler } from "./middleware/error.js";

export function makeApp() {
  const app = express();
  app.use(helmet());
  app.use(cors());
  app.use(express.json({ limit: "1mb" }));

  app.get("/health", (_req, res) => res.json({ ok: true, service: "nobetimplus-api" }));
  app.use("/auth", authRouter);
  app.use("/users", usersRouter);
  app.use("/teams", teamsRouter);
  app.use("/shifts", shiftsRouter);
  app.use("/announcements", announcementsRouter);
  app.use("/swap-requests", swapRequestsRouter);
  app.use(errorHandler);

  return app;
}
