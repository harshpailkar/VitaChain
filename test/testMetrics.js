const EHRContract = artifacts.require("EHRContract");

contract("EHRContract Stress Testing", async (accounts) => {
  let contract;

  beforeEach(async () => {
    contract = await EHRContract.new();
  });

  it("measures metrics under stress", async () => {
    // Track start time
    const startTime = Date.now();

    // Measure throughput
    const numTransactions = 100;
    for (let i = 0; i < numTransactions; i++) {
      await contract.addPatient(
        i,
        `Patient_${i}_${Math.random() * 1000}`,
        30 + i,
        i % 2 === 0 ? "Male" : "Female"
      );
    }
    const throughput = numTransactions / ((Date.now() - startTime) / 1000);

    // Measure latency
    const latencyTimes = [];
    for (let i = 0; i < numTransactions; i++) {
      const txStartTime = Date.now();
      await contract.getPatientDetails(i);
      latencyTimes.push(Date.now() - txStartTime);
    }
    const latency =
      latencyTimes.reduce((a, b) => a + b, 0) / latencyTimes.length;

    // Measure gas consumption for a complex transaction
    const complexTx = await contract.addMedicalRecord(
      0,
      Date.now(),
      "Complex Diagnosis " + Math.random() * 1000,
      "Complex Medicine " + Math.random() * 1000
    );
    const gasUsed = complexTx.receipt.gasUsed;

    // Measure transaction time for another complex transaction
    const tx = await contract.addMedicalRecord(
      1,
      Date.now(),
      "Diagnosis " + Math.random() * 1000,
      "Medicine " + Math.random() * 1000
    );
    const txTime = Date.now() - startTime;

    // Measure block creation time and block size
    const latestBlockBefore = await web3.eth.getBlock("latest");
    const blockCreationTime = Date.now() / 1000 - latestBlockBefore.timestamp;

    // Generate a new transaction to get the latest block information after transactions
    await contract.addPatient(
      numTransactions,
      `Patient_${numTransactions}_${Math.random() * 1000}`,
      30 + numTransactions,
      numTransactions % 2 === 0 ? "Male" : "Female"
    );
    const latestBlockAfter = await web3.eth.getBlock("latest");
    const blockSize = latestBlockAfter.size;

    console.log(`
      Throughput: ${throughput} TPS
      Latency: ${latency} ms 
      Gas Used for Complex Transaction: ${gasUsed}
      Transaction Time: ${txTime} ms
      Block Creation Time: ${blockCreationTime} seconds
      Block Size: ${blockSize} bytes
    `);
  });
});