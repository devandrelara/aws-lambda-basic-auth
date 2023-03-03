import json


def handle(event, context):
    body = {
        "message": "This is the webhook endpoint!"
    }

    return {"statusCode": 200, "body": json.dumps(body)}
