//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;
import "./Proxy.sol";
import "./Address.sol";

contract BaseUpgradeabilityProxy is Proxy {
    event Upgraded(address indexed implementation);

    /*
@dev Storage slot with the address of the current implementation
This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1
and is validated in the constructor */
    bytes32 internal constant IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /*
@dev returns current implementation
 */
    function _implementation() internal view returns (address impl) {
        bytes32 slot = IMPLEMENTATION_SLOT;
        assembly {
            impl := sload(slot)
        }
    }

    function _upgradeTo(address newImplementation) internal {
        _setImplementation(newImplementation);
        emit Upgraded(newImplementation);
    }

    function _setImplementation(address newImplementation) internal {
        require(
            OpenZeppelinUpgradesAddress.isContract(newImplementation),
            "Cannot set a proxy implementation to a non-contract address"
        );

        bytes32 slot = IMPLEMENTATION_SLOT;

        assembly {
            sstore(slot, newImplementation)
        }
    }
}
