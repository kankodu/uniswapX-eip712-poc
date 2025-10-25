// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Mail {
    // EIP-712 Domain
    string public constant DOMAIN_NAME = "Ether Mail";
    string public constant DOMAIN_VERSION = "1";
    uint256 public constant CHAIN_ID = 1;
    address public constant VERIFYING_CONTRACT = 0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC;

    // EIP-712 Type hashes
    bytes32 private constant DOMAIN_TYPEHASH = 
        keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
    
    
    bytes32 private constant MAIL_TYPEHASH = 
        keccak256("Mail(address from,address to,uint256 value)");

    struct Mail {
        address from;
        address to;
        uint256 value;
    }

    // Domain separator (cached)
    bytes32 public immutable DOMAIN_SEPARATOR;

    constructor() {
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                DOMAIN_TYPEHASH,
                keccak256(bytes(DOMAIN_NAME)),
                keccak256(bytes(DOMAIN_VERSION)),
                CHAIN_ID,
                VERIFYING_CONTRACT
            )
        );
    }

    function hashMail(Mail memory mail) public pure returns (bytes32) {
        return keccak256(abi.encode(
            MAIL_TYPEHASH,
            mail.from,
            mail.to,
            mail.value
        ));
    }

   function hashMailByParts(Mail memory mail) public pure returns (bytes32) {
        bytes32 paramHash1 = keccak256(abi.encode(
            mail.from,
            mail.to
        ));

        bytes32 paramHash2 = keccak256(abi.encode(
            mail.value
        ));
        return keccak256(abi.encode(
            MAIL_TYPEHASH,
            paramHash1,
            paramHash2
        ));
    }

    function getTypedDataHash(bytes32 mailHash) public view returns (bytes32) {
        return keccak256(abi.encodePacked(
            "\x19\x01",
            DOMAIN_SEPARATOR,
            mailHash
        ));
    }

    function verifyMailSignature(
        Mail memory mail, 
        bytes memory signature
    ) public view returns (bool, bool) {
        bytes32 digestWithHashByParts = getTypedDataHash(hashMailByParts(mail));
        bytes32 digest = getTypedDataHash(hashMail(mail));

        return (
            mail.from == recoverSigner(digestWithHashByParts, signature),
            mail.from == recoverSigner(digest, signature)
        );
    }

    function recoverSigner(
        bytes32 digest, 
        bytes memory signature
    ) public pure returns (address) {
        require(signature.length == 65, "Invalid signature length");
        
        bytes32 r;
        bytes32 s;
        uint8 v;
        
        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }
        
        // Handle EIP-155 chain ID encoding
        if (v < 27) {
            v += 27;
        }
        
        return ecrecover(digest, v, r, s);
    }
}