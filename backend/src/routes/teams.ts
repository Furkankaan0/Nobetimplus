import { Router } from "express";
import { randomUUID } from "node:crypto";
import { z } from "zod";
import { requireAuth } from "../middleware/auth.js";
import { requireRole } from "../middleware/rbac.js";
import { validateBody } from "../middleware/validate.js";

const router = Router();

const createTeamSchema = z.object({
  name: z.string().min(2),
  department: z.string().min(2)
});

router.get("/", requireAuth, (_req, res) => {
  res.json({ teams: [] });
});

router.post("/", requireAuth, requireRole("admin", "team_lead"), validateBody(createTeamSchema), (req, res) => {
  res.status(201).json({ team: { id: randomUUID(), inviteCode: "NOBET-PLUS", ...req.body } });
});

export default router;
