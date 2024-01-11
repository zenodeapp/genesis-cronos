# Setup

## cronos-upgrade-proposal.sh

This script creates a proposal to upgrade to cronos and immediately votes yes through governance. Needless to say, this requires you to already have joined the testnet (i.e. by using `quick-testnet-setup.sh`). For the plan name it uses _plan_cronos_.

```
Usage: sh cronos-upgrade-proposal.sh <KEY_ALIAS> <UPGRADE_HEIGHT> [NEXT_PROPOSAL_ID]
 - [NEXT_PROPOSAL_ID] is optional, but should point towards the upgrade proposal to vote on (default: 1)
```

## dependencies.sh

This script installs all the dependencies (and system configurations) that are necessary for the binary to run. Since this file already gets called from within the other scripts, it is not required to call this yourself.

## generate-validator.sh

This script uses `add-genesis-account` and `gentx` to create a genesis-validator. This will create a file inside of the `/.tgenesis/config/gentx`-folder, which contains the transaction details for adding this validator to the `genesis.json` file. 

Though if you're only going to run a local testnet, simply run the `quick-testnet-setup.sh` with the `--local` flag which will automatically add your key as a genesis validator (see below).

## quick-testnet-setup.sh

> [!CAUTION]
> Running this will **wipe the whole data-folder** (database **AND** the priv_validator_state.json file!). Make a backup if needed.

This script takes care of everything to join the `tgenesis_54-1` testnet:

- It stops the service (if it exists)
- installs all the necessary dependencies
- Builds the binaries
- Generates a new _or_ attempts to overwrite an existing key
- Resets all configuration files to their default
- Fetches state, seeds and peers
- Initializes the node
- Installs the service
- Runs the node
  
### Usage

```
sh quick-testnet-setup.sh --moniker string --key string
```
> _--moniker_ and _--key_ are optional and will default, respectively, to _mygenesismoniker_ and _mygenesiskey_. Advised is to always add the key alias, so that in case it already exists it asks whether you'd like to overwrite it or not. This way you prevent it from accidentally creating a _mygenesiskey_ if you do not desire this.

> [!TIP]
> You can add the `--local` flag if you would like to spin up a local testnet. This will immediately create a genesis validator using your key and set these configurations:
> - **[p2p]** addr_book_strict = false
> - **[p2p]** allow_duplicate_ip = true
> - **[api]** enabled = true
> - **[api]** enabled-unsafe-cors = true
> 
> Be careful though, this will still use the `.tgenesis`-folder and wipe everything in the data folder!


