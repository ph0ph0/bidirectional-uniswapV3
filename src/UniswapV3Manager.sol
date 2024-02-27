// test/UniswapV3Pool.t.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "./IUniswapV3Pool.sol";
import "../lib/forge-std/src/interfaces/IERC20.sol";


contract UniswapV3Manager {

    address private poolAddress;
    address private sender;

    modifier withPool(address _poolAddress) {
        poolAddress = _poolAddress;
        _;
        poolAddress = address(0);

    }

    modifier withSender() {
        sender = msg.sender;
        _;
        sender = address(0);
    }

    function mint(
        address poolAddress_,
        int24 lowerTick, 
        int24 upperTick, 
        uint128 liquidity, 
        bytes calldata data
    ) withPool(poolAddress_) withSender public {

        IUniswapV3Pool(poolAddress_).mint(
            msg.sender, 
            lowerTick, 
            upperTick, 
            liquidity, 
            data
        );
    }

    function swap(address poolAddress_, bytes calldata data) withPool(poolAddress_) withSender public {
        IUniswapV3Pool(poolAddress_).swap(msg.sender, data);
    }

    function uniswapV3MintCallback(
        uint256 amount0, 
        uint256 amount1, 
        bytes calldata data
    ) external {
        // Unpack the bytes data
        IUniswapV3Pool.CallbackData memory unpacked = abi.decode(
            data, 
            (IUniswapV3Pool.CallbackData)
        );

        IERC20(unpacked.token0).transferFrom(unpacked.payer, msg.sender, uint256(amount0));
        IERC20(unpacked.token1).transferFrom(unpacked.payer, msg.sender, uint256(amount1));
    }

    function uniswapV3SwapCallback(
        int amount0, 
        int amount1, 
        bytes calldata data
    ) external {
        // Unpack the bytes data
        IUniswapV3Pool.CallbackData memory unpacked = abi.decode(
            data, 
            (IUniswapV3Pool.CallbackData)
        );

        if (amount0 > 0) {
            IERC20(unpacked.token0).transferFrom(unpacked.payer, msg.sender, uint256(amount0));
        }

        if (amount1 > 0) {
            IERC20(unpacked.token1).transferFrom(unpacked.payer, msg.sender, uint256(amount1));
        }
    }
}