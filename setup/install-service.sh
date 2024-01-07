REPO_DIR=$(cd "$(dirname "$0")"/.. && pwd)

# Add service
cp $REPO_DIR/services/tgenesisd.service /etc/systemd/system/tgenesisd.service
systemctl daemon-reload
systemctl enable tgenesisd
