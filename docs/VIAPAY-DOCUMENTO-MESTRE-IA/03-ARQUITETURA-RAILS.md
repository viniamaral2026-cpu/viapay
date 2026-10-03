# VIAPAY — Arquitetura de Rails

```text
Payment Router
├── Banking Rail
├── PSP Rail
├── Pix Rail
├── Card Rail
├── Blockchain Rail
│   └── Solana Adapter
└── Future Rails
```

O router seleciona o rail conforme disponibilidade, regras, custo, risco, jurisdição e configuração institucional.
