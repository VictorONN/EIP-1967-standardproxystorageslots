//SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

contract Proxy {
    fallback() external payable {
        _fallback();
    }

    /*returns the address of the implementation */
    function _implementation() internal view returns (address);

    /*
delegates execution to an implementation contract.
This is a low-level function that doesn't return to its internal call site
It will return to the external caller whatever the implementation returns
@param implementation address to delegate */
    function _delegate(address implementation) internal {
        assembly {
            //copy msg.data. We take full control of memory in this inline assembly
            //block because it will not return to Solidity code. We overwrite the
            //Solidity scratch pad at memory position 0
            calldatacopy(0, 0, calldatasize)

            //call the implementation
            //out and outsize are - because we don't know the size yet
            let result := delegatecall(
                gas,
                implementation,
                0,
                calldatasize,
                0,
                0
            )

            //copy the returned data
            returndatacopy(0, 0, returndatasize)

            switch result
                //delegatecall returns 0 on error
                case 0 {
                    revert(0, returndatasize)
                }
                default {
                    return(0, returndatasize)
                }
        }
    }

    /*
    @dev Function that is run as the first thing in the fallback function
    can be redefined in derived contracts to add functionality
    Redefinitions must call super._willFallback(). */

    function _willfallback() internal {}

    /*
@dev fallback implementation
Extracted to enable manual triggering
 */
    function _fallback() internal {
        _willFallback();
        _delegate(_implementation());
    }
}
