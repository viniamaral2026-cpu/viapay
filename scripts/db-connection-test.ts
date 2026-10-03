import "dotenv/config";
import { db } from "../src/prisma/db.js";

async function main() {
  console.log("==============================================");
  console.log("VIAPAY — DATABASE CONNECTION TEST");
  console.log("==============================================");

  const result = await db.$queryRaw<
    Array<{
      database: string;
      user: string;
      version: string;
    }>
  >`
    SELECT
      current_database() AS database,
      current_user AS user,
      version() AS version
  `;

  console.log();
  console.log("Database:", result[0]?.database);
  console.log("User:", result[0]?.user);
  console.log("Version:", result[0]?.version);

  console.log();
  console.log("✓ DATABASE CONNECTION OK");
}

main()
  .catch((error) => {
    console.error();
    console.error("✗ DATABASE CONNECTION FAILED");
    console.error(error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await db.$disconnect();
  });
