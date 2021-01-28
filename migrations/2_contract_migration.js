const memoryManagement = artifacts.require("memoryManagement");

module.exports = function (deployer) {
  deployer.deploy(memoryManagement);
};
