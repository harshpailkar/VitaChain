// SPDX-License-Identifier: MIT
const EHRContract = artifacts.require("EHRContract");

contract("EHRContract", (accounts) => {
    let ehrContract;
    const patientId = 1;
    const date1 = 1644912000; // Feb 16, 2022
    const date2 = 1644998400; // Feb 17, 2022

    before(async () => {
        ehrContract = await EHRContract.new();
    });

    it("should add a new patient", async () => {
        await ehrContract.addPatient(patientId, "John Doe", 25, "Male", { from: accounts[0] });
        const patientDetails = await ehrContract.getPatientDetails(patientId);
        assert.equal(patientDetails[0], "John Doe", "Patient name not set correctly");
        assert.equal(patientDetails[1], 25, "Patient age not set correctly");
        assert.equal(patientDetails[2], "Male", "Patient gender not set correctly");
    });

    it("should add medical records for the patient", async () => {
        await ehrContract.addMedicalRecord(patientId, date1, "Fever", "Paracetamol", { from: accounts[0] });
        await ehrContract.addMedicalRecord(patientId, date2, "Cough", "Cough Syrup", { from: accounts[0] });

        const medicalRecords = await ehrContract.getMedicalRecords(patientId);
        assert.equal(medicalRecords.length, 2, "Number of medical records not as expected");

        assert.equal(medicalRecords[0].date, date1, "Medical record date not set correctly");
        assert.equal(medicalRecords[0].diagnosis, "Fever", "Medical record diagnosis not set correctly");
        assert.equal(medicalRecords[0].medicines, "Paracetamol", "Medical record medicines not set correctly");

        assert.equal(medicalRecords[1].date, date2, "Medical record date not set correctly");
        assert.equal(medicalRecords[1].diagnosis, "Cough", "Medical record diagnosis not set correctly");
        assert.equal(medicalRecords[1].medicines, "Cough Syrup", "Medical record medicines not set correctly");
    });

    it("should handle multiple patients and medical records", async () => {
        // Add more patients and medical records for stress testing
        await ehrContract.addPatient(2, "Alice", 30, "Female", { from: accounts[1] });
        await ehrContract.addMedicalRecord(2, date1, "Headache", "Aspirin", { from: accounts[1] });

        // Add more patients and medical records for stress testing
        await ehrContract.addPatient(3, "Bob", 40, "Male", { from: accounts[2] });
        await ehrContract.addMedicalRecord(3, date1, "Back Pain", "Ibuprofen", { from: accounts[2] });

        const patientDetails = await ehrContract.getPatientDetails(3);
        assert.equal(patientDetails[0], "Bob", "Patient name not set correctly");
        assert.equal(patientDetails[1], 40, "Patient age not set correctly");
        assert.equal(patientDetails[2], "Male", "Patient gender not set correctly");

        const medicalRecords = await ehrContract.getMedicalRecords(3);
        assert.equal(medicalRecords.length, 1, "Number of medical records not as expected");
        assert.equal(medicalRecords[0].date, date1, "Medical record date not set correctly");
        assert.equal(medicalRecords[0].diagnosis, "Back Pain", "Medical record diagnosis not set correctly");
        assert.equal(medicalRecords[0].medicines, "Ibuprofen", "Medical record medicines not set correctly");
    });
});