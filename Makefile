##############
# localstack #
##############
.PHONY: localstack all sqs lambda lambda-invoke lambda-delete s3 apigateway dynamodb ses sns kinesis cloudwatch eventbridge

LOCALSTACK_URL := http://localstack:4566

localstack:
	docker compose up -d localstack

all: sqs lambda s3 apigateway dynamodb ses sns kinesis cloudwatch eventbridge

sqs:
	docker compose run --rm aws-cli --endpoint-url=$(LOCALSTACK_URL) sqs create-queue --queue-name test-queue

lambda:
	docker compose exec localstack zip \
		 /src/lambda/dist/lambda_func.zip \
		/src/lambda/dist/lambda_func.js /src/lambda/package.json
	docker compose run --rm aws-cli --endpoint-url=$(LOCALSTACK_URL) lambda create-function \
		--function-name test-function \
		--runtime nodejs22.x \
		--role arn:aws:iam::123456789012:role/lambda-role \
		--handler lambda_func.handler \
		--zip-file fileb:///src/lambda/dist/lambda_func.zip

lambda-invoke:
	docker compose run --rm aws-cli --endpoint-url=$(LOCALSTACK_URL) lambda invoke \
		--function-name test-function \
		--cli-binary-format raw-in-base64-out \
  		--payload '{ "name": "srrrs" }' \
  		/src/lambda/output/output.json
	docker compose exec localstack cat /src/lambda/output/output.json

lambda-delete:
	docker compose run --rm aws-cli --endpoint-url=$(LOCALSTACK_URL) lambda delete-function --function-name test-function

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

############
# oven bun #
############
.PHONY: bun

bun:
	docker compose run --rm oven-bun bash

lambda-build:
	docker compose run --rm oven-bun bun build /src/lambda/func/lambda_func.ts --outdir=/src/lambda/dist --format esm

