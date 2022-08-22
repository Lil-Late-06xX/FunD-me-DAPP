// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";


     error NotOwner();


contract FundMe{
  
  using PriceConverter for uint256;
  uint256 constant MINIMUM_USD = 10  ;
  address [] funders;
  mapping(address => uint256) public HowMuchSent;
  address public immutable i_owner;



    constructor  (){
     i_owner = msg.sender;
    }
    

    function Fund() public payable {
         require(msg.value.GetConversion() >= MINIMUM_USD, "pay more");
         funders.push(msg.sender);
         HowMuchSent[msg.sender]=msg.value;
    }


    function Withdraw() public RealOwner {
        
        for ( uint256 index = 0 ; index < funders.length ; index++){
            address funder = funders[index];
            HowMuchSent[funder]=0;
        }
        funders = new address[](0);

        //payable(msg.sender).transfer(address(this).balance);
        //bool yen =  payable(msg.sender).send(address(this).balance);
        //require ( yen , " failed");


       ( bool yesORno , )= payable(msg.sender).call{value: address(this).balance}("");
        require ( yesORno , "FAILED");
        

}

   modifier RealOwner {
        //require(msg.sender == i_owner , "denied" );
        if ( msg.sender != i_owner) revert NotOwner();
        _;
   }

   receive() external payable {
        Fund();
   } 

   fallback()external payable {
        Fund();
   }

}

    