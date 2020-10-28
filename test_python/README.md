# Graceful shutdown of Python process using threads

[`spawner.py`](./spawner.py) spawns a single thread, but only installs SIGINT handler if started with `--cleanup` option.

    cd test_python
    ../test_docker/bench.sh

output:

    python_teardown_subprocesses uses an image, skipping
    python_teardown_subprocesses_with_cleanup uses an image, skipping
    Creating network "test_python_default" with the default driver
    Creating test_python_python_teardown_subprocesses_with_cleanup_1 ... done
    Creating test_python_python_teardown_subprocesses_1              ... done
                   Name                             Command               State   Ports
    -----------------------------------------------------------------------------------
    test_python_python_teardown_subpro   python /mnt/spawner.py           Up
    cesses_1
    test_python_python_teardown_subpro   python /mnt/spawner.py --c ...   Up
    cesses_with_cleanup_1

    Time to stop:
    /test_python_python_teardown_subprocesses_1
    10.880
    /test_python_python_teardown_subprocesses_with_cleanup_1
    1.651
    Attaching to test_python_python_teardown_subprocesses_1, test_python_python_teardown_subprocesses_with_cleanup_1
    python_teardown_subprocesses_with_cleanup_1  | Script started with {'cleanup': True}
    python_teardown_subprocesses_1               | Script started with {'cleanup': False}
