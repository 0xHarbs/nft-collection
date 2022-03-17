const { expect } = require('chai');
const { WHITELIST_CONTRACT_ADDRESS, METADATA_URL } = require("../constants");
const whitelistContract = WHITELIST_CONTRACT_ADDRESS;
const metadataURL = METADATA_URL;

describe('NFTDev', function () {
  before(async function () {
    this.Contract = await ethers.getContractFactory('NFTDev');
  });

  beforeEach(async function () {
    this.contract = await this.Contract.deploy(metadataURL, whitelistContract);
    await this.contract.deployed();
  });

  it('retrieve returns a value previously stored', async function () {
    expect((await this.contract.maxTokenIds()).toString()).to.equal('40');
  });
  it("Starts presale", async function () {
    await this.contract.startPresale()
    expect(await this.contract.presaleStarted()).to.equal(true);
  })
});