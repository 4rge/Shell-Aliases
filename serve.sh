function serve() {
    python3 -m http.server 8080 --bind 127.0.0.1 --directory . &
    sleep 1 && xdg-open "http://localhost:8080"
}
