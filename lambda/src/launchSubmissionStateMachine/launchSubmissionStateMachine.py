#
# ---
# Description: "Launch Submission State Machine"
# MemorySize: 128
# Timeout: 10
# Policies:
# ---
#

# Imports

from __future__ import print_function  # Python 2/3 compatibility
import boto3
import json
import logging
import os

# Constants

# Globals

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)


# Utility functions

# Classes

# Functions

def handler(event, context):
    client = boto3.client('stepfunctions')
    client.start_execution(
        stateMachineArn=os.environ.get("SUBMISSION_STATE_MACHINE"),
        input=json.dumps(event)
    )
