.PHONY: localstack all sqs lambda s3 apigateway dynamodb ses sns kinesis cloudwatch eventbridge

LOCALSTACK_URL := http://localstack:4566

localstack:
	docker compose up -d localstack

all: sqs lambda s3 apigateway dynamodb ses sns kinesis cloudwatch eventbridge

sqs:
	docker compose run --rm aws-cli --endpoint-url=$(LOCALSTACK_URL) sqs create-queue --queue-name test-queue

lambda:
	@echo 'def handler(event, context): return {"statusCode": 200, "body": "Hello from Lambda!"}' > /tmp/lambda_function.py
	@cd /tmp && zip lambda_function.zip lambda_function.py
	docker compose run --rm -v /tmp:/tmp aws-cli --endpoint-url=$(LOCALSTACK_URL) lambda create-function \
		--function-name test-function \
		--runtime python3.9 \
		--role arn:aws:iam::123456789012:role/lambda-role \
		--handler lambda_function.handler \
		--zip-file fileb:///tmp/lambda_function.zip
	@rm -f /tmp/lambda_function.py /tmp/lambda_function.zip

s3:
	docker compose run --rm aws-cli --endpoint-url=$(LOCALSTACK_URL) s3 mb s3://test-bucket

apigateway:
	docker compose run --rm aws-cli --endpoint-url=$(LOCALSTACK_URL) apigateway create-rest-api --name test-api

dynamodb:
	docker compose run --rm aws-cli --endpoint-url=$(LOCALSTACK_URL) dynamodb create-table \
		--table-name test-table \
		--attribute-definitions AttributeName=id,AttributeType=S \
		--key-schema AttributeName=id,KeyType=HASH \
		--billing-mode PAY_PER_REQUEST

ses:
	docker compose run --rm aws-cli --endpoint-url=$(LOCALSTACK_URL) ses verify-email-identity --email-address test@example.com

sns:
	docker compose run --rm aws-cli --endpoint-url=$(LOCALSTACK_URL) sns create-topic --name test-topic

kinesis:
	docker compose run --rm aws-cli --endpoint-url=$(LOCALSTACK_URL) kinesis create-stream --stream-name test-stream --shard-count 1

cloudwatch:
	docker compose run --rm aws-cli --endpoint-url=$(LOCALSTACK_URL) logs create-log-group --log-group-name test-log-group

eventbridge:
	docker compose run --rm aws-cli --endpoint-url=$(LOCALSTACK_URL) events create-event-bus --name test-event-bus

