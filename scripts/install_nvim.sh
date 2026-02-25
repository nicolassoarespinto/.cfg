# Install Neovim from source
log "Installing Neovim..."
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
git clone https://github.com/neovim/neovim.git --depth=1
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=Release
sudo make install


