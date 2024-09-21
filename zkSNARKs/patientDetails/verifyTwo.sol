// This file is MIT Licensed.
//
// Copyright 2017 Christian Reitwiessner
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
pragma solidity ^0.8.0;
library Pairing {
    struct G1Point {
        uint X;
        uint Y;
    }
    // Encoding of field elements is: X[0] * z + X[1]
    struct G2Point {
        uint[2] X;
        uint[2] Y;
    }
    /// @return the generator of G1
    function P1() pure internal returns (G1Point memory) {
        return G1Point(1, 2);
    }
    /// @return the generator of G2
    function P2() pure internal returns (G2Point memory) {
        return G2Point(
            [10857046999023057135944570762232829481370756359578518086990519993285655852781,
             11559732032986387107991004021392285783925812861821192530917403151452391805634],
            [8495653923123431417604973247489272438418190587263600148770280649306958101930,
             4082367875863433681332203403145435568316851327593401208105741076214120093531]
        );
    }
    /// @return the negation of p, i.e. p.addition(p.negate()) should be zero.
    function negate(G1Point memory p) pure internal returns (G1Point memory) {
        // The prime q in the base field F_q for G1
        uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
        if (p.X == 0 && p.Y == 0)
            return G1Point(0, 0);
        return G1Point(p.X, q - (p.Y % q));
    }
    /// @return r the sum of two points of G1
    function addition(G1Point memory p1, G1Point memory p2) internal view returns (G1Point memory r) {
        uint[4] memory input;
        input[0] = p1.X;
        input[1] = p1.Y;
        input[2] = p2.X;
        input[3] = p2.Y;
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 6, input, 0xc0, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
    }


    /// @return r the product of a point on G1 and a scalar, i.e.
    /// p == p.scalar_mul(1) and p.addition(p) == p.scalar_mul(2) for all points p.
    function scalar_mul(G1Point memory p, uint s) internal view returns (G1Point memory r) {
        uint[3] memory input;
        input[0] = p.X;
        input[1] = p.Y;
        input[2] = s;
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 7, input, 0x80, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require (success);
    }
    /// @return the result of computing the pairing check
    /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
    /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
    /// return true.
    function pairing(G1Point[] memory p1, G2Point[] memory p2) internal view returns (bool) {
        require(p1.length == p2.length);
        uint elements = p1.length;
        uint inputSize = elements * 6;
        uint[] memory input = new uint[](inputSize);
        for (uint i = 0; i < elements; i++)
        {
            input[i * 6 + 0] = p1[i].X;
            input[i * 6 + 1] = p1[i].Y;
            input[i * 6 + 2] = p2[i].X[1];
            input[i * 6 + 3] = p2[i].X[0];
            input[i * 6 + 4] = p2[i].Y[1];
            input[i * 6 + 5] = p2[i].Y[0];
        }
        uint[1] memory out;
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
        return out[0] != 0;
    }
    /// Convenience method for a pairing check for two pairs.
    function pairingProd2(G1Point memory a1, G2Point memory a2, G1Point memory b1, G2Point memory b2) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](2);
        G2Point[] memory p2 = new G2Point[](2);
        p1[0] = a1;
        p1[1] = b1;
        p2[0] = a2;
        p2[1] = b2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for three pairs.
    function pairingProd3(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](3);
        G2Point[] memory p2 = new G2Point[](3);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for four pairs.
    function pairingProd4(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2,
            G1Point memory d1, G2Point memory d2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](4);
        G2Point[] memory p2 = new G2Point[](4);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p1[3] = d1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        p2[3] = d2;
        return pairing(p1, p2);
    }
}

contract VerifierTwo {
    using Pairing for *;
    struct VerifyingKey {
        Pairing.G1Point alpha;
        Pairing.G2Point beta;
        Pairing.G2Point gamma;
        Pairing.G2Point delta;
        Pairing.G1Point[] gamma_abc;
    }
    struct Proof {
        Pairing.G1Point a;
        Pairing.G2Point b;
        Pairing.G1Point c;
    }
    function verifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.alpha = Pairing.G1Point(uint256(0x19807b98ace8c66b656aa47ee2db98fb58fb57bc171c3ff16dfa59de69189cac), uint256(0x0a5fb724b405eb556127f6a74945fff8a64b1bd414de002ca4d8d2c00af5000e));
        vk.beta = Pairing.G2Point([uint256(0x1d5ddc6589ace5eb5c1fd26ed030f2d444964c0048b08669e5bac66bf9f96b6d), uint256(0x1e2ae16f40900296af041218545590426c63381cccbf9268c1e9c3d5c2d3faa8)], [uint256(0x049678127592b57a63d5c04621400501fca930f7b62a8003aa0ab317f2b99c6b), uint256(0x07c8929b294597a4d8238f5413f84d34ac723523d931f55670c72686226ffbe2)]);
        vk.gamma = Pairing.G2Point([uint256(0x25f1d12a5017a7ef688bb60a97db2a34282cd79f013a3052dd74a7ba7ed2cd76), uint256(0x0df9bf8924361b15c92a64fa93b8826bc10757162aa3edaa7b49425c89a054e0)], [uint256(0x04a623a030016b1879e2b804b29c27180d4185c789a29eee2df0a69ab1495020), uint256(0x1cd9242cb20c1c546e325141e7a76cc64fb595028cd1c346b14e24888ad7961f)]);
        vk.delta = Pairing.G2Point([uint256(0x021cf1b7fe1949a80005a3d7f5494773a227ed17b548f468088e07ef193053b6), uint256(0x13eb93d0e10058081afb30a4f63ce1b2492b5088efa976f76ad1825674a43e58)], [uint256(0x08621aa0fa2c474f92760a340a0530f68f1df21f4393cc1c65cb8db172a53cf8), uint256(0x00e9505b140cdfcd7ba3c95be179bdf9f4bfbeb2f960a0cdd087f8e494ccffcc)]);
        vk.gamma_abc = new Pairing.G1Point[](8);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x17ab9777f5ffaac4d0e5bd28f2bf95e4a7396ef946c94a26e8626650e4eba271), uint256(0x17fce669cf65c3f8b1d309b3626701e672951e4a9355202565d200db18fbe71c));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x2db56ebc11787bd17b2173176df88cbb315a9bbc40d1b77e31281d8e40043f7c), uint256(0x1b5c1fb278af8b0523a2956969172dc9da7b75560973e6e49a35f0ad18f60c0b));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x13fb574d26e41b088ea14e073c38d91fe1f0e45db1fc0ad1c7b8461a547cc534), uint256(0x0dff4ec346d58c7d92a78cc91ba4ae66535e2ba04d2c3686c3425210faccf9be));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x19d475f66c4ad3b4c5799ec83593d2154288590c81f8f950db66bf733385f09c), uint256(0x0a277b8b2bb03c1b5cc222a58f68929e34f7ab0ae1ccf3e707ccaaedc59b8aaf));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x0024b5827a9fb0c978cb913b9700ba943806e80cb21470b40423083455816c03), uint256(0x27d7f368ddf37f91b3237649843b56f74ae2905da271398950403ca1df493dc9));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x1ec91c7c9401e04a7075bac7da46c3af7ec3bd17f65dd7ef0cf989fa3e5d6f74), uint256(0x2ec40e524bdf01549cca12b9eb3130e236687bc33ac887f29c7089535cd57742));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x1399a16ae92584e1a21dd582b7579a47347139390b9ef1c9019bc2c2d55efe78), uint256(0x1ede6f7632cb4ae23ee544b66b36bb4c3874935d9ee324022fdc75bd75c1503a));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x2747593a72b50e053ed95e18d58f9f6ca50966f20edc18f4442f9a9210262479), uint256(0x039a8d32e80958a2b2907d3cd2d018d00953ea25f80edfa6e00571e70cf21f05));
    }
    function verify(uint[] memory input, Proof memory proof) internal view returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = verifyingKey();
        require(input.length + 1 == vk.gamma_abc.length);
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint i = 0; i < input.length; i++) {
            require(input[i] < snark_scalar_field);
            vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.gamma_abc[i + 1], input[i]));
        }
        vk_x = Pairing.addition(vk_x, vk.gamma_abc[0]);
        if(!Pairing.pairingProd4(
             proof.a, proof.b,
             Pairing.negate(vk_x), vk.gamma,
             Pairing.negate(proof.c), vk.delta,
             Pairing.negate(vk.alpha), vk.beta)) return 1;
        return 0;
    }
    function verifyTx(
            Proof memory proof, uint[7] memory input
        ) public view returns (bool r) {
        uint[] memory inputValues = new uint[](7);
        
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            return true;
        } else {
            return false;
        }
    }
}