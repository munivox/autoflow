# Máquina de estados do serviço

Fluxo principal:

`SCHEDULED -> ARRIVED -> INSPECTION -> IN_SERVICE -> FINISHING -> ALMOST_READY -> READY -> COMPLETED`

Saídas permitidas:
- SCHEDULED -> CANCELLED
- ARRIVED/INSPECTION/IN_SERVICE/FINISHING -> CANCELLED somente conforme regra operacional
- COMPLETED -> DISPUTED quando houver contestação válida
- DISPUTED -> COMPLETED ou REFUNDED conforme resolução

O sistema registra cada mudança em `order_status_history` e `appointment_status_history`.
