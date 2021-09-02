import json
import argparse
import requests

f = open("iRedMail.tips", "r")
config = f.read()
start = config.find("dkim._domainkey")
end = config.find("SpamAssassin")
dkim_record = config[start:end].split("(")[1].split(")")[0].strip().replace("\"", "").replace(" ", "").replace("\n", "")

payload = {
    "type": "TXT",
    "name": "dkim._domainkey",
    "data": dkim_record,
    "priority": None,
    "port": None,
    "ttl": 3600,
    "weight": None,
    "flags": None,
    "tag": None
}

DO_TOKEN = "${do-token}"
DOMAIN_NAME = "${domain-name}"
headers = {"content-type": "application/json", "Authorization": "Bearer {}".format(DO_TOKEN)}
endpoint = "https://api.digitalocean.com/v2/domains/{}/records".format(DOMAIN_NAME)

r = requests.post(endpoint,data=json.dumps(payload),headers=headers)

