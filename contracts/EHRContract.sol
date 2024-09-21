// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract EHRContract {
    // Patient struct to store images
    struct MedicalImage {
        uint256 date;
        bytes image; // Store the image data as bytes
        string description;
    }

    // Patient struct to store patient details
    struct Patient {
        string name;
        uint256 age;
        string gender;
    }

    // MedicalRecord struct to store health records
    struct MedicalRecord {
        uint256 date;
        string diagnosis;
        string medicines;
    }

    // Mapping to store medical images for each patient
    mapping(uint256 => mapping(uint256 => MedicalImage)) public medicalImages;

    // Mapping to store patient details based on patient ID
    mapping(uint256 => Patient) public patients;

    // Mapping to store the number of medical records for each patient
    mapping(uint256 => uint256) public recordCount;

    // Mapping to store medical records for each patient
    mapping(uint256 => mapping(uint256 => MedicalRecord)) public medicalRecords;


    // Function to add a new medical image linked to a patient
    function addMedicalImage(uint256 _patientId, uint256 _recordIndex, uint256 _date, bytes memory _image, string memory _description) public {
        MedicalImage memory newImage = MedicalImage(_date, _image, _description);
        medicalImages[_patientId][_recordIndex] = newImage;
    }

    // Function to retrieve all medical images of a patient's record
    function getMedicalImages(uint256 _patientId, uint256 _recordIndex) public view returns (MedicalImage memory) {
        return medicalImages[_patientId][_recordIndex];
    }

    // Function to add a new patient
    function addPatient(uint256 _patientId, string memory _name, uint256 _age, string memory _gender) public {
        Patient memory newPatient = Patient(_name, _age, _gender);
        patients[_patientId] = newPatient;
    }

    // Function to add a new medical record linked to a patient
    function addMedicalRecord(uint256 _patientId, uint256 _date, string memory _diagnosis, string memory _medicines) public {
        MedicalRecord memory newRecord = MedicalRecord(_date, _diagnosis, _medicines);
        medicalRecords[_patientId][recordCount[_patientId]] = newRecord;
        recordCount[_patientId]++;
    }

    // Function to retrieve patient details
    function getPatientDetails(uint256 _patientId) public view returns (string memory, uint256, string memory) {
        return (patients[_patientId].name, patients[_patientId].age, patients[_patientId].gender);
    }

    // Function to retrieve all medical records of a patient
    function getMedicalRecords(uint256 _patientId) public view returns (MedicalRecord[] memory) {
        MedicalRecord[] memory records = new MedicalRecord[](recordCount[_patientId]);
        for (uint256 i = 0; i < recordCount[_patientId]; i++) {
            records[i] = medicalRecords[_patientId][i];
        }
        return records;
    }
}