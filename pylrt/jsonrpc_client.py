"""
  pip install "jsonrpcclient[requests]"
"""

from jsonrpcclient import request

def main():
    x = request("http://localhost:5000",
                "ping",
                param1="p1",
                param2="1234.56")
    print(x.data.result)

if __name__ == '__main__':
    main()
