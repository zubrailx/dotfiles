alias c="clear"
alias o="xdg-open"
alias ls="ls --color -F"
alias ll="ls --color -lh"
alias info='info --vi-keys'

alias sysupdate="sudo emerge --sync && sudo emerge -aDNuv @world --exclude=\"\`awk 'END{print RS}\$0=\$0' ORS=\" \" /etc/portage/package.exclude_desktop\`\""
alias sysupdateall="sudo emerge --sync && sudo emerge -aDNuv @world"

alias sysupdate.emerge="sudo emerge -aDNuv @world --exclude=\"\`awk 'END{print RS}\$0=\$0' ORS=\" \" /etc/portage/package.exclude_desktop\`\""
alias sysupdateall.emerge="sudo emerge -aDNuv @world"

alias lsa="ls -a"
alias lla="ls -la"

# Dirstack
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# TMUX
alias ta="tmux attach || tmux"

alias jl="lazygit"

alias ntp-sync="sudo ntpdate -b -u 0.gentoo.pool.ntp.org"

alias v="nvim"
