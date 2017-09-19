#
# ---
# Description: "Check submitted file"
# MemorySize: 128
# Timeout: 10
# Policies:
# ---
#

# Imports

from __future__ import print_function  # Python 2/3 compatibility
import logging

# Constants

ACCEPTED_FILE_FORMAT = [
    'jpeg',
    'jpg',
    'png'
]

# Globals

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)


# Utility functions

# Classes

class NotSupportedImage(Exception):
    pass


# Functions

def handler(event, context):
    logger.debug("Received event: " + str(event))
    record = event['Records'][0]
    file_name = str(record['s3']['object']['key'])
    logger.info("Received event for file: " + file_name)
    accept_file_name(file_name)
    s3 = {
        "bucket_name": str(record['s3']['bucket']['name']),
        "file_name": file_name
    }
    logger.debug("Sending event: " + str(s3))
    return s3


def accept_file_name(file_name):
    file_name_parts = file_name.rsplit('.', 1)

    # check file name: firstname.lastname
    logger.debug("File name: " + file_name_parts[0])
    if file_name_parts[0] is None or file_name_parts[0].find('.') == -1:
        logger.error("File: " + file_name + " has not a valid name: firstname.lastname.FORMAT")
        raise NotSupportedImage("File: " + file_name + " has not a valid name: firstname.lastname.FORMAT")

    # check format
    logger.debug("File format: " + file_name_parts[1])
    if file_name_parts[1] is None or file_name_parts[1].lower() not in ACCEPTED_FILE_FORMAT:
        logger.error("File: " + file_name + " is not a PNG or JPEG file")
        raise NotSupportedImage("File: " + file_name + " is not a PNG or JPEG file")


# Tests

def test():
    event = {
        "Records": [
            {
                "eventVersion": "2.0",
                "eventSource": "aws:s3",
                "awsRegion": "eu-central-1",
                "eventTime": "2017-09-17T16:15:39.119Z",
                "eventName": "ObjectCreated:Put",
                "userIdentity": {
                    "principalId": "A2LAYS0EJQ36RS"
                },
                "requestParameters": {
                    "sourceIPAddress": "000.000.000.000"
                },
                "responseElements": {
                    "x-amz-request-id": "722C9C370D1C054F",
                    "x-amz-id-2": "TG902x6MWkcvvLR19tHICFqReFbdY75gcqMcGjKJVUgST3xF6Vgc5+i8/s4/UOayEeRnhARALZs="
                },
                "s3": {
                    "s3SchemaVersion": "1.0",
                    "configurationId": "submissionEvent",
                    "bucket": {
                        "name": "mug-shot-submission-s3",
                        "ownerIdentity": {
                            "principalId": "A2LAYS0EJQ36RS"
                        },
                        "arn": "arn:aws:s3:::mug-shot-submission-s3"
                    },
                    "object": {
                        "key": "victor.salaun.png",
                        "size": 57,
                        "eTag": "16ee922f5a0f4eeb1af87cb65e287087",
                        "sequencer": "0059BE9FAAF9BBE96D"
                    }
                }
            }
        ]
    }
    handler(event, None)


if __name__ == '__main__':
    test()
