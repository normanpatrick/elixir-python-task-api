"""
  - a sample python long-running-task
  - accept mulitple arguments
  - sleep 1 sec and broadcast update
  - do something env specific (e.g. which python env) etc.
"""

import sys
import time
import argparse
from pprint import pprint
import einterface
import sample_module as sm

def main(args):
    print("hello from python")
    for i in range(args.how_many_seconds):
        time.sleep(1)
        status = "at {} second, fn(x,y) = {}".format(i, sm.add(100, i))
        print(status)
        is_active = "false" if (i == args.how_many_seconds - 1) else "true"
        r = einterface.post_to_webhook(url=args.url,
                                       data={
                                           "id": args.task_id,
                                           "is_active": is_active,
                                           "status": status,
                                           "X": i
                                       })
        print(r.status_code, r.json())
    # provide enough time to flush hook call
    time.sleep(1)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Do something interesting')
    parser.add_argument('--how-many-seconds', type=int, default=10)
    parser.add_argument('--url', required=True)
    parser.add_argument('--task_id', required=True)
    args = parser.parse_args()
    print(vars(args))
    main(args)
