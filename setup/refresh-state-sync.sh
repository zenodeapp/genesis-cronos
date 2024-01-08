RPC_SERVER_1=$1
RPC_SERVER_2=${2:-$RPC_SERVER_1}
HEIGHT_INTERVAL=${3:-2000}

if [ -z "$1" ]; then
    echo "Usage: sh $0 <RPC_SERVER_1> [RPC_SERVER_2] [HEIGHT_INTERVAL]"
    echo "  [RPC_SERVER_2] is optional (default: [RPC_SERVER_1])."
    echo "  [HEIGHT_INTERVAL] is optional (default: 2000)."
    exit 1
fi

NODE_DIR=.tgenesis
CONFIG_PATH=~/$NODE_DIR/config

# Stop processes
systemctl stop tgenesisd
pkill cosmovisor

# Back up validator state
cp ~/$NODE_DIR/data/priv_validator_state.json ~/$NODE_DIR/priv_validator_state.json.bak

LATEST_HEIGHT=$(curl -s $RPC_SERVER_1/block | jq -r .result.block.header.height); \
TRUST_HEIGHT=$((LATEST_HEIGHT - $HEIGHT_INTERVAL)); \
TRUST_HASH=$(curl -s "$RPC_SERVER_1/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i '/^\[statesync\]/,/^enable = / s/enable = .*/enable = true/' $CONFIG_PATH/config.toml
sed -i 's/rpc_servers = .*/rpc_servers = "'"$RPC_SERVER_1,$RPC_SERVER_2"'"/' $CONFIG_PATH/config.toml
sed -i 's/trust_height = .*/trust_height = '$TRUST_HEIGHT'/' $CONFIG_PATH/config.toml
sed -i 's/trust_hash = .*/trust_hash = "'"$TRUST_HASH"'"/' $CONFIG_PATH/config.toml

# Reset to imported genesis.json
tgenesisd tendermint unsafe-reset-all

# Move backed up validator state back
mv ~/$NODE_DIR/priv_validator_state.json.bak ~/$NODE_DIR/data/priv_validator_state.json