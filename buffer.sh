buffer() {tmp=$(mktemp) && for i in vim bash; do $i "$tmp" || break; done && rm "$tmp"}
