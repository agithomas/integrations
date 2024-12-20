# Azure Functions

The Azure Functions integration allows you to monitor Azure Functions. Azure Functions is an event-driven, serverless compute platform that helps you develop more efficiently using the programming language of your choice. Triggers cause a function to run. A trigger defines how a function is invoked and a function must have exactly one trigger. 

Use Azure Functions to build web APIs, respond to database changes, process IoT streams, manage message queues, and more. Refer common [Azure Functions scenarios](https://learn.microsoft.com/en-us/azure/azure-functions/functions-scenarios?pivots=programming-language-csharp) for more information.

## Hosting plans and metrics

Each Azure Functions app requires a hosting plan: Consumption plan, Flex Consumption plan, Premium plan, Dedicated plan, or Container Apps. For more details on the various plans, check the [Azure Functions hosting options](https://learn.microsoft.com/en-us/azure/azure-functions/functions-scale?WT.mc_id=Portal-WebsitesExtension).

These plans differ from eachother in the number of metrics they generate, which are then exported outside of Azure for other monitoring solutions like Elastic Observability. For example, metrics specific to Azure Function Apps, such as 'FunctionExecutionCount' and 'FunctionExecutionUnits', are only available for function apps operating on a Consumption (serverless) plan and are not observed in other plans. On the other hand, all other metrics are generated exclusively for Premium and Dedicated plans and are not available for the Consumption plan.

## Data streams
The Azure Functions integration contains two data streams: [Function App Logs](#logs) and [Metrics](#metrics)

### Logs

Supported log categories:

| Log Category                 | Description                                                                                                                          |
|:----------------------------:|:------------------------------------------------------------------------------------------------------------------------------------:|
| Functionapplogs | Function app logs.        |


#### Requirements and setup

Refer to the [Azure Logs](https://docs.elastic.co/integrations/azure) page for more information about setting up and using this integration.

#### Configuration options
`eventhub` :
  _string_
An Event Hub is a fully managed, real-time data ingestion service. Elastic recommends using only letters, numbers, and the hyphen (-) character for Event Hub names to maximize compatibility. You can use existing Event Hubs having underscores (_) in the Event Hub name; in this case, the integration will replace underscores with hyphens (-) when it uses the Event Hub name to create dependent Azure resources behind the scenes (e.g., the storage account container to store Event Hub consumer offsets). Elastic also recommends using a separate event hub for each log type as the field mappings of each log type differ.
Default value `insights-operational-logs`.

`consumer_group` :
_string_
 The publish/subscribe mechanism of Event Hubs is enabled through consumer groups. A consumer group is a view (state, position, or offset) of an entire event hub. Consumer groups enable multiple consuming applications to each have a separate view of the event stream, and to read the stream independently at their own pace and with their own offsets.
Default value: `$Default`

`connection_string` :
_string_
The connection string is required to communicate with Event Hubs, see steps [here](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-get-connection-string).

A Blob Storage account is required in order to store/retrieve/update the offset or state of the eventhub messages. This means that after stopping the Azure logs package it can start back up at the spot that it stopped processing messages.

`storage_account` :
_string_
The name of the storage account where the state/offsets will be stored and updated.

`storage_account_key` :
_string_
The storage account key, this key will be used to authorize access to data in your storage account.

`storage_account_container` :
_string_
The storage account container where the integration stores the checkpoint data for the consumer group. It is an advanced option to use with extreme care. You MUST use a dedicated storage account container for each Azure log type (activity, sign-in, audit logs, and others). DO NOT REUSE the same container name for more than one Azure log type. See [Container Names](https://docs.microsoft.com/en-us/rest/api/storageservices/naming-and-referencing-containers--blobs--and-metadata#container-names) for details on naming rules from Microsoft. The integration generates a default container name if not specified.

`resource_manager_endpoint` :
_string_
Optional, by default we are using the Azure public environment, to override, users can provide a specific resource manager endpoint in order to use a different Azure environment.

Resource manager endpoints:

```text
# Azure ChinaCloud
https://management.chinacloudapi.cn/

# Azure GermanCloud
https://management.microsoftazure.de/

# Azure PublicCloud 
https://management.azure.com/

# Azure USGovernmentCloud
https://management.usgovcloudapi.net/
```

{{event "functionapplogs"}}

**ECS Field Reference**

Please refer to the following [document](https://www.elastic.co/guide/en/ecs/current/ecs-field-reference.html) for detailed information on ECS fields.

{{fields "functionapplogs"}}

### Metrics
**Metrics** give you insight into the performance of your Azure Function Apps. The integration includes an out-of-the-box dashboard for visualising the monitoring data generated by apps hosted in Azure Functions.

#### Requirements

To use this integration you will need:

* **Azure App Registration**: You need to set up an Azure App Registration to allow the Agent to access the Azure APIs. The App Registration requires the Monitoring Reader role to access to be able to collect metrics from Function Apps. See more details in the Setup section.
* **Elasticsearch and Kibana**: You need Elasticsearch to store and search your data and Kibana to visualize and manage it. You can use our hosted Elasticsearch Service on Elastic Cloud, which is recommended, the [Native Azure Integration](https://azuremarketplace.microsoft.com/en/marketplace/apps/elastic.ec-azure-pp?tab=overview), or self-manage the Elastic Stack on your hardware.

#### Setup


```text
         ┌────────────────────┐       ┌─────────┐       ┌─-─────────────────────┐
         │                    │       │         │       │    azure.functions    │
         │     Azure APIs     │──────▶│  Agent  │──────▶│    <<data stream>>    │
         │                    │       │         │       │                       │
         └────────────────────┘       └─────────┘       └───-───────────────────┘                                              
```

Elastic Agent needs an App Registration to access Azure on your behalf to collect data using the Azure REST APIs. App Registrations are required to access Azure APIs programmatically.

To start collecting data with this integration, you need to:

* Set up a new Azure app registration by registering an app, adding credentials, and assigning an appropriate role.
* Specify integration [settings](#main-options) in Kibana, which will determine how the integration will access the Azure APIs.

#### Register a new app

To create a new app registration:

1. Sign in to the [Azure Portal](https://portal.azure.com/).
2. Search for and select **Microsoft Entra ID**.
3. Under **Manage**, select **App registrations** > **New registration**.
4. Enter a display _Name_ for your application (for example, "elastic-agent").
5. Specify who can use the application.
6. Don't enter anything for _Redirect URI_. This is optional and the agent doesn't use it.
7. Select **Register** to complete the initial app registration.

Take note of the **Application (client) ID**, which you will use later when specifying the **Client ID** in the integration settings.

#### Add credentials

Credentials allow your application to access Azure APIs and authenticate itself, requiring no interaction from a user at runtime.

This integration uses Client Secrets to prove its identity.

1. In the [Azure Portal](https://portal.azure.com/), select the application you created in the previous section.
2. Select **Certificates & secrets** > **Client secrets** > **New client secret**.
3. Add a description (for example, "Elastic Agent client secrets").
4. Select an expiration for the secret or specify a custom lifetime.
5. Select **Add**.

Take note of the content in the **Value** column in the **Client secrets** table, which you will use later when specifying a **Client Secret** in the integration settings. **This secret value is never displayed again after you leave this page.** Record the secret's value in a safe place.

#### Assign role

1. In the [Azure Portal](https://portal.azure.com/), search for and select **Subscriptions**.
2. Select the subscription to assign the application.
3. Select **Access control (IAM)**.
4. Select **Add** > **Add role assignment** to open the _Add role assignment page_.
5. In the **Role** tab, search and select the role **Monitoring Reader**.
6. Select the **Next** button to move to the **Members** tab.
7. Select **Assign access to** > **User, group, or service principal**, and select **Select members**. This page does not display Azure AD applications in the available options by default.
8. To find your application, search by name (for example, "elastic-agent") and select it from the list.
9. Click the **Select** button.
10. Then click the **Review + assign** button.

Take note of the following values, which you will use later when specifying settings.

* `Subscription ID`: use the content of the "Subscription ID" you selected.
* `Tenant ID`: use the "Tenant ID" from the Azure Active Directory you use.

Your App Registration is now ready to be used with the Elastic Agent.

#### Additional Resources

If you want to learn more about this process, you can read these two general guides from Microsoft:

* [Quickstart: Register an application with the Microsoft identity platform](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app) 
* [Use the portal to create an Azure AD application and service principal that can access resources](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal)

#### Main options

The settings' main section contains all the options needed to access the Azure APIs and collect the Azure Functions metrics data. You will now use all the values from [App registration](#register-a-new-app) including:

`Client ID` _string_
: The unique identifier of the App Registration (sometimes referred to as Application ID).

`Client Secret` _string_
: The client secret for authentication.

`Subscription ID` _string_
: The unique identifier for the Azure subscription. You can provide just one subscription ID. The Agent uses this ID to access Azure APIs. 

`Tenant ID` _string_
: The unique identifier of the Azure Active Directory's Tenant ID.

#### Advanced options

There are two additional advanced options:

`Resource Manager Endpoint` _string_
: Optional. By default, the integration uses the Azure public environment. To override, users can provide a specific resource manager endpoint to use a different Azure environment.

Examples:

* `https://management.chinacloudapi.cn` for Azure ChinaCloud
* `https://management.microsoftazure.de` for Azure GermanCloud
* `https://management.azure.com` for Azure PublicCloud
* `https://management.usgovcloudapi.net` for Azure USGovernmentCloud

`Active Directory Endpoint`  _string_
: Optional. By default, the integration uses the associated Active Directory Endpoint. To override, users can provide a specific active directory endpoint to use a different Azure environment.

Examples:

* `https://login.chinacloudapi.cn` for Azure ChinaCloud
* `https://login.microsoftonline.de` for Azure GermanCloud
* `https://login.microsoftonline.com` for Azure PublicCloud
* `https://login.microsoftonline.us` for Azure USGovernmentCloud

#### Metrics Reference

{{event "metrics"}}

**ECS Field Reference**

Please refer to the following [document](https://www.elastic.co/guide/en/ecs/current/ecs-field-reference.html) for detailed information on ECS fields.

{{fields "metrics"}}
