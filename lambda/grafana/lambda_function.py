import os
import urllib3

SITE = os.environ['site']  # URL of the site to check, stored in the site environment variable

def lambda_handler(event, context):
    if not SITE:
        raise Exception("Issue with lambda execution, please define SITE")

    http = urllib3.PoolManager()

    response = http.request('GET', SITE, timeout=10.0)

    if response.status == 200:
        return {
            'statusCode': 200,
            'body': f'URL {SITE} returned {response.status} status code'
        }
    else:
        raise Exception(f"Grafana website is broken? Code: {response.status}")
