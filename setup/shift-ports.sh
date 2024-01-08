
# PORT SHIFTER for app.toml and config.toml files.
# Original: https://github.com/zenodeapp/port-shifter
# ZENODE (https://zenode.app) - Adapted for GenesisL1

# This wizard can either increment all ports by a common value or 
# let the user customize each port individually. If you do not trust
# this wizard or prefer a simpler variant, use quick-shift.sh found in
# the repository stated above instead.

CONFIG_PATH=~/.tgenesis/config

# Check if config files exist
if [ ! -f "$CONFIG_PATH/config.toml" ] || [ ! -f "$CONFIG_PATH/app.toml" ]; then
    echo "Error: One or both of the config files ($CONFIG_PATH/config.toml or $CONFIG_PATH/app.toml) not found."
    exit 1
fi

read -p "Do you want to customize each port individually? (y/N): " CUSTOM
CUSTOM=$(echo "$CUSTOM" | tr 'A-Z' 'a-z')  # Convert to lowercase

if [ "$CUSTOM" != "y" ]; then
    read -p "Enter the increment value for all ports: " INCREMENT

    # Check if common_increment is a number using grep
    if echo "$INCREMENT" | grep -q "^[0-9]\+$" && [ "$INCREMENT" -ne 0 ]; then
        echo "Incrementing all ports by $INCREMENT..."
    else
        INCREMENT=0
        echo "Resetting all ports to default values..."
    fi
fi

echo ""

# Helper function to prompt for port value
prompt_for_port() {
    local PORT_NAME="$1"
    local DEFAULT_VALUE="$2"

    read -p "Enter value for $PORT_NAME (default: $DEFAULT_VALUE): " USER_INPUT
    echo "${USER_INPUT:-$DEFAULT_VALUE}"
}

# backup
cp $CONFIG_PATH/config.toml $CONFIG_PATH/config.toml.bak
cp $CONFIG_PATH/app.toml $CONFIG_PATH/app.toml.bak

# Config.toml default ports
PROXY_APP=26658
RPC_LADDR=26657
PPROF_LADDR=6060
P2P_LADDR=26656
PROMETHEUS_LISTEN_ADDR=26660

# Ask for each port value if CUSTOM is "y"
if [ "$CUSTOM" = "y" ]; then
    PROXY_APP=$(prompt_for_port "proxy_app" $PROXY_APP)
    RPC_LADDR=$(prompt_for_port "[rpc] laddr" $RPC_LADDR)
    PPROF_LADDR=$(prompt_for_port "pprof_laddr" $PPROF_LADDR)
    P2P_LADDR=$(prompt_for_port "[p2p] laddr" $P2P_LADDR)
    PROMETHEUS_LISTEN_ADDR=$(prompt_for_port "prometheus_listen_addr" $PROMETHEUS_LISTEN_ADDR)
fi

sed -i "/^proxy_app/ s/\(proxy_app = \".*\):\([0-9]*\)/\1:$((PROXY_APP + INCREMENT))/" $CONFIG_PATH/config.toml
sed -i "/^\[rpc\]/,/\[.*\]/ s/\(laddr = \".*\):\([0-9]*\)/\1:$((RPC_LADDR + INCREMENT))/" $CONFIG_PATH/config.toml
sed -i "/^pprof_laddr/ s/\(pprof_laddr = \".*\):\([0-9]*\)/\1:$((PPROF_LADDR + INCREMENT))/" $CONFIG_PATH/config.toml
sed -i "/^\[p2p\]/,/\[.*\]/ s/\(laddr = \".*\):\([0-9]*\)/\1:$((P2P_LADDR + INCREMENT))/" $CONFIG_PATH/config.toml
sed -i "/^prometheus_listen_addr/ s/\(prometheus_listen_addr = \".*\):\([0-9]*\)/\1:$((PROMETHEUS_LISTEN_ADDR + INCREMENT))/" $CONFIG_PATH/config.toml

echo "Ports have been replaced in $CONFIG_PATH/config.toml"
echo ""

# App.toml default ports
API_ADDRESS=1317
ROSETTA_ADDRESS=8080
GRPC_ADDRESS=9090
GRPC_WEB_ADDRESS=9091
JSON_RPC_ADDRESS=8545
JSON_RPC_WS_ADDRESS=8546
JSON_RPC_METRICS_ADDRESS=6065

# Ask for each port value if CUSTOM is "y"
if [ "$CUSTOM" = "y" ]; then
    API_ADDRESS=$(prompt_for_port "[api] address" $API_ADDRESS)
    ROSETTA_ADDRESS=$(prompt_for_port "[rosetta] address" $ROSETTA_ADDRESS)
    GRPC_ADDRESS=$(prompt_for_port "[grpc] address" $GRPC_ADDRESS)
    GRPC_WEB_ADDRESS=$(prompt_for_port "[grpc-web] address" $GRPC_WEB_ADDRESS)
    JSON_RPC_ADDRESS=$(prompt_for_port "[json-rpc] address" $JSON_RPC_ADDRESS)
    JSON_RPC_WS_ADDRESS=$(prompt_for_port "[json-rpc] ws-address" $JSON_RPC_WS_ADDRESS)
    JSON_RPC_METRICS_ADDRESS=$(prompt_for_port "[json-rpc] metrics-address" $JSON_RPC_METRICS_ADDRESS)
fi

sed -i "/^\[api\]/,/\[.*\]/ s/\(address = \".*\):\([0-9]*\)/\1:$((API_ADDRESS + INCREMENT))/" $CONFIG_PATH/app.toml
sed -i "/^\[rosetta\]/,/\[.*\]/ s/\(address = \".*\):\([0-9]*\)/\1:$((ROSETTA_ADDRESS + INCREMENT))/" $CONFIG_PATH/app.toml
sed -i "/^\[grpc\]/,/\[.*\]/ s/\(address = \".*\):\([0-9]*\)/\1:$((GRPC_ADDRESS + INCREMENT))/" $CONFIG_PATH/app.toml
sed -i "/^\[grpc-web\]/,/\[.*\]/ s/\(address = \".*\):\([0-9]*\)/\1:$((GRPC_WEB_ADDRESS + INCREMENT))/" $CONFIG_PATH/app.toml
# Make sure to run all these three together and do not comment out the last two, since the first will at first overwrite all three.
sed -i "/^\[json-rpc\]/,/\[.*\]/ s/\(address = \".*\):\([0-9]*\)/\1:$((JSON_RPC_ADDRESS + INCREMENT))/" $CONFIG_PATH/app.toml
sed -i "/^\[json-rpc\]/,/\[.*\]/ s/\(ws-address = \".*\):\([0-9]*\)/\1:$((JSON_RPC_WS_ADDRESS + INCREMENT))/" $CONFIG_PATH/app.toml
sed -i "/^\[json-rpc\]/,/\[.*\]/ s/\(metrics-address = \".*\):\([0-9]*\)/\1:$((JSON_RPC_METRICS_ADDRESS + INCREMENT))/" $CONFIG_PATH/app.toml

echo "Ports have been replaced in $CONFIG_PATH/app.toml"