import "./lib/Math.sol";

pragma solidity ^0.8.14;

library SwapMath {
    function computeSwapStep(
        uint160 sqrtPriceCurrentX96,
        uint160 sqrtPriceTargetX96,
        uint128 liquidity,
        uint256 amountRemaining
    ) internal pure returns (uint160 sqrtPriceNextX96, uint256 amountIn, uint256 amountOut) {
        // Determine which direction the swap is in by the relative prices
        bool zeroForOne = sqrtPriceCurrentX96 >= sqrtPriceTargetX96;

        sqrtPriceNextX96 = Math.getNextSqrtPriceFromInput(sqrtPriceCurrentX96, liquidity, amountRemaining, zeroForOne);

        amountIn = Math.calcAmount0Delta(sqrtPriceCurrentX96, sqrtPriceNextX96, liquidity);

        amountOut = Math.calcAmount1Delta(sqrtPriceCurrentX96, sqrtPriceNextX96, liquidity);

        if (zeroForOne) {
            (amountIn, amountOut) = (amountOut, amountIn);
        }
    }
}
