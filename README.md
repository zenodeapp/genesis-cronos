<h1 align="center">
  GenesisL1 Testnet (Cronos fork)
</h1>

<p align="center">
  <ins>Release <b>v1.0.0</b> ~ Cronos <b>v1.0.15</b></ins>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/alpha-omega-labs/genesis-parameters/main/assets/l1-logo.png" alt="GenesisL1" width="150" height="150"/>
</p>

<p align="center">
  Chain ID <b>tgenesis_290-1</b>
</p>

<p align="center">
   A source code fork of <b>Cronos</b> and <b>Ethermint</b>
</p>

<p align="center">
  Cosmos SDK <b>v0.46.15</b>
</p>

---

> [!IMPORTANT]
> **For full-node syncing**
> 
> We were an Evmos-fork before we made the decision to hard fork to Cronos. Therefore if you do not want to **state sync**, but wish to sync a **full node**, follow the instructions in the [`genesis-ethermint`](https://github.com/zenodeapp/genesis-ethermint) repository first before continuing.

## Node requirements

- 300GB+ good hard drive disk
- 8GB+ RAM
- 4 CPU Threads
- Good Internet Connection

## Instructions

The instructions provided here will only be suitable for those who would like to join the **public** testnet: `tgenesis_290-1` by **setting up a new node** _or_ **upgrading an existing (full) node**. If you instead want to _test_ **locally**, see the [README](/setup-local/README.md) in the [/setup-local](/setup-local)-folder.

> [!NOTE]
> More details for every script mentioned in this README can be found in the folders where they are respectively stored: [/setup](/setup), [/setup-local](/setup-local) or [/utils](/utils).

### 1. Cloning the repository

```
git clone https://github.com/zenodeapp/genesis-crypto.git
```

### 2. Checkout the right tag/branch

```
git checkout tgenesis-v1.0.0
```

### 3. Node setup

Depending on your circumstances, you'll either have to **Setup a node _(using state sync)_** or **Upgrade a node**.

#### 3.1 Setup a node _(using state sync)_

This script takes care of the needed steps to join the network via _state sync_.

> [!WARNING]
> Running this will **wipe the entire database** (the _/data_-folder **excluding** the priv_validator_state.json file). Therefore if you already have a node set up and you prefer not to have your GenesisL1 database lost, create a backup.
>
> You could use [utils/backup/create.sh](/utils/backup/create.sh) for this.

```
sh setup/state-sync.sh <moniker>
```

#### 3.2 Upgrade a node

This script assumes that you are currently operating on the Evmos fork of GenesisL1 (repo: [`genesis-ethermint`](https://github.com/zenodeapp/genesis-ethermint)) and the node synced till height: `insert_height_here` which caused it to panic.

> [!IMPORTANT]
> This should only be used if you run a **full-node** and have to perform the **"plan_cronos"**-upgrade.

```
sh setup/upgrade.sh
```

### 4. Daemon check

If you can't access the `tgenesisd` command at this point, then you may need to execute:

```
. ~/.bashrc
```
> Or the equivalent: `source ~/.bashrc`

### 5. Create or import a key (optional)

A key is necessary to interact with the network/node. If you haven't already created one, either import one or generate a new one, using:

```
sh utils/key/create.sh <key_alias>
```

OR

```
sh utils/key/import.sh <key_alias> <private_eth_key>
```

> _<private_eth_key>_ is the private key for a (wallet) address you already own.

### 6. Node syncing

If everything went well, you should now be able to run your node using:

```
systemctl start tgenesisd
```

and see its status with:

```
journalctl -fu tgenesisd -ocat
```

### 7. Become a validator (optional)

Once your node is _up-and-running_, _fully synced_ and you have a _key_ created or imported, you could become a validator using:

```
sh setup/create-validator.sh <moniker> <key_alias>
```
> This is a wizard and shall prompt the user only the required fields to create an on-chain validator.

### 8. Explore utilities (optional)

> [!TIP]
> The [/utils](/utils)-folder contains useful utilities one could use to manage their node (e.g. for fetching latest seeds and peers, fetching the genesis state, quickly shifting your config's ports, recalibrating your state sync etc.). To learn more about these, see the [README](utils/README.md) in the folder.
