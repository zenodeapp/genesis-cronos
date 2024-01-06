package app

import (
	"fmt"

	sdkmath "cosmossdk.io/math"
	storetypes "github.com/cosmos/cosmos-sdk/store/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/module"
	upgradetypes "github.com/cosmos/cosmos-sdk/x/upgrade/types"
	ibcfeetypes "github.com/cosmos/ibc-go/v5/modules/apps/29-fee/types"
	cronostypes "github.com/crypto-org-chain/cronos/x/cronos/types"
)

func (app *App) RegisterUpgradeHandlers(experimental bool) {
	// upgrade handlers
	planName := "plan_cronos"
	planHandler := func(ctx sdk.Context, _ upgradetypes.Plan, fromVM module.VersionMap) (module.VersionMap, error) {
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
	app.UpgradeKeeper.SetUpgradeHandler(planName, planHandler)

	upgradeInfo, err := app.UpgradeKeeper.ReadUpgradeInfoFromDisk()
	if err != nil {
		panic(fmt.Sprintf("failed to read upgrade info from disk %s", err))
	}

	if !app.UpgradeKeeper.IsSkipHeight(upgradeInfo.Height) {
		if upgradeInfo.Name == planName {
			storeUpgrades := storetypes.StoreUpgrades{
				Added: []string{ibcfeetypes.StoreKey, cronostypes.StoreKey},
			}

			// configure store loader that checks if version == upgradeHeight and applies store upgrades
			app.SetStoreLoader(upgradetypes.UpgradeStoreLoader(upgradeInfo.Height, &storeUpgrades))
		}
	}
}
