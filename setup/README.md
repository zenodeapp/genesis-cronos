# Setup

> [!NOTE]
> The scripts in this folder are not specifically written for **local** testnet purposes.
>
> If you plan on testing **locally**, head over to [/setup-local](/setup-local) instead.

## dependencies.sh

This script installs all the dependencies (and system configurations) that are necessary for the binary to run. Since this file already gets called from within the other scripts, it is not required to call this yourself.

## upgrade.sh

> [!WARNING]
> This script should only be used if you run a full-node and have to perform the **"plan_cronos"**-upgrade!
>
> This means that you are currently operating on the Evmos fork of GenesisL1 (repo: [`genesis-evmos`](https://github.com/zenodeapp/genesis-evmos)) and the node synced till height: `insert_height_here` which caused it to panic.

This script takes care of the needed steps to upgrade the node to the new fork:

- It stops the node (the service)
- Creates a backup of existing _config.toml_ or _app.toml_ files (as _.toml.bak_)
- Introduces new config files
- Fetches latest seeds and peers
- Builds the binaries

### Usage

```
sh setup/upgrade.sh
```
> After a successful upgrade, start the node again using `systemctl start tgenesisd` and monitor its status with `journalctl -fu tgenesisd -ocat`.

## state-sync.sh

> [!CAUTION]
> Running this will **wipe the entire database** (the _/data_-folder **excluding** the priv_validator_state.json file).
> 
> Make a backup if needed: [utils/create-backup.sh](/utils/create-backup.sh).

This script takes care of the needed steps to join the network via State Sync:

- It stops the service (if it exists)
- Installs all the necessary dependencies
- Builds the binaries
- Initializes the node
- Resets config files
- Fetches latest seeds and peers
- Fetches `genesis.json`-file
- Fetches RPC servers
- Installs the service
- Recalibrates **[statesync]** settings to a recent height (**default:** `<latest_height>` - `2000`)

### Usage

```
sh setup/state-sync.sh <moniker>
```
> If you wish to change the default _<height_interval>_ of `2000`, run [utils/recalibrate-state-sync.sh](/utils/recalibrate-state-sync.sh) _<height_interval>_ yourself _after_ running this; see [utils/README.md](/utils) for more information.

## create-validator.sh

> [!IMPORTANT]
> _create-validator.sh_ requires a key.
>
> If you haven't already created or imported one, use: [utils/create-key.sh](/utils/create-key.sh) _or_ [utils/import-key.sh](/utils/import-key.sh).

This script should only be run once you're **fully synced**. It's a wizard; prompting the user the minimum required fields for creating a validator.

### Usage

```
sh setup/create-validator.sh
```
