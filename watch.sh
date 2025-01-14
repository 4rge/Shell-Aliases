watch() {
    if [ -z "$1" ]; then
        echo "Usage: ytplay <search-term>"
        return 1
    fi
    yt-dlp "ytsearch1:$1" -o - | mpv -
}
