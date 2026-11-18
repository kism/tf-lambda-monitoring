import json
import logging
import os
from concurrent.futures import ThreadPoolExecutor

import urllib3

# {"https://example.com/": "open" | "blocked"}, set in lambda.tf
CHECKS = json.loads(os.environ["checks"])

# ponytail: assumes nginx deny / allowlist rejection returns 401 or 403
BLOCKED_STATUSES = {401, 403}

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Configure logger to only show messages without level/timestamp/request ID
for log_handler in logger.handlers:
    log_handler.setFormatter(logging.Formatter("[%(levelname)s] %(message)s"))

http = urllib3.PoolManager()


class CheckFailedError(Exception):
    def __init__(self, failures):
        self.failures = failures
        super().__init__(f"{len(failures)} check(s) failed:\n" + "\n".join(f"  {f}" for f in failures))


def is_ok(expect, status):
    if expect == "blocked":
        return status in BLOCKED_STATUSES
    return status < 400


def check(item):
    """Return an error message, or None if the URL behaved as expected."""
    url, expect = item
    try:
        status = http.request("GET", url, timeout=10.0, retries=False, redirect=False).status
    except urllib3.exceptions.HTTPError as e:
        return f"{url} expected {expect}, request failed: {e}"
    msg = f"{url} expected {expect}, got {status}"
    if is_ok(expect, status):
        logger.info(msg)
        return None
    return msg


def lambda_handler(event, context):
    with ThreadPoolExecutor(max_workers=8) as pool:
        failures = [f for f in pool.map(check, CHECKS.items()) if f]

    if failures:
        raise CheckFailedError(failures)  # any failure errors the Lambda -> alarm

    msg = f"All {len(CHECKS)} checks passed"
    logger.info(msg)
    return {"statusCode": 200, "body": msg}
