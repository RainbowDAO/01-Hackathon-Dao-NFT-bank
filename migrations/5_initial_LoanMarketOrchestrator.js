const MultiSign = artifacts.require("LoanMarketOrchestrator");
module.exports = function (deployer) {
  deployer.deploy(LoanMarketOrchestrator);
};
