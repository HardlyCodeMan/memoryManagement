// SPDX-License-Identifier: GPL3
pragma solidity 0.5.12;
//pragma experimental ABIEncoderV2;

contract memoryManagement {
    struct Flip {
        uint id;
        address player;
        uint queryId;
        uint expected;
        uint result;
        uint value;
        bool win;
    }
    
    
    mapping (address => uint[]) private userFlips;
    mapping (uint => Flip) private gameMap;
    
    event newFlipEvent(uint _id, address _player, uint _queryId, uint _expected, uint _result, uint _value, bool _win);
    
    function random() private view returns (uint) {
        // blocktimestamp (now()) modulus by 2 returing the remainder (0 or 1)
        // NOT RANDOM, only appears to be random
        return now %2; 
    }
    
    function newFlip() public {
        uint _id = now;
        bool _winBool;
        uint _winBoolRNG = (random() + random()) % 2;
        uint _queryId = random();
        uint _expected = random();
        uint _result = random();
        uint _value = 100000;
        
        // Logic check for game id to prevent users from trying to create flips with the same id
        if(gameMap[_id].id != 0) {
            // Game exists, add more data to prevent double
            // Needs a better fix
            _id += _winBoolRNG;
        }
        
        
        if(_winBoolRNG == _result) {
            _winBool = true;
        } else {
            _winBool = false;
        }
        
        gameMap[_id].id = _id;
        gameMap[_id].player = msg.sender;
        gameMap[_id].queryId = _queryId;
        gameMap[_id].expected = _expected;
        gameMap[_id].result = _result;
        gameMap[_id].value = _value;
        gameMap[_id].win = _winBool;
        
        userFlips[msg.sender].push(_id);
        
        emit newFlipEvent(_id, msg.sender, _queryId, _expected, _result, _value, _winBool);
    }
    
    function getResult(uint _id) public view returns(uint, address, uint, uint, uint, uint, bool) {
        require(gameMap[_id].id != 0, "No flips found for that users.");
        
        return(gameMap[_id].id, gameMap[_id].player, gameMap[_id].queryId, gameMap[_id].expected, gameMap[_id].result, gameMap[_id].value, gameMap[_id].win);
    }
    
    function getUserFlips() public view returns(uint[] memory, uint) {
        uint[] memory tempArray = userFlips[msg.sender];
        uint gameCount = tempArray.length;
        
        return (userFlips[msg.sender], gameCount);
    }
}