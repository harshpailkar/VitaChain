const EHRContract = artifacts.require("EHRContract");
// const VerifierOne = artifacts.require("VerifierOne");
// const VerifierTwo = artifacts.require("VerifierTwo");
// const VerifierThree = artifacts.require("VerifierThree");

module.exports = function (deployer) {
  deployer.deploy(EHRContract);
  // await deployer.deploy(VerifierOne);
  // await deployer.deploy(VerifierTwo);
  // await deployer.deploy(VerifierThree);
};