## `TimeLoanPair`






### `constructor(contract IUniswapV2Pair _pair)` (public)

constructor takes a uniswap pair as an argument to set its 2 borrowable assets



### `liquidityBalance() → uint256` (public)

the current net liquidity positions




### `_mint(address dst, uint256 amount)` (internal)





### `_burn(address dst, uint256 amount)` (internal)





### `withdrawAll() → bool` (external)

withdraw all liquidity from msg.sender shares




### `withdraw(uint256 _shares) → bool` (public)

withdraw `_shares` amount of liquidity for user




### `depositAll() → bool` (external)

deposit all liquidity from msg.sender




### `deposit(uint256 amount) → bool` (public)

deposit `amount` amount of liquidity for user




### `closeInBatches(uint256 size) → uint256` (external)

batch close any pending open loans that have expired




### `closeAllOpen() → uint256` (external)

iterate through all open loans and close




### `close(uint256 id) → bool` (public)

close a specific loan based on id




### `liquidityOf(address asset) → uint256` (public)

returns the available liquidity (including LP tokens) for a given asset




### `calculateLiquidityToBurn(address asset, uint256 amount) → uint256` (public)

calculates the amount of liquidity to burn to get the amount of asset




### `_withdrawLiquidity(address asset, uint256 amount) → uint256 withdrawn` (internal)

withdraw liquidity to get the amount of tokens required to borrow




### `quote(address collateral, address borrow, uint256 amount) → uint256 minOut` (external)

Provides a quote of how much output can be expected given the inputs




### `depositLiquidity()` (external)

deposit available liquidity in the system into the Uniswap Pair, manual for now, require keepers in later iterations



### `loan(address collateral, address borrow, uint256 amount, uint256 outMin) → uint256` (external)

Returns greater than `outMin` amount of `borrow` based on `amount` of `collateral supplied




### `repay(uint256 id) → bool` (external)

Repay a pending loan with `id` anyone can repay, no owner check




### `allowance(address account, address spender) → uint256` (external)

Get the number of tokens `spender` is approved to spend on behalf of `account`




### `approve(address spender, uint256 amount) → bool` (public)

Approve `spender` to transfer up to `amount` from `src`


This will overwrite the approval amount for `spender`
and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)


### `permit(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s)` (external)

Triggers an approval from owner to spends




### `balanceOf(address account) → uint256` (external)

Get the number of tokens held by the `account`




### `transfer(address dst, uint256 amount) → bool` (public)

Transfer `amount` tokens from `msg.sender` to `dst`




### `transferFrom(address src, address dst, uint256 amount) → bool` (external)

Transfer `amount` tokens from `src` to `dst`




### `_transferTokens(address src, address dst, uint256 amount)` (internal)





### `getChainId() → uint256` (internal)






### `Transfer(address from, address to, uint256 amount)`

The standard EIP-20 transfer event



### `Approval(address owner, address spender, uint256 amount)`

The standard EIP-20 approval event



### `Deposited(address creditor, address collateral, uint256 shares, uint256 credit)`

Deposited event for creditor/LP



### `Withdrew(address creditor, address collateral, uint256 shares, uint256 credit)`

Withdawn event for creditor/LP



### `Borrowed(uint256 id, address borrower, address collateral, address borrowed, uint256 creditIn, uint256 amountOut, uint256 created, uint256 expire)`

The borrow event for any borrower



### `Repaid(uint256 id, address borrower, address collateral, address borrowed, uint256 creditIn, uint256 amountOut, uint256 created, uint256 expire)`

The close loan event when processing expired loans



### `Closed(uint256 id, address borrower, address collateral, address borrowed, uint256 creditIn, uint256 amountOut, uint256 created, uint256 expire)`

The close loan event when processing expired loans



