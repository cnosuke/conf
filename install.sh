#!/bin/zsh
function backup_config_file(){
	if [ -e ~/.$1 ]; then
		mv ~/.$1 ~/.config_backup_`date +"%Y%m%d"`/.
	fi
}

function make_config_symlink(){
	if [ -e ~/.conf/$1 ]; then
		ln -s ~/.conf/$1 ~/.$1
	fi
}

function back_and_make(){
	backup_config_file $1
	make_config_symlink $1
}

mkdir ~/.config_backup_`date +"%Y%m%d"`

cp -r ../conf ~/.conf

back_and_make emacs
back_and_make gitconfig
back_and_make gitignore
back_and_make screenrc
back_and_make tmux.conf
back_and_make zshrc
back_and_make percol.d
back_and_make pryrc
back_and_make gemrc
back_and_make ptconfig.toml
