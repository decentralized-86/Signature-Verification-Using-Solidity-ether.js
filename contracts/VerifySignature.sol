//SPDX-License-Identifier:MIT
pragma solidity 0.8.9;

/* *ERRORS */
error Invalid_signature();

contract VerifySignature {
    /* Signature Verification

How to Sign and Verify
# Signing
1. Create message to sign
2. Hash the message
3. Sign the hash (off chain, keep your private key secret)

# Verify
1. Recreate hash from the original message
2. Recover signer from signature and hash
3. Compare recovered signer to claimed signer
*/
    function generateMessageHash(
        address _to,
        uint256 nonce,
        uint256 _amount,
        string memory _message
    ) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(_to, _message, _amount, nonce));
    }

    function GenerateMessageHash(
        address _to,
        uint256 nonce,
        uint256 _amount,
        string memory _message
    ) external pure returns (bytes32) {
        return generateMessageHash(_to, nonce, _amount, _message);
    }

    function getEthSignedMessage(bytes32 _hash)
        internal
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
            );
    }

    function GetEthSignedMessage(bytes32 _hash)
        external
        pure
        returns (bytes32)
    {
        return getEthSignedMessage(_hash);
    }

    function verify(
        address _signer,
        address _to,
        uint256 nonce,
        uint256 _amount,
        string memory _message,
        bytes memory _signatures
    ) internal pure returns (bool) {
        bytes32 messageHash = generateMessageHash(
            _to,
            nonce,
            _amount,
            _message
        );
        bytes32 EthSignedMessage = getEthSignedMessage(messageHash);

        return recoverSignerAddress(EthSignedMessage, _signatures) == _signer;
    }

    function Verify(
        address _signer,
        address _to,
        uint256 nonce,
        uint256 _amount,
        string memory _message,
        bytes memory _signatures
    ) external pure returns (bool) {
        return verify(_signer, _to, nonce, _amount, _message, _signatures);
    }

    function recoverSignerAddress(
        bytes32 _ethSignedHash,
        bytes memory _signature
    ) public pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = SplitSignature(_signature);
        return ecrecover(_ethSignedHash, v, r, s);
    }

    function SplitSignature(bytes memory _signatures)
        internal
        pure
        returns (
            bytes32 r,
            bytes32 s,
            uint8 v
        )
    {
        if (_signatures.length != 65) revert Invalid_signature();
        assembly {
            r := mload(add(_signatures, 32))
            s := mload(add(_signatures, 64))
            v := byte(0, mload(add(_signatures, 96)))
        }
    }
}
