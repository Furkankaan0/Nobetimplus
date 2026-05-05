import { env } from "./config/env.js";
import { makeApp } from "./app.js";

const app = makeApp();

app.listen(env.PORT, () => {
  console.log(`Nöbetim+ API listening on :${env.PORT}`);
});
