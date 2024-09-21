// SPDX-License-Identifier: MIT
const VerifierThree = artifacts.require("VerifierThree");

contract("VerifierThree", (accounts) => {
  let verifierThree;

  before(async () => {
    verifierThree = await VerifierThree.new();
  });

  it("Proof 02 Passed: Record Integrity Proof Verified", async () => {
    const result = await verifierThree.verifyTx([
      
        [
          "0x142ad86a245faa51cdb9cc691fb803dc0e7e6e53dd4b4332322c65ab55fa24d4",
          "0x0e6e91ea7c6a03590fc2a433f1b6b5fd1b85546b755ccdf6d7e016b83502542f",
        ],
        [
          [
            "0x2ad4e4bde339e224c101fbf596a268fc648992e85ed42e98dc74636da2723347",
            "0x225e6d597494c252add570577caad906e4829cc04141da600cfd9e220765ef50",
          ],
          [
            "0x0766ace9a209e076323bd35c09713de01f4865ce744648118c7f806343f59761",
            "0x07f39c431a2bf7141751f70b227f60167642abf98cbc2f72f55c7522834dad3f",
          ],
        ],
        [
          "0x00a3ece929764cd45a5db3ae21c708ea56f40d099fe545e66c1ff1c42b13642c",
          "0x2a66fc43d2aa77779671b035a815417af5206b77d0843d94bb5211d111c18978",
        ],
    ],
      [
        "0x000000000000000000000000000000000000000000000000000000000000000c",
        "0x000000000000000000000000000000000000000000000000000000000000000c",
        "0x0000000000000000000000000000000000000000000000000000000000000022",
        "0x0000000000000000000000000000000000000000000000000000000000000022",
        "0x0000000000000000000000000000000000000000000000000000000000000001",
      ]
    );
    assert.equal(result, true, "The result should be as expected");
  });
});
