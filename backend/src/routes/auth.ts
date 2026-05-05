import { Router } from "express";
import jwt, { type SignOptions } from "jsonwebtoken";
import { z } from "zod";
import { env } from "../config/env.js";
import { validateBody } from "../middleware/validate.js";

const router = Router();

const appleLoginSchema = z.object({
  appleUserIdentifier: z.string().min(3),
  email: z.string().email().optional(),
  name: z.string().optional()
});

router.post("/apple", validateBody(appleLoginSchema), (req, res) => {
  const signOptions: SignOptions = { expiresIn: env.JWT_EXPIRES_IN as SignOptions["expiresIn"] };
  const token = jwt.sign(
    { id: req.body.appleUserIdentifier, role: "member", teamIds: [] },
    env.JWT_SECRET,
    signOptions
  );
  res.json({ token, user: { id: req.body.appleUserIdentifier, email: req.body.email, name: req.body.name } });
});

export default router;
