// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import "@oasislabs/sapphire-contracts/contracts/Sapphire.sol";

contract Lock {
    uint public unlockTime;
    address payable public owner;

    bytes32 internal privateKey;
    bytes32 internal publicKey;


    function getPrivateKey() external view returns (bytes32) {
        return privateKey;
    }

    function getPublicKey() external view returns (bytes32) {
        return publicKey;
    }


    event Withdrawal(uint amount, uint when);

    event LogKey(bytes32 key);
    event LogData(bytes data);
    

    constructor(uint _unlockTime) payable {
        require(
            block.timestamp < _unlockTime,
            "Unlock time should be in the future"
        );

        
        bytes memory randomBytes = Sapphire.randomBytes(32, "");
        (bytes memory rawPublicKey, bytes memory rawPrivateKey) = Sapphire.generateKeyPair(Sapphire.SigningAlg.Ed25519Oasis, randomBytes);
        publicKey = bytes32(rawPublicKey);
        privateKey = bytes32(rawPrivateKey);
        emit LogKey(publicKey);
        emit LogKey(privateKey);
        unlockTime = _unlockTime;
        owner = payable(msg.sender);
    }
    
    function decrpyt(bytes calldata cryptedText, bytes32 peerPublicKey, bytes32 nonce) public {
        bytes32 symmetricKey = Sapphire.deriveSymmetricKey(peerPublicKey, privateKey);
        emit LogKey(peerPublicKey);
        emit LogKey(nonce);                
        emit LogKey(symmetricKey);
        emit LogData(cryptedText);
        //        bytes memory decryptedData = Sapphire.decrypt(symmetricKey, nonce, cryptedText, "");
        // emit LogData(decryptedData);
    }

    function withdraw() public {
        // Uncomment this line, and the import of "hardhat/console.sol", to print a log in your terminal
        // console.log("Unlock time is %o and block timestamp is %o", unlockTime, block.timestamp);

        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");

        emit Withdrawal(address(this).balance, block.timestamp);

        owner.transfer(address(this).balance);
    }
}