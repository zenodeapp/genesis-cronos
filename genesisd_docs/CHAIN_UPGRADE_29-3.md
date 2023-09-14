# Chain upgrade: genesis_29-3

This readme is a guide on how to upgrade your node from genesis_29-2 to genesis_29-3 and what you should be paying attention to.
  
**IMPORTANT:** Make sure you backup your keys before running the `genesisd.sh` script. Even if it is configured to make a backup of everything, manually doing one yourself is always wise in case anything goes wrong.

Also, for those who come from genesis_29-2 (evmos), do note that this is a different repository than we used before. The old one was named `genesisd`, this one `genesisL1`. Thus don't skip the first steps if you haven't already git cloned the new repository.

Finally, the state file has changed again. Even if you already have the 14Gb state file, because we had to change the chain-id as well in this file (therefore you should not use the `--skip-state-download` flag). 

___

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

___

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

___

### <p align="center">3. I am a validator and I HAVE upgraded to the 'cronos' version of GenesisL1 😎</p>

#### Oneliner:

```
cd ~ && rm -r genesisL1 && git clone https://github.com/alpha-omega-labs/genesisL1.git && cd genesisL1 && sh genesisd.sh upgrade --reset-priv-val-state
```

#### Or, step-by-step:

1. `cd ~`
2. `rm -r genesisL1`
3. `git clone https://github.com/alpha-omega-labs/genesisL1.git`
4. `cd genesisL1`
5. `sh genesisd.sh upgrade --reset-priv-val-state`

    _in case you want to change your node's name, you could also run sh genesisd.sh upgrade <NODE_NAME> --reset-priv-val-state and replace <NODE_NAME> with a name of your choice._

   _do not use the --skip-state-download flag, for reasons stated above._

___

### <p align="center">4. I am a validator and I HAVE upgraded to the 'cronos' version of GenesisL1, but prefer to upgrade manually 🤓</p>

For advanced users only. You know who you are. Take note of what exactly happens in the oneliner or step-by-step. Important to know is that the state file changed again, so downloading this again. Also the chain-id changed from genesis_29-2 to genesis_29-3 and the priv_validator_state.json file needs to be reset ({"height": "0", "round": 0, "step": 0}).

_I do need to address that you should make sure that your config.toml and app.toml are up-to-date. If you participated in the cronos upgrade and already copied these config files over or used the script back then, then you're good, else you should check the `/genesisd_config/` folder to see what the config files look like. Do not forget to restore your moniker and any other settings you had if you end up using these pre-configured files._

#### Oneliner:

```
cd ~ && rm -r genesisL1 && git clone https://github.com/alpha-omega-labs/genesisL1.git && service genesisd stop && cd genesisL1 && go mod tidy && make install && genesisd config chain-id genesis_29-3 && cd ~/.genesisd/config && rm -r genesis.json && wget http://135.181.135.29/genesisd/genesis.json && genesisd tendermint unsafe-reset-all && service genesisd start
```

#### Or, step-by-step:

1. `cd ~`
2. `rm -r genesisL1`
3. `git clone https://github.com/alpha-omega-labs/genesisL1.git`
4. `service genesisd stop`
5. `cd genesisL1`
6. `go mod tidy`
7. `make install`
8. `genesisd config chain-id genesis_29-3`
9. `cd ~/.genesisd/config`
10. `rm -r genesis.json`
11. `wget http://135.181.135.29/genesisd/genesis.json`
12. `genesisd tendermint unsafe-reset-all`
13. `service genesisd start`
