package v1

import (
	sdkmath "cosmossdk.io/math"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/module"
	upgradetypes "github.com/cosmos/cosmos-sdk/x/upgrade/types"
)

// CreateUpgradeHandler creates an SDK upgrade handler for v16.0.0
func CreateUpgradeHandler(
	// mm *module.Manager,
	// configurator module.Configurator,
	// ek *evmkeeper.Keeper,
	// bk bankkeeper.Keeper,
	// inflationKeeper inflationkeeper.Keeper,
	// ak authkeeper.AccountKeeper,
	// gk govkeeper.Keeper,
) upgradetypes.UpgradeHandler {
	return func(ctx sdk.Context, _ upgradetypes.Plan, fromVM module.VersionMap) (module.VersionMap, error) {
		m, err := app.mm.RunMigrations(ctx, app.configurator, fromVM)
		if err != nil {
			return m, err
		}

		// Override feemarket parameters
		params := app.FeeMarketKeeper.GetParams(ctx)
		params.BaseFeeChangeDenominator = 300
		params.ElasticityMultiplier = 4
		params.BaseFee = sdk.NewInt(10000000000000)
		params.MinGasPrice = sdk.NewDec(10000000000000)
		app.FeeMarketKeeper.SetParams(ctx, params)

		// clear extra_eips from evm parameters
		// Ref: https://github.com/crypto-org-chain/cronos/issues/755
		evmParams := app.EvmKeeper.GetParams(ctx)
		evmParams.ExtraEIPs = []int64{}

		// fix the incorrect value on testnet parameters
		zero := sdkmath.ZeroInt()
		evmParams.ChainConfig.LondonBlock = &zero

		app.EvmKeeper.SetParams(ctx, evmParams)
		return m, nil
	}
}