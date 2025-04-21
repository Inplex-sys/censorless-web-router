// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract Censorless {
    address payable public owner;
    string public endpoint;

    constructor() {
        owner = payable(msg.sender);
    }

    function setEndpoint(string memory _endpoint) public {
        require(msg.sender == owner, "Only the owner can set the endpoint");
        endpoint = _endpoint;
    }

    function getEndpoint() public view returns (string memory) {
        return endpoint;
    }
}
