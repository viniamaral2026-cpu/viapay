import { QrCode as QrCodeIcon } from "lucide-react";

export function QRCode() {
  return (
    <div className="flex aspect-square items-center justify-center rounded-2xl bg-white">
      <QrCodeIcon
        size={190}
        strokeWidth={1.3}
        className="text-slate-950"
      />
    </div>
  );
}
