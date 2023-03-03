test_api_gateway_authorizer_event = {
    "version": "2.0",
    "type": "REQUEST",
    "routeArn": "arn:aws:execute-api:us-east-1:928832413289:o0cr9big99/dev/GET/webhook",
    "identitySource": [
        "Basic YWRtaW46cGFzc3dk"
    ],
    "routeKey": "GET /webhook",
    "rawPath": "/dev/webhook",
    "rawQueryString": "",
    "headers": {
        "accept": "*/*",
        "authorization": "Basic YWRtaW46cGFzc3dk",
        "content-length": "0",
        "host": "o0cr9big99.execute-api.us-east-1.amazonaws.com",
        "user-agent": "curl/7.68.0",
        "x-amzn-trace-id": "Root=1-64025604-04ce8f126783e3001cd7e347",
        "x-forwarded-for": "201.80.0.222",
        "x-forwarded-port": "443",
        "x-forwarded-proto": "https"
    },
    "requestContext": {
        "accountId": "928832413289",
        "apiId": "o0cr9big99",
        "domainName": "o0cr9big99.execute-api.us-east-1.amazonaws.com",
        "domainPrefix": "o0cr9big99",
        "http": {
            "method": "GET",
            "path": "/dev/webhook",
            "protocol": "HTTP/1.1",
            "sourceIp": "201.80.0.222",
            "userAgent": "curl/7.68.0"
        },
        "requestId": "BOJgwgN_oAMEPkA=",
        "routeKey": "GET /webhook",
        "stage": "dev",
        "time": "03/Mar/2023:20:18:12 +0000",
        "timeEpoch": 1677874692533
    }
}