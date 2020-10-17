pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./script.sol";

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface TimeLoansLike {
    function deposit(uint) external returns (bool);
    function depositAll() external returns (bool);
    function withdraw(uint) external returns (bool);
    function withdrawAll() external returns (bool);
    function liquidityAdded() external returns (uint);
    function liquidityBalance() external returns (uint);
    function liquidityDeposits() external returns (uint);
    function liquidityFreed() external returns (uint);
    function liquidityInUse() external returns (uint);
    function balanceOf(address) external returns (uint);
}

contract TimeLoansTest is script {
    using SafeMath for uint;

    TimeLoansLike constant private TL = TimeLoansLike(0x2fCd3EBDc9076B5D194a0417e12528d54804f7eE);
    ERC20Like constant private PAIR = ERC20Like(0xBb2b8038a1640196FbE3e38816F3e67Cba72D940);

	function run() public {
	    run(this.deposit).withCaller(0xa6BFEDc4BF9bdb3F09A448518206023E8C009DDf);
	    run(this.stats).withCaller(0xa6BFEDc4BF9bdb3F09A448518206023E8C009DDf);
	    run(this.withdraw).withCaller(0xa6BFEDc4BF9bdb3F09A448518206023E8C009DDf);
	    run(this.stats).withCaller(0xa6BFEDc4BF9bdb3F09A448518206023E8C009DDf);
	}

    function deposit() external {
        fmt.printf("balanceOf=%.18u\n",abi.encode(PAIR.balanceOf(address(this))));
        PAIR.approve(address(TL), uint(-1));
        TL.depositAll();
        fmt.printf("balanceOf=%.18u\n",abi.encode(PAIR.balanceOf(address(this))));
        fmt.printf("TL.balanceOf=%.18u\n",abi.encode(TL.balanceOf(address(this))));
    }

    function stats() external {
        fmt.printf("liquidityAdded=%.18u\n",abi.encode(TL.liquidityAdded()));
        fmt.printf("liquidityBalance=%.18u\n",abi.encode(TL.liquidityBalance()));
        fmt.printf("liquidityAdded=%.18u\n",abi.encode(TL.liquidityAdded()));
        fmt.printf("liquidityDeposits=%.18u\n",abi.encode(TL.liquidityDeposits()));
        fmt.printf("liquidityFreed=%.18u\n",abi.encode(TL.liquidityFreed()));
        fmt.printf("liquidityInUse=%.18u\n",abi.encode(TL.liquidityInUse()));
    }

    function withdraw() external {
        fmt.printf("balanceOf=%.18u\n",abi.encode(PAIR.balanceOf(address(this))));
        TL.withdraw(1e15);
        fmt.printf("balanceOf=%.18u\n",abi.encode(PAIR.balanceOf(address(this))));
    }
}
