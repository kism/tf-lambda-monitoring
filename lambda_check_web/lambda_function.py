import os
import urllib3
import logging 

logger = logging.getLogger()
logger.setLevel(logging.INFO)

SITE = os.environ['site']  # URL of the site to check, stored in the site environment variable

def lambda_handler(event, context):
    if not SITE:
        raise Exception("Issue with lambda execution, please define SITE")

    http = urllib3.PoolManager()

    response = http.request('GET', SITE, timeout=10.0)

    if response.status == 200:
        msg = f'URL {SITE} returned {response.status} status code'
        logger.info(msg)
        return {
            'statusCode': 200,
            'body': msg
        }
        
    else:
        msg = f"{SITE} website is broken? Code: {response.status}"
        logger.error(msg)
        raise Exception(msg)
