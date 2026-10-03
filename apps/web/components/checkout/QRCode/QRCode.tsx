import { QrCode as QrCodeIcon } from "lucide-react";

export function QRCode() {
  return (
    <div className="flex aspect-square max-w-[320px] items-center justify-center rounded-3xl border border-slate-200 bg-white shadow-sm">
      <QrCodeIcon size={230} strokeWidth={1.1} className="text-slate-950" />
    </div>
  );
}
