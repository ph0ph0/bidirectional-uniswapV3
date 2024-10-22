// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.14;

interface IUniswapV3Pool {
    function slot0() external view returns (uint160 sqrtPriceX96, int24 tick);

    struct CallbackData {
        address token0;
        address token1;
        address payer;
    }

    function mint(address owner, int24 lowerTick, int24 upperTick, uint128 amount, bytes calldata data)
        external
        returns (uint256 amount0, uint256 amount1);

    function swap(address recipient, bool zeroForOne, uint256 amountSpecified, bytes calldata data)
        external
        returns (int256 amount0, int256 amount1);
}
