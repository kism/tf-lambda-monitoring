import os
import urllib3
import logging


SITE = os.environ[
    "site"
]  # URL of the site to check, stored in the site environment variable

# We don't use the real logger yet since we want to be able to diagnose import issues
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Configure logger to only show messages without level/timestamp/request ID
for log_handler in logger.handlers:
    log_handler.setFormatter(logging.Formatter("[%(levelname)s] %(message)s"))


def lambda_handler(event, context):
    if not SITE:
        raise Exception("Issue with lambda execution, please define SITE")

    http = urllib3.PoolManager()

    response = http.request("GET", SITE, timeout=10.0)

    if response.status == 200:
        msg = f"URL {SITE} returned {response.status} status code"
        logger.info(msg)
        return {"statusCode": 200, "body": msg}

    else:
        msg = f"{SITE} website is broken? Code: {response.status}"
        logger.error(msg)
        raise Exception(msg)
