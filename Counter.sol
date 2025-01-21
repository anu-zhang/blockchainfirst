// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
contract Counter {

    uint256  value;
    function initiallize(uint x)public  { 
       value = x;
        }

        function get() view public returns (uint){
            return address(this).balance;
        }

        function increment (uint n) public {
            value = value +n;
        }
        function decrement(uint n) public{  //decrements and returns the new value
             
                value= value -n;
 
        }
}


