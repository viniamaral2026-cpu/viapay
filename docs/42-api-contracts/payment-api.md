
# Payment API Contract

## Create Payment

```http
POST /api/v1/payments
Idempotency-Key: idem_123
```

### Request

```json
{
  "source_account_id": "acc_source",
  "destination_account_id": "acc_destination",
  "amount": {
    "value": 10900,
    "currency": "BRL"
  },
  "description": "Purchase",
  "metadata": {}
}
```

### Response

```json
{
  "data": {
    "id": "pay_123",
    "status": "CREATED"
  },
  "meta": {
    "request_id": "req_123"
  }
}
```

## Get Payment

```http
GET /api/v1/payments/{payment_id}
```

## Approve Payment

```http
POST /api/v1/payments/{payment_id}/approval
```

## Cancel Payment

```http
POST /api/v1/payments/{payment_id}/cancel
```

## Reversal

```http
POST /api/v1/payments/{payment_id}/reverse
```

