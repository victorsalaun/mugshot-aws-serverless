#
# ---
# Description: "Copy submitted file"
# MemorySize: 128
# Timeout: 10
# Policies:
# ---
#

# Imports

from __future__ import print_function  # Python 2/3 compatibility
import boto3
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
    logger.debug("Received event: " + str(event))
    file_name_parts = event['file_name'].rsplit('.', 1)
    client = boto3.client('s3')
    client.copy_object(CopySource=event['bucket_name'] + '/' + event['file_name'],
                       Bucket=os.environ.get("MUG_SHOT_BUCKET"), Key=event['id'] + '.' + file_name_parts[1])
    return event

# Tests
