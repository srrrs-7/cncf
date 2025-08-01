.PHONY: localstack sqs lambda s3 apigateway

LOCALSTACK_URL := http://localstack:4566

localstack:
	docker compose up -d localstack

sqs:
	docker compose run --rm aws-cli --endpoint-url=$(LOCALSTACK_URL) sqs create-queue --queue-name test-queue

lambda:
	docker compose run --rm aws-cli --endpoint-url=$(LOCALSTACK_URL) lambda create-function \
		--function-name test-function \
		--runtime python3.9 \
		--role arn:aws:iam::123456789012:role/lambda-role \
		--handler index.handler \
		--zip-file fileb:///dev/null

s3:
	docker compose run --rm aws-cli --endpoint-url=$(LOCALSTACK_URL) s3 mb s3://test-bucket

apigateway:
	docker compose run --rm aws-cli --endpoint-url=$(LOCALSTACK_URL) apigateway create-rest-api --name test-api
