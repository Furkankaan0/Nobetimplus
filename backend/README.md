# Nöbetim+ API Scaffold

Local-first iOS MVP backend'e bağımlı değildir. Bu klasör, ileride Node.js/TypeScript API'ye geçiş için sözleşme ve güvenli başlangıç iskeleti sağlar.

## Komutlar

```bash
npm install
npm run dev
npm run build
```

## Modüller

- `/auth`
- `/users`
- `/teams`
- `/shifts`
- `/announcements`
- `/swap-requests`

JWT auth, Zod validation, role-based access control ve PostgreSQL/Supabase uyumlu repository katmanı için temel yapı hazırdır.
