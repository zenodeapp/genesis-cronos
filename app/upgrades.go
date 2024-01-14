package app

import (
  "fmt"

  sdkmath "cosmossdk.io/math"
  sdk "github.com/cosmos/cosmos-sdk/types"
  "github.com/cosmos/cosmos-sdk/types/module"
  feemarketkeeper "github.com/evmos/ethermint/x/feemarket/keeper"
  evmkeeper "github.com/evmos/ethermint/x/evm/keeper"
  storetypes "github.com/cosmos/cosmos-sdk/store/types"
  upgradetypes "github.com/cosmos/cosmos-sdk/x/upgrade/types"
  ibcfeetypes "github.com/cosmos/ibc-go/v5/modules/apps/29-fee/types"
  cronostypes "github.com/crypto-org-chain/cronos/x/cronos/types"
)

type UpgradeInfo struct {
  Name    string
  Info    string
  Handler func(ctx sdk.Context, _ upgradetypes.Plan, fromVM module.VersionMap) (module.VersionMap, error)
}

// This is the fork upgrade to Cronos binaries
func UpgradeV1(
  mm *module.Manager,
  configurator module.Configurator,
  fm feemarketkeeper.Keeper,
  evm *evmkeeper.Keeper,
) UpgradeInfo {
  return UpgradeInfo{
    Name: "plan_cronos",
    Info: `'{"binaries":{"darwin/amd64":"","darwin/x86_64":"","linux/arm64":"","linux/amd64":"","windows/x86_64":""}}'`,
    Handler: func(ctx sdk.Context, _ upgradetypes.Plan, fromVM module.VersionMap) (module.VersionMap, error) {
      m, err := mm.RunMigrations(ctx, configurator, fromVM)
      if err != nil {
        return m, err
      }
  
      // Override feemarket parameters
      fmParams := fm.GetParams(ctx)
      fmParams.BaseFeeChangeDenominator = 300
      fmParams.ElasticityMultiplier = 4
      fmParams.BaseFee = sdk.NewInt(10000000000000)
      fmParams.MinGasPrice = sdk.NewDec(10000000000000)
      fm.SetParams(ctx, fmParams)
  
      // clear extra_eips from evm parameters
      // Ref: https://github.com/crypto-org-chain/cronos/issues/755
      evmParams := evm.GetParams(ctx)
      evmParams.ExtraEIPs = []int64{}
      zero := sdkmath.ZeroInt()
      // fix the incorrect value on testnet parameters
      evmParams.ChainConfig.LondonBlock = &zero
      evm.SetParams(ctx, evmParams)

      return m, nil
    },
  }
}

func (app *App) RegisterUpgradeHandlers(experimental bool) {
  upgradeV1 := UpgradeV1(
    app.mm,
    app.configurator,
    app.FeeMarketKeeper,
    app.EvmKeeper,
  )

  app.UpgradeKeeper.SetUpgradeHandler(
    upgradeV1.Name,
    upgradeV1.Handler,
  )

  // When a planned update height is reached, the old binary will panic
  // writing on disk the height and name of the update that triggered it
  // This will read that value, and execute the preparations for the upgrade.
  upgradeInfo, err := app.UpgradeKeeper.ReadUpgradeInfoFromDisk()
  if err != nil {
    panic(fmt.Errorf("failed to read upgrade info from disk: %w", err))
  }

  if app.UpgradeKeeper.IsSkipHeight(upgradeInfo.Height) {
    return
  }

  var storeUpgrades *storetypes.StoreUpgrades

  switch upgradeInfo.Name {
  case upgradeV1.Name:
    storeUpgrades = &storetypes.StoreUpgrades{
      Added: []string{ibcfeetypes.StoreKey, cronostypes.StoreKey},
    }
  default:
    // no-op
  }

  if storeUpgrades != nil {
    // configure store loader that checks if version == upgradeHeight and applies store upgrades
    app.SetStoreLoader(upgradetypes.UpgradeStoreLoader(upgradeInfo.Height, storeUpgrades))
  }
}