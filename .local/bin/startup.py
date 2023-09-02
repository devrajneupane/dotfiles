import atexit
import csv
import hashlib
import json
import math
import os
import random
import re
import readline
import rlcompleter
import shelve
import sys
from collections import *
from datetime import date, datetime, timedelta
from functools import partial
from inspect import getmembers, ismethod, stack
from io import open
from itertools import *
from math import *
from types import FunctionType
from unittest.mock import MagicMock, Mock, patch
from uuid import uuid4
from contextlib import suppress

history_path = os.path.expanduser("~/.cache/python_history")

# Add tab completion
if "libedit" in readline.__doc__:
    readline.parse_and_bind("bind ^I rl_complete")
else:
    readline.parse_and_bind("tab:complete")

if os.path.exists(history_path):
    readline.read_history_file(history_path)

# if rich is installed, set the repr() to be pretty printed
with suppress(ImportError):
    from rich import pretty

    pretty.install(indent_guides=True)


# Shorcurt to pip install packages without leaving the shell
def pip_install(*packages):
    """Install packages directly in the shell"""
    for name in packages:
        cmd = ["install", name]
        if not hasattr(sys, "real_prefix"):
            raise ValueError("Not in a virtualenv")
        pip.main(cmd)


# def save_history(history_path=history_path):
#     readline.write_history_file(history_path)


# atexit.register(save_history)
atexit.register(readline.write_history_file, history_path)
del atexit, rlcompleter, history_path  # save_history
