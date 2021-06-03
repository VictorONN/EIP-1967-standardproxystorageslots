//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

library OpenZeppelinUpgradesAddress {
    /*
    return whether the target address is a contract
     */
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }

        return size > 0;
    }
}
