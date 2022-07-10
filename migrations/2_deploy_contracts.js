let LushVault = artifacts.require("LushVault");

module.exports = function(deployer) {
  deployer.deploy(LushVault, 'Lush Vault', 'LVT');
};