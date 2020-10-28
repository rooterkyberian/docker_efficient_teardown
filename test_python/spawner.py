import argparse
import signal
import sys
import threading
import time

THREADS = []


def main():
    print(f"Script started with {sys.argv}")
    parser = argparse.ArgumentParser()
    parser.add_argument("--cleanup", action="store_true")
    args = parser.parse_args()

    alive = True

    def thread_func():
        while alive:
            time.sleep(1)

    if args.cleanup:

        def shutdown(*_):
            nonlocal alive
            alive = False

        for sig in (signal.SIGTERM, signal.SIGINT):
            signal.signal(sig, shutdown)

    t = threading.Thread(target=thread_func)
    t.start()


if __name__ == "__main__":
    main()
