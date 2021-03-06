if [ -e ~/.conf/zshrc_time_measure ]; then
   source ~/.conf/zshrc_time_measure
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH=$PATH:/usr/local/Cellar/git/2.3.5/share/git-core/contrib/diff-highlight/
export PATH=$PATH:/Users/cnosuke/Library/Python/3.6/bin
export PATH=$PATH:/Users/cnosuke/.conf/bin/ignore

# zsh config file dir
export ZDOTDIR=${HOME}

bindkey "^?" backward-delete-char

FORTUNE2CH=0

export LS_PATH='ls'

# 以下、広瀬レコメンドは小文字、そうでないのは大文字にしてある
setopt auto_cd 			# コマンドが省略されていたら cd とみなす
setopt AUTO_PUSHD		# cd 時にOldDir を自動的にスタックに積む
setopt correct			# コマンドのスペルチェック
setopt auto_name_dirs		# よく判らん
setopt auto_remove_slash	# 補完が/で終って、つぎが、語分割子か/かコマンド
setopt extended_history 	# ヒストリに時刻情報もつける
setopt extended_glob		# グロブで、特殊文字"#,~,^"を使う、
setopt FUNCTION_ARGZERO 	#  $0 にスクリプト名/シェル関数名を格納
setopt hist_ignore_dups		# 前のコマンドと同じならヒストリに入れない
setopt hist_ignore_space	# 空白ではじまるコマンドをヒストリに保持しない
setopt HIST_IGNORE_ALL_DUPS	# 重複するヒストリを持たない
setopt HIST_NO_FUNCTIONS	# 関数定義をヒストリに入れない
setopt HIST_NO_STORE		# history コマンドをヒストリに入れない
setopt HIST_REDUCE_BLANKS	# 履歴から冗長な空白を除く
setopt MULTIOS			# 名前付きパイプ的に入出力を複数開ける
setopt NUMERIC_GLOB_SORT	# グロブの数のマッチを辞書式順じゃなくって数値の順
setopt prompt_subst		# プロンプト文字列で各種展開を行なう
setopt no_promptcr              # 改行コードで終らない出力もちゃんと出力する
setopt pushd_ignore_dups	# ディレクトリスタックに、同じディレクトリを入れない
setopt SHARE_HISTORY		# 複数プロセスで履歴を共有
setopt SHORT_LOOPS		# loop の短縮形を許す
setopt sh_word_split		# よく判らん
setopt RC_EXPAND_PARAM		# {}をbash ライクに展開
setopt TRANSIENT_RPROMPT 	# 右プロンプトに入力がきたら消す

# lsを弄る
# http://nao.no-ip.info/index.cgi?.zsh_common
export LS_OPTIONS='-vG'
#--show-control-chars -h --color=auto'
# デフォルトから、拡張子ごとの設定を除いた物
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43'
export LS_COLORS=$LS_COLORS':tw=30;42:ow=34;42:st=37;44:ex=01;32'
# http://d.hatena.ne.jp/kujirahand/20070204/1170547240
export LS_COLORS=$LS_COLORS':no=00:fi=00:di=01;34;04:ln=01;36:ex=01;32'
# stickyビットのない、othersが書き込み可能なファイル
export LS_COLORS=$LS_COLORS':ow=31'
# アーカイブ系
export LS_COLORS=$LS_COLORS':*.tar=35:*.gz=35:*.bz2=35:*.zip=35:*.lha=35:*.z=35:*.Z=35:*.tgz=35'

alias ls="$LS_PATH -h $LS_OPTIONS"
alias l="$LS_PATH -h $LS_OPTIONS"
alias la="$LS_PATH -ha $LS_OPTIONS"
alias ll="$LS_PATH -lAFtr $LS_OPTIONS"
alias lsH="$LS_PATH -l $LS_OPTIONS"
alias lsHa="$LS_PATH -la $LS_OPTIONS"
alias lsg="$LS_PATH -lh $LS_OPTIONS . | grep"

# grep。デフォルトでケースセーフに
alias -g G="| grep -3 -n -i --color=auto"
alias -g nG="| grep -3 -n -i --color=auto -v"
alias grep="grep -3 -n -i --color=auto"
alias ngrep="grep -3 -n -i --color=auto -v"

# 再帰的に、強調付きでgrep
alias findgrep='find . -type f -not -path \*/.svn/\* -not -path \*~ | xargs grep -I -H -n --color=always --context=1'

# hisotry
# setopt share_history # 前のほうですでに設定してある。
HISTFILE=$HOME/.zsh-history           # 履歴をファイルに保存する
HISTSIZE=100000                       # メモリ内の履歴の数
SAVEHIST=100000                       # 保存される履歴の数
setopt extended_history               # 履歴ファイルに時刻を記録
function history-all { history -E 1 } # 全履歴の一覧を出力する

# Ctrl-D でログアウトするのを抑制する。
setopt  ignore_eof

# グロブがマッチしないときエラーにしない
# http://d.hatena.ne.jp/amt/20060806/ZshNoGlob
setopt null_glob

# 小文字に対して大文字も補完する
# http://www.ex-machina.jp/zsh/index.cgi?FAQ%40zsh%A5%B9%A5%EC#l1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# urlエンコード
function url-encode { E=${${(j: :)@}//(#b)(?)/%$[[##16]##${match[1]}]} }
function url-decode { D=${1//\%(#b)([0-F][0-F])/\\\x$match[1]} }

# 要するにless。
alias -g L="| less -R -N -M"

# 指定したユーザーにメッセージを送る
alias -g W="| write"

# エディタ
alias emacs="emacs -nw"

# 文字コード変換
alias -g EUC="| iconv --from-code=EUC-JP --to-code=UTF-8"
alias -g SJIS="| iconv --from-code=SHIFT-JIS --to-code=UTF-8"
alias -g TOEUC="| iconv --from-code=UTF-8 --to-code=EUC-JP"
alias -g TOSJIS="| iconv --from-code=UTF-8 --to-code=SHIFT-JIS"
function EUCL(){
    cat $1 EUC L
}
function SJISL(){
    cat $1 SJIS L
}

# 全プロセスから引数の文字列を含むものを grep する
function psg() {
    ps aux | head -n 1		 # ラベルを表示
    ps aux | 'grep' $* | 'grep' -v "ps -aux" | 'grep' -v 'grep' # grep プロセスを除外
}

# sub shell で sudo
function sudo-command(){
	sudo sh -c "$@"
}

# man を pdf で見る。
function man-pdf(){
	pdfPath=$TMPDIR/man.$1.pdf
	man -t $1 | ps2pdf - $pdfPath
	if [ -f /usr/bin/open ]; then
		/usr/bin/open $pdfPath
	else
		echo "PDF generated: $pdfPath"
	fi
}

# tar.bz2解凍
function untarbz2(){
	bzip2 -dc $1 | tar xvf -
}

# tar.gz解凍
function untargz(){
	tar -zxvf $1
}

# .diffをカレントディレクトリに適用
function diffApply(){
	patch -p0 -d . < $1
}

# 特定コマンドを繰り返す
alias WATCH="/usr/local/Cellar/watch/3.3.16/bin/watch -d --interval=3"
alias WATCHsudo="sudo /usr/local/Cellar/watch/3.3.16/bin/watch -d --interval=3"
alias WATCH1="/usr/local/Cellar/watch/3.3.16/bin/watch -d --interval=1"
alias WATCHsudo1="sudo /usr/local/Cellar/watch/3.3.16/bin/watch -d --interval=1"


# 引数を数式として計算
# ex: calc '1. + sin(1)'
function calc () {
    echo $(($@))
}

# Begin: .ssh/known_hosts による補完。
# known_hostsがハッシュ化されていると腐るので注意

# make_p () {
#     local t s
#     t="$1"; shift
#
#     [ -f $t ] || return 0
#
#     for s; do
# 	[ $s -nt $t ] && return 0
#     done
#
#     return 1
# }
#
# cache_hosts_file="$ZDOTDIR/.cache_hosts"
# known_hosts_file="$HOME/.ssh/known_hosts"
#
# print_cache_hosts () {
#     if [ -f $known_hosts_file ]; then
# 	awk '{ if (split($1, a, ",") > 1) for (i in a) { if (a[i] ~ /^[a-z]/) print a[i] } else print $1 }' $known_hosts_file
#     fi
# }
#
# update_cache_hosts () {
#     print_cache_hosts | sort -u > $cache_hosts_file
# }
#
# make_p $cache_hosts_file $known_hosts_file && update_cache_hosts
#
# _cache_hosts=( $(< $cache_hosts_file) )

# End: .ssh/known_hosts による補完

autoload -U compinit
compinit -u

export EDITOR='emacs'

if [ -e ~/.conf/zshrc_rbenv ]; then
  source ~/.conf/zshrc_rbenv
fi

if [ -e ~/.conf/zshrc_pyenv ]; then
    source ~/.conf/zshrc_pyenv
fi

if [ -e ~/.conf/zshrc_mac ]; then
    source ~/.conf/zshrc_mac
fi

if [ -e ~/.conf/zshrc_prompt ]; then
    source ~/.conf/zshrc_prompt
fi

if [ -e ~/.conf/zshrc_alias ]; then
    source ~/.conf/zshrc_alias
fi

if [ -e ~/.conf/zshrc_ssh ]; then
    source ~/.conf/zshrc_ssh
fi

if [ -e ~/.conf/zshrc_debian ]; then
    source ~/.conf/zshrc_debian
fi

if [ -e ~/.conf/zshrc_peco ]; then
    source ~/.conf/zshrc_peco
fi

if [ -e ~/.conf/zshrc_dash ]; then
    source ~/.conf/zshrc_dash
fi

if [ -e ~/.conf/zshrc_gcloud ]; then
    source ~/.conf/zshrc_gcloud
fi

if [ -e ~/.conf/zshrc_k8s ]; then
    source ~/.conf/zshrc_k8s
fi

if [ -e ~/.conf/zshrc_aws ]; then
    source ~/.conf/zshrc_aws
fi

if [ -e ~/.conf/zshrc_go ]; then
    source ~/.conf/zshrc_go
fi

if [ -e ~/.conf/zshrc_adhocws ]; then
    source ~/.conf/zshrc_adhocws
fi

if [ -e ~/.conf/zshrc_private ]; then
    source ~/.conf/zshrc_private
fi

if [ -e ~/.conf/zshrc_known_hosts ]; then
    source ~/.conf/zshrc_known_hosts
fi

if [ -e ~/.conf/zshrc_local ]; then
    source ~/.conf/zshrc_local
fi

if [ -e ~/.conf/zshrc_kubectl ]; then
    source ~/.conf/zshrc_kubectl
fi

if [ -e ~/.conf/zshrc_n ]; then
    source ~/.conf/zshrc_n
fi

if [ -e ~/.conf/zshrc_lsd ]; then
    source ~/.conf/zshrc_lsd
fi

if [ -e ~/.conf/zshrc_direnv ]; then
    source ~/.conf/zshrc_direnv
fi

if [ -e ~/.conf/zshrc_curl ]; then
    source ~/.conf/zshrc_curl
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/cnosuke/.sdkman"
[[ -s "/Users/cnosuke/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/cnosuke/.sdkman/bin/sdkman-init.sh"

export GPG_TTY=$(tty)
export LANG=en_US.UTF-8

# export GO111MODULE=on


[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

test -e "${ZDOTDIR}/.iterm2_shell_integration.zsh" && source "${ZDOTDIR}/.iterm2_shell_integration.zsh"
