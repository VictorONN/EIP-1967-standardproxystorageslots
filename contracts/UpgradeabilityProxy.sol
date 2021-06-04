//SPDX-License-Identifier: MIT

pragma solidity 0.8.4;
import "./BaseUpgradeabilityProxy.sol";

contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
    constructor(address _logic, bytes memory _data) {
        assert(
            IMPLEMENTATION_SLOT ==
                bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1)
        );
        _setImplementation(_logic);
        if (_data.length > 0) {
            (bool success, ) = _logic.delegatecall(_data);
            require(success);
        }
    }
}
