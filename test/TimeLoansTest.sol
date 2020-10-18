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
    function liquidityRemoved() external returns (uint);
    function liquidityWithdrawals() external returns (uint);
    function balanceOf(address) external returns (uint);
    function quote(address, address, uint) external view returns (uint);
    function loan(address, address, uint, uint) external returns (uint);
    function calculateLiquidityToBurn(address, uint) external view returns (uint);
    function liquidityOf(address) external returns (uint);
    function close(uint) external returns (bool);
    function positions(uint) external view returns (address, address, address, uint, uint, uint, uint, uint, bool);
}

interface TimeLoansFactoryLike {
    function deploy(address) external returns (address);
}

contract TimeLoansTest is script {
    using SafeMath for uint;

    TimeLoansFactoryLike constant private TLF = TimeLoansFactoryLike(0x41c9D327D09ed0D2F1E1dE4362848A1a57Aa81E7);
    TimeLoansLike private TL;
    ERC20Like constant private PAIR = ERC20Like(0xBb2b8038a1640196FbE3e38816F3e67Cba72D940);

    ERC20Like constant private WBTC = ERC20Like(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
    ERC20Like constant private WETH = ERC20Like(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    function deploy() external {
        TL = TimeLoansLike(TLF.deploy(address(PAIR)));
    }

	function run() public {
	    run(this.deploy).withCaller(0x2D407dDb06311396fE14D4b49da5F0471447d45C);
	    run(this.deposit).withCaller(0xa6BFEDc4BF9bdb3F09A448518206023E8C009DDf);
	    run(this.stats).withCaller(0xa6BFEDc4BF9bdb3F09A448518206023E8C009DDf);
	    run(this.quote).withCaller(0x3f5CE5FBFe3E9af3971dD833D26bA9b5C936f0bE);
	    run(this.stats).withCaller(0xa6BFEDc4BF9bdb3F09A448518206023E8C009DDf);
	    advanceBlocks(6601);
	    run(this.close).withCaller(0xa6BFEDc4BF9bdb3F09A448518206023E8C009DDf);
	    run(this.withdraw).withCaller(0xa6BFEDc4BF9bdb3F09A448518206023E8C009DDf);
	    run(this.stats).withCaller(0xa6BFEDc4BF9bdb3F09A448518206023E8C009DDf);
	}

	function close() external {
	    (address owner,
	    address collateral,
	    address borrowed,
	    uint creditIn,
	    uint amountOut,
	    uint liquidityInUse,
	    uint created,
	    uint expire,
	    bool open) = TL.positions(0);
	    bool success = TL.close(0);
	    fmt.printf("owner=%a\n",abi.encode(owner));
	    fmt.printf("collateral=%a\n",abi.encode(collateral));
	    fmt.printf("borrowed=%a\n",abi.encode(borrowed));
	    fmt.printf("creditIn=%.8u\n",abi.encode(creditIn));
	    fmt.printf("amountOut=%.18u\n",abi.encode(amountOut));
	    fmt.printf("liquidityInUse=%.18u\n",abi.encode(liquidityInUse));
	    fmt.printf("created=%.18u\n",abi.encode(created));
	    fmt.printf("expire=%.18u\n",abi.encode(expire));
	    fmt.printf("open=%b\n",abi.encode(open));
	    fmt.printf("closed=%b\n",abi.encode(success));
	}

	function quote() external {
	    uint _borrow = TL.quote(address(WBTC), address(WETH), 1e8);
	    fmt.printf("quote=%.18u\n",abi.encode(_borrow));
	    WBTC.approve(address(TL), uint(-1));
	    uint _burn = TL.calculateLiquidityToBurn(address(WETH), _borrow);
	    fmt.printf("calculateLiquidityToBurn=%.18u\n",abi.encode(_burn));
	    TL.loan(address(WBTC), address(WETH), 1e8, 0);
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
        fmt.printf("liquidityRemoved=%.18u\n",abi.encode(TL.liquidityRemoved()));
        fmt.printf("liquidityWithdrawals=%.18u\n",abi.encode(TL.liquidityWithdrawals()));
        fmt.printf("liquidityOf(ETH)=%.18u\n",abi.encode(TL.liquidityOf(address(WETH))));

    }

    function withdraw() external {
        fmt.printf("balanceOf=%.18u\n",abi.encode(PAIR.balanceOf(address(this))));
        TL.withdraw(1.5e15);
        fmt.printf("balanceOf=%.18u\n",abi.encode(PAIR.balanceOf(address(this))));
    }
}
