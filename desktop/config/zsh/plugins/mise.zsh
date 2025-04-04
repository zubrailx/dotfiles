export MISE_SHELL=zsh
export __MISE_ORIG_PATH="$PATH"

mise() {
  local command
  command="${1:-}"
  if [ "$#" = 0 ]; then
    command mise
    return
  fi
  shift

  case "$command" in
  deactivate|shell|sh)
    # if argv doesn't contains -h,--help
    if [[ ! " $@ " =~ " --help " ]] && [[ ! " $@ " =~ " -h " ]]; then
      eval "$(command mise "$command" "$@")"
      return $?
    fi
    ;;
  esac
  command mise "$command" "$@"
}

_mise_hook() {
  eval "$(mise hook-env -s zsh)";
}
typeset -ag precmd_functions;
if [[ -z "${precmd_functions[(r)_mise_hook]+1}" ]]; then
  precmd_functions=( _mise_hook ${precmd_functions[@]} )
fi
typeset -ag chpwd_functions;
if [[ -z "${chpwd_functions[(r)_mise_hook]+1}" ]]; then
  chpwd_functions=( _mise_hook ${chpwd_functions[@]} )
fi

_mise_hook
if [ -z "${_mise_cmd_not_found:-}" ]; then
    _mise_cmd_not_found=1
    [ -n "$(declare -f command_not_found_handler)" ] && eval "${$(declare -f command_not_found_handler)/command_not_found_handler/_command_not_found_handler}"

    function command_not_found_handler() {
        if mise hook-not-found -s zsh -- "$1"; then
          _mise_hook
          "$@"
        elif [ -n "$(declare -f _command_not_found_handler)" ]; then
            _command_not_found_handler "$@"
        else
            echo "zsh: command not found: $1" >&2
            return 127
        fi
    }
fi
#compdef mise
local curcontext="$curcontext"

# caching config
_usage_mise_cache_policy() {
  if [[ -z "${lifetime}" ]]; then
    lifetime=$((60*60*4)) # 4 hours
  fi
  local -a oldp
  oldp=( "$1"(Nms+${lifetime}) )
  (( $#oldp ))
}

_mise() {
  typeset -A opt_args
  local curcontext="$curcontext" spec cache_policy

  if ! command -v usage &> /dev/null; then
      echo >&2
      echo "Error: usage CLI not found. This is required for completions to work in mise." >&2
      echo "See https://usage.jdx.dev for more information." >&2
      return 1
  fi

  zstyle -s ":completion:${curcontext}:" cache-policy cache_policy
  if [[ -z $cache_policy ]]; then
    zstyle ":completion:${curcontext}:" cache-policy _usage_mise_cache_policy
  fi

  if ( [[ -z "${_usage_spec_mise_2024_12_17:-}" ]] || _cache_invalid _usage_spec_mise_2024_12_17 ) \
      && ! _retrieve_cache _usage_spec_mise_2024_12_17;
  then
    spec="$(mise usage)"
    _store_cache _usage_spec_mise_2024_12_17 spec
  fi

  _arguments "*: :(($(usage complete-word --shell zsh -s "$spec" -- "${words[@]}" )))"
  return 0
}

if [ "$funcstack[1]" = "_mise" ]; then
    _mise "$@"
else
    compdef _mise mise
fi

# vim: noet ci pi sts=0 sw=4 ts=4
