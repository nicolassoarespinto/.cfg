## TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


## Get appimage of latest release
curl -s https://api.github.com/repos/nelsonenzo/tmux-appimage/releases/latest \
| grep "browser_download_url.*appimage" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi - \
&& chmod +x tmux.appimage

## move it into your $PATH
mkdir -p ~/.local/src/tmux/
mv tmux.appimage ~/.local/src/tmux


