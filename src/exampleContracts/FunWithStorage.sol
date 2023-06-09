// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract FunWithStorage {
    uint256 s_favNum;
    bool s_someBool;
    uint256[] myArray;

    mapping(uint256 => bool) myMap;

    uint256 constant NOT_IN_STORAGE = 123;
    uint256 immutable i_not_in_storage;

    constructor() {
        s_favNum = 25;
        s_someBool = true;
        myArray.push(222);
        myMap[0] = true;
        i_not_in_storage = 123;
    }

    function doStuff() public {
        uint256 newVar = s_favNum + 1; //SLOAD favNUm -> strorage var
        bool otherVar = s_someBool;
        bool nonStorageVar;
        uint256 anotherVar = newVar / 2;
        s_favNum = anotherVar;
    }
}
