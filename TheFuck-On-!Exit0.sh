## You must install thefuck before adding to your .*rc

function precmd() {
  case "${?}" in
    0) tine ;;
    *) fuck ;;
  esac
}
