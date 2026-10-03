import { db } from "@/prisma/db.js";

async function main(): Promise<void> {
  await db.$transaction(async (tx) => {
    const result = await tx.$queryRaw<
      Array<{ id: string }>
    >`SELECT id FROM settlements LIMIT 1`;

    console.log("TRANSACTION OK");
    console.log(result);
  });

  await db.$disconnect();
}

main().catch(async (error) => {
  console.error(error);
  await db.$disconnect();
  process.exitCode = 1;
});
