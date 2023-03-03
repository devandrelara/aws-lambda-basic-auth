import pytest
import json
from app.webhook import handle


def test_webhook_lambda():
    try:
        response = handle(event={}, context={})
    except Exception as e:
        print(e)
    message = json.loads(response['body'])['message']
    
    assert response['statusCode'] == 200
    assert message == 'This is the webhook endpoint!'