"""
  Using Python's built-in HTTPServer

  pip install jsonrpcserver
"""
from http.server import BaseHTTPRequestHandler, HTTPServer
from jsonrpcserver import method, dispatch

from argparse import Namespace
import sample_task as ST

@method
def sample_task(task_id,
                how_many_seconds,
                url_hook,
                is_sync_task):
    # return task_id, how_many_seconds, url_hook, is_sync_task
    args = Namespace(
        task_id=task_id,
        how_many_seconds=how_many_seconds,
        url=url_hook,
        sync_task=is_sync_task)
    return ST.main(args)

@method
def ping(param1, param2):
    return "pong", {"param1": param1, "param2": param2}

class TestHttpServer(BaseHTTPRequestHandler):
    def do_POST(self):
        # Process request
        request = self.rfile.read(int(self.headers["Content-Length"])).decode()
        response = dispatch(request)
        # Return response
        self.send_response(response.http_status)
        self.send_header("Content-type", "application/json")
        self.end_headers()
        self.wfile.write(str(response).encode())


if __name__ == "__main__":
    HTTPServer(("localhost", 5000), TestHttpServer).serve_forever()
