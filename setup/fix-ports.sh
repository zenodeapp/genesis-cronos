NODE_DIR=.tgenesis

PORT_INCREMENT=1000*$2
PROXY_APP_DEFAULT=26658

LADDR=26657
LADDR_INCREMENT=1000
PROXY_APP_DEFAULT=26658
PROXY_APP_DEFAULT=26658

# sed -i "s/moniker = .*/moniker = \"$MONIKER\"/" ~/$NODE_DIR/config/config.toml

# sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":\"%" $HOME/./config/config.toml && \
# sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:\"%; s%^address = \":8080\"%address = \":\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:\"%" $HOME/./config/app.toml