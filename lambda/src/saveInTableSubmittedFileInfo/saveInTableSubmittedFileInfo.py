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
    names = file_name_parts[0].split('.')
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(os.environ.get("MUG_TABLE"))
    mug = {
        'id': event['id'],
        'format': file_name_parts[1],
        'firstname': names[0].upper(),
        'lastname': names[1].upper()
    }
    table.put_item(
        Item=mug
    )

# Tests
