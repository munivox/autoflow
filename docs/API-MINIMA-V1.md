# API mínima V1

A API definitiva deve ser REST/JSON e aplicar autenticação e isolamento por `company_id` no servidor.

## Público
- `GET /api/v1/companies?city=&service=&date=`
- `GET /api/v1/companies/:slug`
- `GET /api/v1/companies/:id/services`
- `GET /api/v1/companies/:id/availability`
- `POST /api/v1/quotes`
- `POST /api/v1/appointments`
- `POST /api/v1/reviews`

## Empresa
- `GET /api/v1/company/me`
- `GET /api/v1/company/dashboard`
- `GET /api/v1/company/orders`
- `PATCH /api/v1/company/orders/:id/status`
- `CRUD /api/v1/company/services`
- `CRUD /api/v1/company/addons`
- `GET /api/v1/company/customers`
- `GET /api/v1/company/vehicles`
- `GET /api/v1/company/marketing`
- `POST /api/v1/company/marketing/campaigns`
- `POST /api/v1/company/marketing/request`

## Admin Munivox
- empresas, planos, assinaturas;
- campanhas e posições patrocinadas;
- leads de marketing particular;
- pagamentos, splits, reembolsos e disputas;
- auditoria.

## Regras
- Nunca confiar em `company_id` enviado pelo navegador para autorização.
- Verificar propriedade do recurso no servidor.
- Validar transições de status.
- Idempotência em pagamentos/webhooks.
- Registrar ações sensíveis em `audit_logs`.
