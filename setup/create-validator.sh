#!/bin/bash

cat <<"EOF"

  /$$$$$$                                          /$$                 /$$         /$$       
 /$$__  $$                                        |__/                | $$       /$$$$       
| $$  \__/  /$$$$$$  /$$$$$$$   /$$$$$$   /$$$$$$$ /$$  /$$$$$$$      | $$      |_  $$       
| $$ /$$$$ /$$__  $$| $$__  $$ /$$__  $$ /$$_____/| $$ /$$_____/      | $$        | $$       
| $$|_  $$| $$$$$$$$| $$  \ $$| $$$$$$$$|  $$$$$$ | $$|  $$$$$$       | $$        | $$       
| $$  \ $$| $$_____/| $$  | $$| $$_____/ \____  $$| $$ \____  $$      | $$        | $$       
|  $$$$$$/|  $$$$$$$| $$  | $$|  $$$$$$$ /$$$$$$$/| $$ /$$$$$$$/      | $$$$$$$$ /$$$$$$     
 \______/  \_______/|__/  |__/ \_______/|_______/ |__/|_______/       |________/|______/     
                                                                                             
Welcome to the decentralized blockchain Renaissance, above money & beyond cryptocurrency!
EOF

echo ""
echo "Creating a validator should only be done if your node is all caught up (at the latest"
echo "height) and you've generated or imported a key. In the /utils-folder you can find two"
echo "scripts making it easier to either create a key or import one using a private key."
echo ""
echo "If you're all set, then you can proceed."
read -p "Ready? (y/N): " ANSWER

ANSWER=$(echo "$ANSWER" | tr 'A-Z' 'a-z')  # Convert to lowercase

if [ "$ANSWER" != "y" ]; then
    echo "Aborted."
    exit 1
fi

# Root of the current repository
REPO_ROOT=$(cd "$(dirname "$0")"/.. && pwd)

# Source the variables file
. "$REPO_ROOT/utils/_variables.sh"

read -p "What's the alias of the key you'll use to sign? " KEY_ALIAS
read -p "What will be your validator name? " MONIKER
read -p "What's the amount you'll self-delegate? (denom: L1) " AMOUNT
read -p "What will be your commission rate percentage? (0.0 - 1.0) " COMMISSION_RATE
read -p "What will be your max commission rate percentage? (0.0 - 1.0) " COMMISSION_MAX_RATE
read -p "What will be your max commission change rate percentage (per day)? (0.0 - 1.0) " COMMISSION_MAX_CHANGE_RATE
read -p "What's the amount you'll self-delegate? (denom: L1) - " AMOUNT
DECIMALS="000000000000000000" 

$BINARY_NAME tx staking create-validator \
  --amount="$AMOUNT""$DECIMALS"el1 \
  --pubkey=$($BINARY_NAME tendermint show-validator) \
  --moniker="$MONIKER" \
  --chain-id=$CHAIN_ID \
  --commission-rate="$COMMISSION_RATE" \
  --commission-max-rate="$COMMISSION_MAX_RATE" \
  --commission-max-change-rate="$COMMISSION_MAX_CHANGE_RATE" \
  --min-self-delegation="1000000" \
  --gas="2100000" \
  --from=$KEY_ALIAS \
  --fees=4200000000000000el1 \
  --broadcast-mode async \
  -y