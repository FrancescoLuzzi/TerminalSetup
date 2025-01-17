#!/usr/bin/bash
echo "#!/usr/bin/bash" > install_vscode_extensions.sh
code --list-extensions | xargs -n1 echo code --install-extension | tee -a install_vscode_extensions.sh