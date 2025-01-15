function serve() {
    python3 -c "
import http.server
import socketserver
import webbrowser
import os

PORT=8080

class Handler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        super().end_headers()

def open_browser():
    webbrowser.open_new(f'http://localhost:{PORT}')

if __name__ == '__main__':
    with socketserver.TCPServer(('', PORT), Handler) as httpd:
        print(f'Serving at http://localhost:{PORT}')
        open_browser()
        httpd.serve_forever()
"
}
