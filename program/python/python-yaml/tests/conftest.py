import sys

def pytest_configure(config):
    print("pytest configure...")
    sys._called_from_test = True


def pytest_unconfigure(config):
    print("pytest un-configure...")
    del sys._called_from_test


