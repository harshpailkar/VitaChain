const VerifierTwo = artifacts.require("VerifierTwo");
const VerifierThree = artifacts.require("VerifierThree");

module.exports = async function (deployer) {
  await deployer.deploy(VerifierTwo);
  await deployer.deploy(VerifierThree);
};