## You must install thefuck before adding to your .*rc

eval $(thefuck --alias)

function precmd() {
  case "${?}" in
    0) ;;
    *) fuck ;;
  esac
}
