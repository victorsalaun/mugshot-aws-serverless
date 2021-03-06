#
# ---
# Description: "Delete submitted file"
# MemorySize: 128
# Timeout: 10
# Policies:
# ---
#

# Imports

from __future__ import print_function  # Python 2/3 compatibility
import boto3
import logging

# Constants

# Globals

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)


# Utility functions

# Classes

# Functions

def handler(event, context):
    logger.debug("Received event: " + str(event[0]))
    client = boto3.client('s3')
    client.delete_object(Bucket=event[0]['bucket_name'], Key=event[0]['file_name'])

# Tests
