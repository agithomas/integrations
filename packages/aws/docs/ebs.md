# Amazon EBS

The Amazon EBS integration allows you to monitor [Amazon Elastic Block Store (EBS)](https://aws.amazon.com/ebs/)—a block-storage service designed for Amazon EC2.

Use the Amazon EBS integration to collect metrics related to your Amazon EBS storage.
Then visualize that data in Kibana, create alerts to notify you if something goes wrong, and reference metrics when troubleshooting an issue.

For example, you could use this integration to collect five-minute metrics on read operations, read bytes, and total read time. Then you can send an email alert if the volume of operations, bytes, or read time exceeds a predefined threshold.

**IMPORTANT: Extra AWS charges on API requests will be generated by this integration. Check [API Requests](https://www.elastic.co/docs/current/integrations/aws#api-requests) for more details.**

## Data streams

The Amazon EBS integration collects one type of data: metrics.

**Metrics** give you insight into the state of Amazon EBS.
The metrics collected by the Amazon EBS integration include read operations, read bytes, total read time, queue length, idle time, and more. See more details in the [Metrics reference](#metrics-reference)

## Requirements

You need Elasticsearch for storing and searching your data and Kibana for visualizing and managing it.
You can use our hosted Elasticsearch Service on Elastic Cloud, which is recommended, or self-manage the Elastic Stack on your own hardware.

Before using any AWS integration you will need:

* **AWS Credentials** to connect with your AWS account.
* **AWS Permissions** to make sure the user you're using to connect has permission to share the relevant data.

For more details about these requirements, please take a look at the [AWS integration documentation](https://docs.elastic.co/integrations/aws#requirements).

## Setup

Use this integration if you only need to collect data from Amazon EBS.

If you want to collect data from two or more AWS services, consider using the **AWS** integration.
When you configure the AWS integration, you can collect data from as many AWS services as you'd like.

For step-by-step instructions on how to set up an integration, see the
[Getting started](https://www.elastic.co/guide/en/starting-with-the-elasticsearch-platform-and-its-solutions/current/getting-started-observability.html) guide.

## Metrics reference

The `ebs` data stream collects EBS metrics from AWS.
An example event for `ebs` looks like this:

An example event for `ebs` looks as following:

```json
{
    "@timestamp": "2022-08-03T12:21:00.000Z",
    "agent": {
        "ephemeral_id": "2e8fed31-76b5-4efe-9893-947fd2346abd",
        "id": "618e6f72-9eef-4992-b60e-12515d538189",
        "name": "docker-fleet-agent",
        "type": "metricbeat",
        "version": "8.2.0"
    },
    "aws": {
        "cloudwatch": {
            "namespace": "AWS/EBS"
        },
        "dimensions": {
            "VolumeId": "vol-015d88f45122510a5"
        },
        "ebs": {
            "metrics": {
                "BurstBalance": {
                    "avg": 100
                },
                "VolumeIdleTime": {
                    "sum": 239.87
                },
                "VolumeQueueLength": {
                    "avg": 0
                },
                "VolumeReadOps": {
                    "avg": 0
                },
                "VolumeTotalWriteTime": {
                    "sum": 0.062
                },
                "VolumeWriteBytes": {
                    "avg": 5643.130434782609
                },
                "VolumeWriteOps": {
                    "avg": 23
                }
            }
        }
    },
    "cloud": {
        "provider": "aws",
        "region": "us-east-2"
    },
    "data_stream": {
        "dataset": "aws.ebs",
        "namespace": "default",
        "type": "metrics"
    },
    "ecs": {
        "version": "8.11.0"
    },
    "elastic_agent": {
        "id": "618e6f72-9eef-4992-b60e-12515d538189",
        "snapshot": false,
        "version": "8.2.0"
    },
    "event": {
        "agent_id_status": "verified",
        "dataset": "aws.ebs",
        "duration": 1320126957,
        "ingested": "2022-08-03T12:25:46Z",
        "module": "aws"
    },
    "host": {
        "architecture": "x86_64",
        "containerized": false,
        "hostname": "docker-fleet-agent",
        "ip": [
            "172.18.0.7"
        ],
        "mac": [
            "02-42-AC-12-00-07"
        ],
        "name": "docker-fleet-agent",
        "os": {
            "codename": "focal",
            "family": "debian",
            "kernel": "5.18.11-200.fc36.x86_64",
            "name": "Ubuntu",
            "platform": "ubuntu",
            "type": "linux",
            "version": "20.04.4 LTS (Focal Fossa)"
        }
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

| Field | Description | Type | Metric Type |
|---|---|---|---|
| @timestamp | Event timestamp. | date |  |
| agent.id | Unique identifier of this agent (if one exists). Example: For Beats this would be beat.id. | keyword |  |
| aws.cloudwatch.namespace | The namespace specified when query cloudwatch api. | keyword |  |
| aws.dimensions.VolumeId | Amazon EBS volume ID | keyword |  |
| aws.ebs.metrics.BurstBalance.avg | Used with General Purpose SSD (gp2), Throughput Optimized HDD (st1), and Cold HDD (sc1) volumes only. Provides information about the percentage of I/O credits (for gp2) or throughput credits (for st1 and sc1) remaining in the burst bucket. | double | gauge |
| aws.ebs.metrics.VolumeConsumedReadWriteOps.avg | The total amount of read and write operations (normalized to 256K capacity units) consumed in a specified period of time. Used with Provisioned IOPS SSD volumes only. | double | gauge |
| aws.ebs.metrics.VolumeIdleTime.sum | The total number of seconds in a specified period of time when no read or write operations were submitted. | double | gauge |
| aws.ebs.metrics.VolumeQueueLength.avg | The number of read and write operation requests waiting to be completed in a specified period of time. | double | gauge |
| aws.ebs.metrics.VolumeReadBytes.avg | Average size of each read operation during the period, except on volumes attached to a Nitro-based instance, where the average represents the average over the specified period. | double | gauge |
| aws.ebs.metrics.VolumeReadOps.avg | The total number of read operations in a specified period of time. | double | gauge |
| aws.ebs.metrics.VolumeThroughputPercentage.avg | The percentage of I/O operations per second (IOPS) delivered of the total IOPS provisioned for an Amazon EBS volume. Used with Provisioned IOPS SSD volumes only. | double | gauge |
| aws.ebs.metrics.VolumeTotalReadTime.sum | The total number of seconds spent by all read operations that completed in a specified period of time. | double | gauge |
| aws.ebs.metrics.VolumeTotalWriteTime.sum | The total number of seconds spent by all write operations that completed in a specified period of time. | double | gauge |
| aws.ebs.metrics.VolumeWriteBytes.avg | Average size of each write operation during the period, except on volumes attached to a Nitro-based instance, where the average represents the average over the specified period. | double | gauge |
| aws.ebs.metrics.VolumeWriteOps.avg | The total number of write operations in a specified period of time. | double | gauge |
| aws.metrics_names_fingerprint | Autogenerated ID representing the fingerprint of the list of metrics names.  Applicable only for [Amazon Data Firehose integration](https://www.elastic.co/docs/current/integrations/awsfirehose). | keyword |  |
| aws.s3.bucket.name | Name of a S3 bucket. | keyword |  |
| aws.tags | Tag key value pairs from aws resources. | flattened |  |
| cloud.account.id | The cloud account or organization id used to identify different entities in a multi-tenant environment. Examples: AWS account id, Google Cloud ORG Id, or other unique identifier. | keyword |  |
| cloud.image.id | Image ID for the cloud instance. | keyword |  |
| cloud.region | Region in which this host, resource, or service is located. | keyword |  |
| data_stream.dataset | Data stream dataset. | constant_keyword |  |
| data_stream.namespace | Data stream namespace. | constant_keyword |  |
| data_stream.type | Data stream type. | constant_keyword |  |
| event.module | Event module | constant_keyword |  |
| host.containerized | If the host is a container. | boolean |  |
| host.os.build | OS build information. | keyword |  |
| host.os.codename | OS codename, if any. | keyword |  |
