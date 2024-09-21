# VitaChain: Blockchain-Based EHR Management with Zero-Knowledge Proofs

VitaChain is a decentralized application (dApp) that leverages blockchain technology, InterPlanetary File System (IPFS), and zero-knowledge proofs (zkSNARKs) to provide a secure and scalable solution for electronic health record (EHR) management. The project aims to enhance data privacy, security, and interoperability within the healthcare industry.

## Features

- **Decentralized EHR Storage**: Leverages blockchain to ensure tamper-proof and auditable storage of medical records.
- **Off-Chain Data Storage**: Integrates IPFS for efficient off-chain storage of large medical files, improving scalability.
- **Zero-Knowledge Proofs**: Implements zkSNARKs to enable privacy-preserving verification of EHR computations without exposing sensitive data.
- **Smart Contract Access Control**: Enables granular access control policies through smart contracts, empowering patients with control over their medical data.
- **Encryption**: Employs encryption mechanisms to protect the confidentiality of EHRs during storage and transmission.

## Technologies Used

- **Blockchain**: Ethereum, Solidity, Truffle
- **Zero-Knowledge Proofs**: ZoKrates
- **Off-Chain Storage**: IPFS
- **Frontend**: JavaScript, React, web3.js, snark.js
- **Backend**: Python, Pandas
- **Testing**: Mocha, Chai

## Installation

1. Clone the repository:

```bash
git clone https://github.com/your-username/VitaChain.git
```

2. Install the required dependencies:

```bash
cd VitaChain
npm install
```

3. Set up the Ethereum development environment (e.g., Ganache, Truffle).

4. Compile and deploy the smart contracts:

```bash
truffle compile
truffle migrate
```

5. Start the development server:

```bash
npm start
```

## Usage

1. Connect your Ethereum wallet (e.g., MetaMask) to the dApp.
2. Register your device and generate encryption keys and a verifier smart contract.
3. Interact with the dApp to manage EHRs, including adding, updating, and accessing records.
4. Use the off-chain storage (IPFS) for larger medical files.
5. Verify the integrity of EHR computations using zkSNARKs without revealing sensitive data.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgments

- Special thanks to the project team members: Anshika Sinha, Aakash Singh, Harsh Pailkar, Himanish Mnndrekar, and myself Aditya Patil.
- We would also like to acknowledge the contributions of the open-source communities behind the technologies used in this project.

## References

- [Research Paper (Final).pdf](Research%20Paper%20(Final).pdf) - The research paper accompanying this project.
