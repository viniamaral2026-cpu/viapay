console.log("ViaPay Worker started");

process.on("SIGTERM", () => {
  console.log("ViaPay Worker stopping...");
  process.exit(0);
});
