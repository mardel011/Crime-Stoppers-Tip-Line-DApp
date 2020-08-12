pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

contract TipLine {    
    mapping (address => uint) public balanceOf;  
    uint256 totalSupply_;
    
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value
        );
        
    event tipEmitted(
        string tipTitle,
        address indexed from,
        uint ID
        );
        
    struct Tip {
        string tipTitle;
        address tipper;
        uint ID;
        bool paid;
    }
        
    mapping(uint => Tip) tips;
    uint[] numberOfTips;
    
    constructor(uint256 total) public {
    totalSupply_ = total;
    balanceOf[msg.sender] = totalSupply_;
    }
    
    function balances(address tokenOwner) public view returns (uint) {
        return balanceOf[tokenOwner];
    }
    
    function transfer(address _to, uint _value) internal returns (bool) {
        require(_value <= balanceOf[msg.sender]);
        require(balanceOf[_to] <= balanceOf[_to] + _value);
        balanceOf[msg.sender] = balanceOf[msg.sender] - (_value);
        balanceOf[_to] = balanceOf[_to] + (_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function addTip(string memory _tipTitle) public {
        uint _ID = numberOfTips.length +1;
        tips[_ID] = Tip(
            {
                tipTitle: _tipTitle,
                tipper: msg.sender,
                ID: _ID,
                paid: false
            });
        emit tipEmitted(_tipTitle, msg.sender, _ID);
    }
    
    function returnTip(uint _ID) public view returns(Tip memory) {
        require (tips[_ID].tipper == msg.sender);
        return tips[_ID];
    }
    
    function rewardTip(uint _ID, uint rewardAmount) public {
        transfer(tips[_ID].tipper, rewardAmount);
        tips[_ID].paid = true;
    }
}