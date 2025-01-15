watch() {
    [ -z "$1" ] && { echo "Usage: watch <search-term>"; return 1; }
    yt-dlp "ytsearch1:$1" -o - | mpv -
}
