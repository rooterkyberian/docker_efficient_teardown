import argparse
import signal
import threading
import time


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--cleanup", action="store_true")
    args = parser.parse_args()
    print(f"Script started with {vars(args)}")

    alive = True

    if args.cleanup:

        def shutdown(*_):
            nonlocal alive
            alive = False

        for sig in (signal.SIGTERM, signal.SIGINT):
            signal.signal(sig, shutdown)

    def thread_func():
        while alive:
            time.sleep(1)

    t = threading.Thread(target=thread_func)
    t.start()


if __name__ == "__main__":
    main()
