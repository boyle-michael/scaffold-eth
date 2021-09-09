pragma solidity >=0.6.0 <0.7.0;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract Staker {

  ExampleExternalContract public exampleExternalContract;

  modifier deadlinePassed {
    require(now >= deadline, "DEADLINE HAS NOT PASSED");
    _;
  }

  modifier notCompleted {
    require(exampleExternalContract.completed() == false, "STAKING ALREADY COMPLETED");
    _;
  }

  mapping ( address => uint256 ) public balances;
  uint256 public deadline;
  uint256 public threshold = 5 ether;
  bool public openForWithdraw = false;

  event Stake(address _from, uint256 _amount);
  event Withdraw(address _from, uint256 _amount);

  constructor(address exampleExternalContractAddress) public {
    exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
    deadline = now + 2 days;
  }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  function stake() public payable notCompleted {
    require(now < deadline);
    balances[msg.sender] += msg.value;
    emit Stake(msg.sender, msg.value);
  }


  // After some `deadline` allow anyone to call an `execute()` function
  //  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value
  function execute() public deadlinePassed{
    if (address(this).balance >= threshold) {
      exampleExternalContract.complete{value: address(this).balance}();
    } else {
      openForWithdraw = true;
    }
  }


  // if the `threshold` was not met, allow everyone to call a `withdraw()` function
  function withdraw(address payable _address) public deadlinePassed notCompleted{
    require(openForWithdraw == true, "WITHDRAW NOT ENABLED");
    uint256 amount = balances[_address];
    require(amount > 0, "NO FUNDS TO WITHDRAW");
    balances[_address] = 0;
    msg.sender.transfer(amount);
    emit Withdraw(_address, amount);
  }

  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
  function timeLeft() public view returns(uint256) {
    if (now >= deadline) {
      return 0;
    } else {
      return deadline - now;
    }
  }

}
