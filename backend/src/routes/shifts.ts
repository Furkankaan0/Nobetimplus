import { Router } from "express";
import { z } from "zod";
import { requireAuth } from "../middleware/auth.js";
import { validateBody } from "../middleware/validate.js";

const router = Router();

const shiftSchema = z.object({
  id: z.string().uuid().optional(),
  teamId: z.string().uuid().optional(),
  title: z.string().min(1),
  startDate: z.string().datetime(),
  endDate: z.string().datetime(),
  shiftType: z.enum(["day", "night", "onCall", "officialHoliday", "overtime"]),
  location: z.string().min(1),
  notes: z.string().optional(),
  isHoliday: z.boolean().default(false),
  isOvertime: z.boolean().default(false),
  hourlyRate: z.number().positive().optional(),
  updatedAt: z.string().datetime()
});

router.get("/", requireAuth, (_req, res) => {
  res.json({ shifts: [] });
});

router.post("/", requireAuth, validateBody(shiftSchema), (req, res) => {
  res.status(201).json({ shift: req.body });
});

router.delete("/:id", requireAuth, (req, res) => {
  res.json({ id: req.params.id, deletedAt: new Date().toISOString() });
});

export default router;
