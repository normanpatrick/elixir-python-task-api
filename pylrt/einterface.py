import requests

def post_to_webhook(url, data):
    return requests.post(url, data=data)

def main():
    # test webhook
    print("do something interesing")
    r = post_to_webhook(url="http://localhost:4000/api/lrthook",
                        data={"hello": "world"})
    print(r, r.json())

if __name__ == '__main__':
    main()
