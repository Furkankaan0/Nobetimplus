import { Router } from "express";
import { randomUUID } from "node:crypto";
import { z } from "zod";
import { requireAuth } from "../middleware/auth.js";
import { requireRole } from "../middleware/rbac.js";
import { validateBody } from "../middleware/validate.js";

const router = Router();

const announcementSchema = z.object({
  teamId: z.string().uuid(),
  title: z.string().min(2),
  message: z.string().min(2)
});

router.get("/", requireAuth, (_req, res) => {
  res.json({ announcements: [] });
});

router.post("/", requireAuth, requireRole("admin", "team_lead"), validateBody(announcementSchema), (req, res) => {
  res.status(201).json({ announcement: { id: randomUUID(), createdAt: new Date().toISOString(), ...req.body } });
});

export default router;
