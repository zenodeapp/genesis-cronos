# GenesisL1 blockchain

<p align="center">
  <img src="https://github.com/zenodeapp/genesisL1/assets/108588903/be368fa2-a154-48a6-b04b-8eb452b02033" alt="GenesisL1" width="150" height="150"/>
</p>

<p align="center">
   Cosmos SDK v0.46.15
</p>

<p align="center">
   <i>Source code fork of cronos and ethermint.</i>
</p>

## Node requirements

- 300GB+ good hard drive disk
- 8GB+ RAM (if necessary it will use at max 150GB from hard drive as swap, see below)
- 4 CPU Threads
- Good Internet Connection

## **Script**

### Overview

`genesisd.sh` is available in the root folder of the repository. Running `sh genesisd.sh` gives an overview of what the script is capable of.

```
Usage: genesisd.sh <command> [moniker]
   <command> should be either 'upgrade' or 'init'

   Options:
     --crisis-skip            Makes sure that genesisd starts with the --x-crisis-skip-assert-invariants flag (default: false)
     --skip-state-download    Skips downloading the genesis.json file, only do this if you're certain to have the correct state file already (default: false)
     --reset-priv-val-state   Resets data/priv_validator_state.json file [UNSAFE] (default: false)
     --no-service             This prevents the genesisd service from being made (default: false)
     --no-start               This prevents the genesisd service from starting at the end of the script (default: false)
```

### Usage

- **Initialization (new validators; generates a new key)**

  `sh genesisd.sh init $YOUR_NEW_NODE_NAME`

- **Upgrading (existing validators; you already have an existing .genesisd folder and configuration)**

  `sh genesisd.sh upgrade`

  _--if you want a different node name you could use `sh genesisd.sh upgrade $YOUR_NEW_NODE_NAME`_
  
  _--more detailed guides for specific upgrades could be found in the [\/genesisd_docs](genesisd_docs/)-folder_
<br>

<p align="center">
  ☕ <i>node init/upgrade time is 30-60min or a few tea cups...</i>
</p>

### Information

#### Swap

Initializing a node uses quite a bit of memory. The script therefore automatically creates virtual memory (swap) to compensate for the amount it requires to start the node. Currently the script is set to automatically calculate how much RAM + Swap is available. Then, whether the user has enough disk space, creates additional swap to have a total of 150GB available RAM + Swap (Example: if 32GB RAM is unused and 30GB of swap is free, an additional swap of 88GB will be created). These swapfiles are formatted as `genesisd_swapfile_{number}` and are made persistent across reboots by adding a line to the `etc/fstab` file. See the bonus scripts for more info on how to properly add or remove them.

#### Backups

If a `.genesisd` folder already exists, the script will back this up to a folder formatted as `.genesisd_backup_{date_time}`. This is a unique name based on the system's current time. Therefore running the script multiple times will continue to create new backup folders.

Since our state file is large this would mean that it will be around ~14GB every time a backup is made. Make sure to remove older backup folders if you plan on running the script more often (testing purposes for instance). They're hidden folders in the root folder; use `cd ~` then `ls -a` to see them.

## **Other (bonus) scripts**

There are some extra scripts in the `genesisd_scripts` folder, which could be useful later down the line.

### - **Swap scripts**

Since the node requires quite some memory usage, swapfiles are created when you run the genesisd.sh script. To alter these swap files we've included scripts to quickly add or remove genesisd_swapfiles.

- **Adding swap** `sh swap_add.sh <amount_of_swap_in_gb>`

  Example: sh swap_add.sh 50 will create a new genesisd_swapfile that is 50GB in size in '/'.

- **Removing swap** `sh swap_remove.sh <filename>`

  Example: sh swap_remove.sh /genesisd_swapfile_2 turns off swapfile genesisd_swapfile_2, removes the related line in '/etc/fstab' and deletes /genesisd_swapfile_2.

- **Removing all swaps** `sh swap_remove_all.sh`

  This will turn off all genesis swapfiles, removes all related lines in '/etc/fstab' and deletes all /genesisd_swapfiles
