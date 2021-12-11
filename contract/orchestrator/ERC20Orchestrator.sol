// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "../token20/RBT.sol";

contract ERC20Orchestrator is Initializable {

    address public rbt;

    function init(address manager ) external initializer {
        rbt = address(new RBT(manager));
    }
}