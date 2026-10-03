
# Settlement API

## Create Instruction

```http
POST /api/v1/settlements
```

## Status

```http
GET /api/v1/settlements/{settlement_id}
```

## Retry

```http
POST /api/v1/settlements/{settlement_id}/retry
```

Retry deve respeitar idempotência e política operacional.
