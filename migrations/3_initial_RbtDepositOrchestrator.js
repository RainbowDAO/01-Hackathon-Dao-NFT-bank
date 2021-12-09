const MultiSign = artifacts.require("RbtDepositOrchestrator");
module.exports = function (deployer) {
  deployer.deploy(RbtDepositOrchestrator);
};
