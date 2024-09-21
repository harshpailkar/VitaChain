const fs = require("fs");
const EHRContract = artifacts.require("EHRContract");

contract("EHRContract Stress Testing", async (accounts) => {
  let contract;

  beforeEach(async () => {
    contract = await EHRContract.new();
  });

  it("measures metrics under stress with incremental load testing", async () => {
    // Track start time
    const startTime = Date.now();

    // Incremental Load Testing
    const incrementalLoadTransactions = [50, 100, 150, 200, 250]    ;
    const incrementalLoadMetrics = [];

    for (const numTransactions of incrementalLoadTransactions) {
      // Measure throughput
      for (let i = 0; i < numTransactions; i++) {
        await contract.addPatient(
          i,
          `Patient_${i}_${Math.random() * 1000}`,
          30 + i,
          i % 2 === 0 ? "Male" : "Female"
        );

        // Simulate adding an image to a patient's record
        // Read the image file as a buffer
        const imageBuffer = fs.readFileSync("1kb.png"); // Replace with the actual path to your image file

        // Convert the buffer to a hexadecimal string
        const hexCode = imageBuffer.toString("hex");
        const imageBytes = Buffer.from(hexCode, "hex"); // Replace "..." with your image data in hexadecimal format
        await contract.addMedicalImage(
          i,
          0,
          Date.now(),
          imageBytes,
          "Image Description"
        );

        // Simulate retrieving an image from a patient's record
        const retrievedImage = await contract.getMedicalImages(i, 0);
      }
      const incrementalThroughput =
        numTransactions / ((Date.now() - startTime) / 1000);

      // Measure latency
      const latencyTimes = [];
      for (let i = 0; i < numTransactions; i++) {
        const txStartTime = Date.now();
        await contract.getPatientDetails(i);
        latencyTimes.push(Date.now() - txStartTime);
      }
      const incrementalLatency =
        latencyTimes.reduce((a, b) => a + b, 0) / latencyTimes.length;

      // Measure gas consumption for a complex transaction
      const complexTx = await contract.addMedicalRecord(
        0,
        Date.now(),
        "Complex Diagnosis " + Math.random() * 1000,
        "Complex Medicine " + Math.random() * 1000
      );
      const incrementalGasUsed = complexTx.receipt.gasUsed;

      // Store metrics for this increment
      incrementalLoadMetrics.push({
        numTransactions,
        incrementalThroughput,
        incrementalLatency,
        incrementalGasUsed,
      });
    }

    // Log metrics to a CSV file
    fs.writeFileSync(
      "incremental_load_metrics.csv",
      "NumTransactions,IncrementalThroughput,IncrementalLatency,IncrementalGasUsed\n" +
        incrementalLoadMetrics
          .map(
            ({
              numTransactions,
              incrementalThroughput,
              incrementalLatency,
              incrementalGasUsed,
            }) =>
              `${numTransactions},${incrementalThroughput},${incrementalLatency},${incrementalGasUsed}`
          )
          .join("\n")
    );

    // Display metrics
    console.log("Incremental Load Testing Metrics:");
    console.table(incrementalLoadMetrics);
  });

  it("measures metrics under stress with multiple concurrent users", async () => {
    // Track start time
    const startTime = Date.now();

    // Multiple Concurrent Users Testing
    const concurrentUsersTransactions = 100;
    const concurrentUsersUserCounts = [5, 10, 15, 20, 25]; // <-- Insert here
    const concurrentUsersMetrics = [];

    for (const userCount of concurrentUsersUserCounts) {
      // Measure throughput
      for (let i = 0; i < concurrentUsersTransactions; i++) {
        await contract.addPatient(
          i,
          `Patient_${i}_${Math.random() * 1000}`,
          30 + i,
          i % 2 === 0 ? "Male" : "Female"
        );

        const imageBuffer = fs.readFileSync("1kb.png"); // Replace with the actual path to your image file

        // Convert the buffer to a hexadecimal string
        const hexCode = imageBuffer.toString("hex");

        // Simulate adding an image to a patient's record
        const imageBytes = Buffer.from(hexCode, "hex"); // Replace "..." with your image data in hexadecimal format
        await contract.addMedicalImage(
          i,
          0,
          Date.now(),
          imageBytes,
          "Image Description"
        );

        // Simulate retrieving an image from a patient's record
        const retrievedImage = await contract.getMedicalImages(i, 0);
      }
      const concurrentUsersThroughput =
        concurrentUsersTransactions / ((Date.now() - startTime) / 1000);

      // Measure latency
      const concurrentUsersLatencyTimes = [];
      for (let i = 0; i < concurrentUsersTransactions; i++) {
        const txStartTime = Date.now();
        await contract.getPatientDetails(i);
        concurrentUsersLatencyTimes.push(Date.now() - txStartTime);
      }
      const concurrentUsersLatency =
        concurrentUsersLatencyTimes.reduce((a, b) => a + b, 0) /
        concurrentUsersLatencyTimes.length;

      // Measure gas consumption for a complex transaction
      const complexTx = await contract.addMedicalRecord(
        0,
        Date.now(),
        "Complex Diagnosis " + Math.random() * 1000,
        "Complex Medicine " + Math.random() * 1000
      );
      const concurrentUsersGasUsed = complexTx.receipt.gasUsed;

      // Store metrics for this user count
      concurrentUsersMetrics.push({
        userCount,
        concurrentUsersThroughput,
        concurrentUsersLatency,
        concurrentUsersGasUsed,
      });
    }

    // Log metrics to a CSV file
    fs.writeFileSync(
      "concurrent_users_metrics.csv",
      "UserCount,ConcurrentUsersThroughput,ConcurrentUsersLatency,ConcurrentUsersGasUsed\n" +
        concurrentUsersMetrics
          .map(
            ({
              userCount,
              concurrentUsersThroughput,
              concurrentUsersLatency,
              concurrentUsersGasUsed,
            }) =>
              `${userCount},${concurrentUsersThroughput},${concurrentUsersLatency},${concurrentUsersGasUsed}`
          )
          .join("\n")
    );

    // Display metrics
    console.log("Multiple Concurrent Users Testing Metrics:");
    console.table(concurrentUsersMetrics);
  });
});
