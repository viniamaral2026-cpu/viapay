# COBOL / Mainframe Integration

O VIAPAY não acessa o frontend diretamente.

Fluxo:

Bank Core
→ Bank Core API
→ Bank Gateway
→ Adapter COBOL
→ CICS / IBM MQ
→ Core Banking do banco.

Copybooks e layouts reais devem ser fornecidos pelo banco.
