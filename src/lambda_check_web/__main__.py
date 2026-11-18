import sys


def main():
    try:
        from dotenv import load_dotenv

        load_dotenv()
    except ImportError:
        pass  # optional: `uv run --extra dotenv check-web`

    # Imported after load_dotenv, lambda_function reads env at import time
    from .lambda_function import CheckFailedError, is_ok, lambda_handler

    assert is_ok("open", 200) and is_ok("open", 302)
    assert not is_ok("open", 403) and not is_ok("open", 502)
    assert is_ok("blocked", 403) and is_ok("blocked", 401)
    assert not is_ok("blocked", 200) and not is_ok("blocked", 502)
    try:
        print(lambda_handler(None, None)["body"])
    except CheckFailedError as e:
        sys.exit(f"ERROR: {e}")  # prints to stderr, exit code 1


if __name__ == "__main__":
    main()
