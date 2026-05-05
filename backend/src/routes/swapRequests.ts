import { Router } from "express";
import { randomUUID } from "node:crypto";
import { z } from "zod";
import { requireAuth } from "../middleware/auth.js";
import { validateBody } from "../middleware/validate.js";

const router = Router();

const createSwapSchema = z.object({
  shiftId: z.string().uuid(),
  requestedTo: z.string().uuid(),
  message: z.string().min(1)
});

const updateStatusSchema = z.object({
  status: z.enum(["pending", "approved", "rejected", "cancelled"])
});

router.get("/", requireAuth, (_req, res) => {
  res.json({ swapRequests: [] });
});

router.post("/", requireAuth, validateBody(createSwapSchema), (req, res) => {
  res.status(201).json({
    swapRequest: {
      id: randomUUID(),
      requestedBy: req.user?.id,
      status: "pending",
      createdAt: new Date().toISOString(),
      ...req.body
    }
  });
});

router.patch("/:id/status", requireAuth, validateBody(updateStatusSchema), (req, res) => {
  res.json({ id: req.params.id, status: req.body.status });
});

export default router;
