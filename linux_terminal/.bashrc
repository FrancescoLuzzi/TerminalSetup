eval "$(oh-my-posh --init --shell bash --config ~/.luzzi_theme.omp.json)"

if [ ! -f ~/.git.plugin.sh ]
then
  curl https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/plugins/git/git.plugin.sh -o .git.plugin.sh
fi
source ~/.git.plugin.sh
