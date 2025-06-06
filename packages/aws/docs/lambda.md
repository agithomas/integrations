# AWS Lambda

The AWS Lambda integration allows you to monitor [AWS Lambda](https://aws.amazon.com/lambda/)—a serverless compute service.

Use the AWS Lambda integration to collect metrics related to your [Lambda functions](https://aws.amazon.com/lambda/faqs/#AWS_Lambda_functions). Then visualize that data in Kibana, create alerts to notify you if something goes wrong, and reference metrics when troubleshooting an issue.

For example, you could use this integration to track throttled lambda functions, alert the relevant project manager, and then increase your account's concurrency limit.

**IMPORTANT: Extra AWS charges on API requests will be generated by this integration. Check [API Requests](https://www.elastic.co/docs/current/integrations/aws#api-requests) for more details.**

## Data streams

The AWS Lambda integration collects metrics and logs.

**Logs** provide detailed information about the execution of AWS Lambda functions.
They include invocation events, function output, error messages, stack traces, initialization logs, and AWS-generated reports. These logs help you troubleshoot issues, analyze performance, and monitor the behavior of your Lambda functions during runtime.

**Metrics** give you insight into the state of AWS Lambda.
Metrics collected by the AWS Lambda integration include the number of times your function code is executed, the amount of time that your function code spends processing an event, the number of invocations that result in a function error, and more.

See more details in the [Metrics reference](#metrics-reference).

## Event Source Mapping Metrics

This integration can also collect Event Source Mapping (ESM) metrics, which track how your Lambda function processes records from event sources like Amazon SQS, DynamoDB, or Kinesis. 

To collect these metrics, you must:  
1. Enable Event Source Mapping for your Lambda function by following the steps outlined in the [AWS documentation](https://docs.aws.amazon.com/lambda/latest/dg/monitoring-metrics-types.html#event-source-mapping-metrics).  
2. Enable the configuration flag `Collect Event Source Mapping metrics`.  

Important notes:
- Enabling this feature may incur additional costs
- Not all metrics are available for every event source type
- Metric collection may be affected by CloudWatch or Lambda service availability

See more details about [Event Source Mapping Metrics](https://docs.aws.amazon.com/lambda/latest/dg/monitoring-metrics-types.html#event-source-mapping-metrics).

## Requirements

You need Elasticsearch for storing and searching your data and Kibana for visualizing and managing it.
You can use our hosted Elasticsearch Service on Elastic Cloud, which is recommended, or self-manage the Elastic Stack on your own hardware.

Before using any AWS integration you will need:

* **AWS Credentials** to connect with your AWS account.
* **AWS Permissions** to make sure the user you're using to connect has permission to share the relevant data.

For more details about these requirements, please take a look at the [AWS integration documentation](https://docs.elastic.co/integrations/aws#requirements).

## Setup

Use this integration if you only need to collect data from the AWS Lambda service.

If you want to collect data from two or more AWS services, consider using the **AWS** integration.
When you configure the AWS integration, you can collect data from as many AWS services as you'd like.

For step-by-step instructions on how to set up an integration, see the
[Getting started](https://www.elastic.co/guide/en/starting-with-the-elasticsearch-platform-and-its-solutions/current/getting-started-observability.html) guide.

To enable AWS Lambda logs, ensure that your function's execution role includes the necessary permissions to write to Amazon CloudWatch Logs. Specifically, the role should have the following permissions: 
- `logs:CreateLogGroup`
- `logs:CreateLogStream`
- `logs:PutLogEvents` 

You can grant these permissions by attaching the AWS managed policy `AWSLambdaBasicExecutionRole` to your function's execution role.

By default, AWS Lambda automatically streams logs to CloudWatch Logs. You can view these logs by navigating to the AWS Lambda console, selecting your function, and choosing the "Monitor" tab. From there, click on "View CloudWatch logs" to access the logs in the CloudWatch console.

For more detailed information, refer to the AWS documentation on [Sending Lambda function logs to CloudWatch Logs](https://docs.aws.amazon.com/lambda/latest/dg/monitoring-cloudwatchlogs.html).

## Logs reference

An example event for `lambda` looks as following:

```json
{
    "@timestamp": "2025-05-05T03:31:17.000Z",
    "agent": {
        "ephemeral_id": "b08489ab-f2a0-4ae5-8428-eac8cdf637b8",
        "id": "fe56d5ab-2d79-40bf-95d9-2972541e73b2",
        "name": "elastic-agent-58953",
        "type": "filebeat",
        "version": "8.16.6"
    },
    "aws": {
        "lambda": {
            "error": {
                "message": "Unable to import module 'app': No module named 'aws_lambda_powertools'",
                "type": "Runtime.ImportModuleError"
            }
        }
    },
    "aws.cloudwatch": {
        "ingestion_time": "2025-05-05T03:31:18.000Z",
        "log_group": "arn:aws:logs:ap-south-1:XXXXXXXXXXXX:log-group:/aws/lambda/sam-app-powertools-python-HelloWorldFunction-snAkfaCNYJjx",
        "log_stream": "2025/05/05/[$LATEST]3486c2ec71334eedba860f992d13b330"
    },
    "cloud": {
        "provider": "aws",
        "region": "ap-south-1",
        "service": {
            "name": "aws_lambda"
        }
    },
    "data_stream": {
        "dataset": "aws.lambda_logs",
        "namespace": "13365",
        "type": "logs"
    },
    "ecs": {
        "version": "8.11.0"
    },
    "elastic_agent": {
        "id": "fe56d5ab-2d79-40bf-95d9-2972541e73b2",
        "snapshot": false,
        "version": "8.16.6"
    },
    "event": {
        "agent_id_status": "verified",
        "dataset": "aws.lambda_logs",
        "id": "38946375503894473967458689613264054098903355794226544641",
        "ingested": "2025-05-28T15:40:08Z"
    },
    "input": {
        "type": "aws-cloudwatch"
    },
    "log": {
        "file": {
            "path": "arn:aws:logs:ap-south-1:XXXXXXXX:log-group:/aws/lambda/sam-app-powertools-python-HelloWorldFunction-snAkfaCNYJjx/2025/05/05/[$LATEST]3486c2ec71334eedba860f992d13b330"
        }
    },
    "tags": [
        "forwarded",
        "aws-lambda-logs"
    ]
}
```

## Metrics reference

An example event for `lambda` looks as following:

```json
{
    "@timestamp": "2022-07-19T22:40:00.000Z",
    "agent": {
        "ephemeral_id": "ed2abfa1-df5e-4c3e-9c2b-143edcc0e111",
        "id": "2d4b09d0-cdb6-445e-ac3f-6415f87b9864",
        "name": "docker-fleet-agent",
        "type": "metricbeat",
        "version": "8.3.2"
    },
    "aws": {
        "cloudwatch": {
            "namespace": "AWS/Lambda"
        },
        "lambda": {
            "metrics": {
                "ConcurrentExecutions": {
                    "avg": 1
                },
                "Duration": {
                    "avg": 130.97
                },
                "Errors": {
                    "avg": 0
                },
                "Invocations": {
                    "avg": 1
                },
                "Throttles": {
                    "avg": 0
                },
                "UnreservedConcurrentExecutions": {
                    "avg": 1
                }
            }
        }
    },
    "cloud": {
        "account": {
            "id": "627286350134",
            "name": "elastic-observability"
        },
        "provider": "aws",
        "region": "eu-central-1"
    },
    "data_stream": {
        "dataset": "aws.lambda",
        "namespace": "default",
        "type": "metrics"
    },
    "ecs": {
        "version": "8.11.0"
    },
    "elastic_agent": {
        "id": "2d4b09d0-cdb6-445e-ac3f-6415f87b9864",
        "snapshot": false,
        "version": "8.3.2"
    },
    "event": {
        "agent_id_status": "verified",
        "dataset": "aws.lambda",
        "duration": 11364562400,
        "ingested": "2022-07-26T22:40:40Z",
        "module": "aws"
    },
    "metricset": {
        "name": "cloudwatch",
        "period": 300000
    },
    "service": {
        "type": "aws"
    }
}
```

**ECS Field Reference**

Please refer to the following [document](https://www.elastic.co/guide/en/ecs/current/ecs-field-reference.html) for detailed information on ECS fields.

**Exported fields**

| Field | Description | Type | Unit | Metric Type |
|---|---|---|---|---|
| @timestamp | Event timestamp. | date |  |  |
| agent.id | Unique identifier of this agent (if one exists). Example: For Beats this would be beat.id. | keyword |  |  |
| aws.cloudwatch.namespace | The namespace specified when query cloudwatch api. | keyword |  |  |
| aws.dimensions.EventSourceMappingUUID | The identifier of the event source mapping. | keyword |  |  |
| aws.dimensions.ExecutedVersion | Use the ExecutedVersion dimension to compare error rates for two versions of a function that are both targets of a weighted alias. | keyword |  |  |
| aws.dimensions.FunctionName | Lambda function name. | keyword |  |  |
| aws.dimensions.Resource | Resource name. | keyword |  |  |
| aws.lambda.metrics.AsyncEventAge.avg | The average time between when Lambda successfully queues the event and when the function is invoked. | long | ms | gauge |
| aws.lambda.metrics.AsyncEventsReceived.sum | The total number of events that Lambda successfully queues for processing. | long |  | gauge |
| aws.lambda.metrics.ConcurrentExecutions.avg | The average number of function instances that are processing events. | double |  | gauge |
| aws.lambda.metrics.DeadLetterErrors.avg | For asynchronous invocation, the average number of times Lambda attempts to send an event to a dead-letter queue but fails. | double |  | gauge |
| aws.lambda.metrics.DeadLetterErrors.sum | For asynchronous invocation, the total number of times Lambda attempts to send an event to a dead-letter queue but fails. | double |  | gauge |
| aws.lambda.metrics.DeletedEventCount.sum | The number of events that Lambda successfully deletes after processing. | double |  | gauge |
| aws.lambda.metrics.DestinationDeliveryFailures.avg | For asynchronous invocation, the average number of times Lambda attempts to send an event to a destination but fails. | double |  | gauge |
| aws.lambda.metrics.DestinationDeliveryFailures.sum | For asynchronous invocation, the total number of times Lambda attempts to send an event to a destination but fails. | double |  | gauge |
| aws.lambda.metrics.DroppedEventCount.sum | The number of events that Lambda dropped due to expiry or retry exhaustion. | double |  | gauge |
| aws.lambda.metrics.Duration.avg | The average amount of time that your function code spends processing an event. | double |  | gauge |
| aws.lambda.metrics.Errors.avg | The average number of invocations that result in a function error. | double |  | gauge |
| aws.lambda.metrics.Errors.sum | The total number of invocations that result in a function error. | double |  | gauge |
| aws.lambda.metrics.FailedInvokeEventCount.sum | The number of events that Lambda tried to invoke your function with, but failed. | double |  | gauge |
| aws.lambda.metrics.FilteredOutEventCount.sum | For event source mapping with a filter criteria, the number of events excluded based on the specified criteria. | double |  | gauge |
| aws.lambda.metrics.Invocations.avg | The average number of times your function code is executed, including successful executions and executions that result in a function error. | double |  | gauge |
| aws.lambda.metrics.Invocations.sum | The total number of times your function code is executed, including successful executions and executions that result in a function error. | double |  | gauge |
| aws.lambda.metrics.InvokedEventCount.sum | The number of events that invoked your Lambda function. Use this metric to verify that events are properly invoking your function. | double |  | gauge |
| aws.lambda.metrics.IteratorAge.avg | For event source mappings that read from streams, the average age of the last record in the event. | double |  | gauge |
| aws.lambda.metrics.OnFailureDestinationDeliveredEventCount.sum | For event source mappings with an on-failure destination configured, the number of events sent to that destination. | double |  | gauge |
| aws.lambda.metrics.PolledEventCount.sum | The number of events that Lambda reads successfully from the event source. | double |  | gauge |
| aws.lambda.metrics.ProvisionedConcurrencyInvocations.sum | The total number of times your function code is executed on provisioned concurrency. | long |  | gauge |
| aws.lambda.metrics.ProvisionedConcurrencySpilloverInvocations.sum | The total number of times your function code is executed on standard concurrency when all provisioned concurrency is in use. | long |  | gauge |
| aws.lambda.metrics.ProvisionedConcurrencyUtilization.max | For a version or alias, the maximum value of ProvisionedConcurrentExecutions divided by the total amount of provisioned concurrency allocated. | long |  | gauge |
| aws.lambda.metrics.ProvisionedConcurrentExecutions.max | The maximum number of function instances that are processing events on provisioned concurrency. | long |  | gauge |
| aws.lambda.metrics.Throttles.avg | The average number of invocation requests that are throttled. | double |  | gauge |
| aws.lambda.metrics.Throttles.sum | The total number of invocation requests that are throttled. | double |  | gauge |
| aws.lambda.metrics.UnreservedConcurrentExecutions.avg | For an AWS Region, the average number of events that are being processed by functions that don't have reserved concurrency. | double |  | gauge |
| aws.metrics_names_fingerprint | Autogenerated ID representing the fingerprint of the list of metrics names.  Applicable only for [Amazon Data Firehose integration](https://www.elastic.co/docs/current/integrations/awsfirehose). | keyword |  |  |
| aws.tags | Tag key value pairs from aws resources. | flattened |  |  |
| cloud.account.id | The cloud account or organization id used to identify different entities in a multi-tenant environment. Examples: AWS account id, Google Cloud ORG Id, or other unique identifier. | keyword |  |  |
| cloud.image.id | Image ID for the cloud instance. | keyword |  |  |
| cloud.region | Region in which this host, resource, or service is located. | keyword |  |  |
| data_stream.dataset | Data stream dataset. | constant_keyword |  |  |
| data_stream.namespace | Data stream namespace. | constant_keyword |  |  |
| data_stream.type | Data stream type. | constant_keyword |  |  |
| event.module | Event module | constant_keyword |  |  |
| host.containerized | If the host is a container. | boolean |  |  |
| host.os.build | OS build information. | keyword |  |  |
| host.os.codename | OS codename, if any. | keyword |  |  |


**Exported fields**

| Field | Description | Type |
|---|---|---|
| @timestamp | Event timestamp. | date |
| aws.cloudwatch.ingestion_time | AWS CloudWatch ingest time | date |
| aws.cloudwatch.log_group | AWS CloudWatch Log Group name | keyword |
| aws.cloudwatch.log_stream | AWS CloudWatch Log Stream name | keyword |
| aws.lambda.arn | The Amazon Resource Name (ARN) of the Lambda function. | keyword |
| aws.lambda.aws_request_id | The AWS request ID for the Lambda function invocation. | keyword |
| aws.lambda.cold_start | Indicates whether the Lambda function was invoked for the first time (cold start) or if it was a subsequent invocation (warm start). | boolean |
| aws.lambda.cold_start_int | The cold start indicator for the Lambda function invocation. | float |
| aws.lambda.correlation_id | The correlation ID for the Lambda function invocation. | keyword |
| aws.lambda.error.location | The location of the error. | keyword |
| aws.lambda.error.message | The error message. | keyword |
| aws.lambda.error.stack_trace | The stack trace of the error. | text |
| aws.lambda.error.type | The type of error. | keyword |
| aws.lambda.event_type | The type of event that triggered the Lambda function. | keyword |
| aws.lambda.execution_environment | The execution environment for the Lambda function. | keyword |
| aws.lambda.extension.events | The events associated with the Lambda extension. | keyword |
| aws.lambda.extension.name | The name of the Lambda extension. | keyword |
| aws.lambda.extension.state | The state of the Lambda extension. | keyword |
| aws.lambda.initialization_type | The type of initialization for the Lambda function. | keyword |
| aws.lambda.instance_id | The unique identifier for the Lambda function instance. | keyword |
| aws.lambda.log_extension.name | The name of the Lambda log extension. | keyword |
| aws.lambda.log_extension.state | The state of the Lambda log extension. | keyword |
| aws.lambda.log_extension.types | The types of logs associated with the Lambda log extension. | keyword |
| aws.lambda.log_stream_id | The unique identifier for the log stream. | keyword |
| aws.lambda.message |  | flattened |
| aws.lambda.metrics.billed_duration_ms | The billed duration of the Lambda function in milliseconds. | long |
| aws.lambda.metrics.dropped_bytes | The number of bytes dropped by the Lambda function. | long |
| aws.lambda.metrics.dropped_records | The number of records dropped by the Lambda function. | long |
| aws.lambda.metrics.duration_ms | The duration of the Lambda function in milliseconds. | long |
| aws.lambda.metrics.init_duration_ms | The initialization duration of the Lambda function in milliseconds. | long |
| aws.lambda.metrics.instance_max_memory | The maximum memory of the Lambda function instance. | long |
| aws.lambda.metrics.max_memory_used_mb | The maximum memory used by the Lambda function in megabytes. | long |
| aws.lambda.metrics.memory_size_mb | The memory size of the Lambda function in megabytes. | long |
| aws.lambda.metrics.produced_bytes | The number of bytes produced by the Lambda function. | long |
| aws.lambda.name | The name of the Lambda function. | keyword |
| aws.lambda.phase | The phase of the Lambda function invocation. | keyword |
| aws.lambda.request_id | The unique identifier for the Lambda function invocation. | keyword |
| aws.lambda.runtime_version | The runtime version of the Lambda function. | keyword |
| aws.lambda.runtime_version_arn | The ARN of the runtime version for the Lambda function. | keyword |
| aws.lambda.service.name | The name of the service. | keyword |
| aws.lambda.spans.durationMs | The duration of the span in milliseconds. | long |
| aws.lambda.spans.name | The name of the span. | keyword |
| aws.lambda.spans.start | The start time of the span. | date |
| aws.lambda.status |  | keyword |
| aws.lambda.trace_id | The trace ID for the Lambda function invocation. | keyword |
| aws.lambda.tracing.sampled | The sampling result for the traced requests. | keyword |
| aws.lambda.tracing.segment_id | XRAY segment ID for the traced requests. | keyword |
| aws.lambda.tracing.span_id | The trace ID for the Lambda function invocation. | keyword |
| aws.lambda.tracing.type | The type of tracing for the Lambda function invocation. | keyword |
| aws.lambda.tracing.value | The value of the tracing for the Lambda function invocation. | keyword |
| aws.lambda.tracing.xray_trace_id | The X-Ray trace ID for the Lambda function invocation. | keyword |
| aws.lambda.users |  | flattened |
| aws.lambda.version | The version of the Lambda function. | keyword |
| data_stream.dataset | Data stream dataset. | constant_keyword |
| data_stream.namespace | Data stream namespace. | constant_keyword |
| data_stream.type | Data stream type. | constant_keyword |
| event.dataset | Event dataset | constant_keyword |
| event.module | Event module | constant_keyword |
| input.type | Type of Filebeat input. | keyword |
