# Chain upgrade: genesis_29-2 (Cronos)

This readme is a guide on how to upgrade your node from genesis_29-2 (evmos) to genesis_29-2 (cronos) and what you should be paying attention to.

**IMPORTANT:** Make sure you backup your keys before running the `genesisd.sh` script. Even if it is configured to make a backup of everything, manually doing one yourself is always wise in case anything goes wrong.

Also, for those who come from genesis_29-2 (evmos), do note that this is a different repository than we used before. The old one was named `genesisd`, this one `genesisL1`. Thus don't skip the first steps if you haven't already git cloned the new repository.

---

### <p align="center">1. I am new, I am not a validator yet, but would like to join 🎉</p>

#### Oneliner:

Make sure to replace <NODE_NAME> in the oneliner below with a name of your choice.

```
cd ~ && git clone https://github.com/alpha-omega-labs/genesisL1.git && cd genesisL1 && sh genesisd.sh init <NODE_NAME> --reset-priv-val-state
```

#### Or, step-by-step:

1. `cd ~`
2. `git clone https://github.com/alpha-omega-labs/genesisL1.git`
3. `cd genesisL1`
4. `sh genesisd.sh init <NODE_NAME> --reset-priv-val-state`

   _replace <NODE_NAME> with a name of your choice_

   _the --reset-priv-val-state flag is an extra pre-caution to prevent old values to be used in your new node (if you already had a .genesisd folder)._

---

### <p align="center">2. I am a validator and I NEVER upgraded to the 'cronos' version of GenesisL1 🥱</p>

This means that you still use the `genesisd` repository and not the `genesisL1` repository. If this is the case, then:

#### Oneliner:

```
cd ~ && git clone https://github.com/alpha-omega-labs/genesisL1.git && cd genesisL1 && sh genesisd.sh upgrade --reset-priv-val-state
```

#### Or, step-by-step:

1. `cd ~`
2. `git clone https://github.com/alpha-omega-labs/genesisL1.git`
3. `cd genesisL1`
4. `sh genesisd.sh upgrade --reset-priv-val-state`

   _in case you want to change your node's name, you could also run sh genesisd.sh upgrade <NODE_NAME> --reset-priv-val-state and replace <NODE_NAME> with a name of your choice._

---

### <p align="center">3. I am a validator and I HAVE upgraded to the 'cronos' version of GenesisL1 😎</p>

#### Oneliner:

```
cd ~ && rm -r genesisL1 && git clone https://github.com/alpha-omega-labs/genesisL1.git && cd genesisL1 && sh genesisd.sh upgrade --skip-state-download
```

#### Or, step-by-step:

1. `cd ~`
2. `rm -r genesisL1`
3. `git clone https://github.com/alpha-omega-labs/genesisL1.git`
4. `cd genesisL1`
5. `sh genesisd.sh upgrade --skip-state-download`

   _in case you want to change your node's name, you could also run sh genesisd.sh upgrade <NODE_NAME> --skip-state-download and replace <NODE_NAME> with a name of your choice._

   _--skip-state-download is not necessary but, as you already upgraded, you probably already have the 14GB genesis.json state file thus speeding up the process._

---

### <p align="center">4. I am a validator and I HAVE upgraded to the 'cronos' version of GenesisL1, but prefer to upgrade manually 🤓</p>

For advanced users only. You know who you are. Take note of what exactly happens in the oneliner or step-by-step guide. Important to know is that the `priv_validator_state.json` shouldn't date back to when we were at 29-2 (evmos), else you will not be able to participate properly in the consensus. Your `priv_validator_state.json`-file would then point to a block height that's, at the time of writing, in the future (probably to 6751398 or 6751399). If you're one of these people then you should skip the backup and restore of the `priv_validator_state.json`-file in the commands below.

_I do need to address that you should make sure that your config.toml and app.toml are up-to-date. The commands below don't take care of this for it's too user-specific. Though if you participated in the cronos upgrade and already copied the config files in the `/genesisd_config/` folder over or used the script back then, then you're good, else you should check the folder to see what the config files are supposed to look like. Do not forget to restore your moniker and any other settings you had if you end up using these pre-configured files._

#### Oneliner:

```
cd ~ && rm -r genesisL1 && git clone https://github.com/alpha-omega-labs/genesisL1.git && service genesisd stop && cd genesisL1 && go mod tidy && make install && cd ~/.genesisd && cp ./data/priv_validator_state.json ./priv_validator_state.json && genesisd tendermint unsafe-reset-all && mv ./priv_validator_state.json ./data/priv_validator_state.json && service genesisd start
```

#### Or, step-by-step:

1. `cd ~`
2. `rm -r genesisL1`
3. `git clone https://github.com/alpha-omega-labs/genesisL1.git`
4. `service genesisd stop`
5. `cd genesisL1`
6. `go mod tidy`
7. `make install`
8. `cd ~/.genesisd`
9. `cp ./data/priv_validator_state.json ./priv_validator_state.json`
10. `genesisd tendermint unsafe-reset-all`
12. `mv ./priv_validator_state.json ./data/priv_validator_state.json`
13. `service genesisd start`
