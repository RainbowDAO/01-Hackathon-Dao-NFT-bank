
// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

    library Set {
        struct TokenIdSet {
            bytes32[] _values;
            mapping (bytes32 => uint256) _indexes;
    }
   
    //Add an element
    function add(TokenIdSet storage set, uint256 value) internal returns (bool) {
        if (!contains(set, value)) {
            set._values.push(bytes32(value));
            set._indexes[bytes32(value)] = set._values.length;
            return true;
        }
        return false;
    }
    
     //Delete the element
    function remove(TokenIdSet storage set, uint256 value) internal returns (bool) {
        uint256 valueIndex = set._indexes[bytes32(value)];
        if (valueIndex != 0) {
            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;
            bytes32 lastvalue = set._values[lastIndex];
            set._values[toDeleteIndex] = lastvalue;
            set._indexes[lastvalue] = toDeleteIndex + 1;
            set._values.pop();
            delete set._indexes[bytes32(value)];
            return true;
        }
         return false;
    }
    
    //The query contains elements
    function contains(TokenIdSet storage set, uint256 value) internal view returns (bool) {
        return set._indexes[bytes32(value)] != 0;
    }
    
    //The length of the query
    function length(TokenIdSet storage set) internal view returns (uint256) {
        return set._values.length;
    }
    
    //The location of the query element
    function at(TokenIdSet storage set, uint256 index) internal view returns (uint256) {
        require(set._values.length > index,"EnumerableSet: index out of bounds");
        return uint256(set._values[index]);
    }
    
   }