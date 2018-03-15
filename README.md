# Ballerina Jira Connector


This Ballerina client connector allows to connect to [Atlassian JIRA](https://www.jira.com), an online issue-tracking database. It provides bug tracking, 
issue tracking, and project management functions.
The connector uses the [JIRA REST API version 7.2.2](https://docs.atlassian.com/software/jira/docs/api/REST/7.2.2/) to connect to JIRA, work with JIRA projects, 
view and update issues, work with jira user accounts, and more.

![Atlassian Jira](jira_logo.png)



### Why do you need the REST API for Jira

The Jira REST API is an ideal solution for the developers who want to integrate JIRA with other standalone or web applications, 
and administrators who want to script interactions with the JIRA server. Because the Jira REST API is based on open 
standards, you can use any web development language to access the API.

### Why would you use a Ballerina Connector for Jira

The following sections provide information on how to use Ballerina Jira connector.

- [Getting started](#getting-started)
- [Running Samples](#running-samples)
- [Working with Jira Connector](#working-with-jira-connector-actions)



### Getting started
***

- Install the ballerina version 0.964.0 distribution from [Ballerina Download Page](https://ballerinalang.org/downloads/).

- Clone the repository by running the following command
 ```
    git clone https://github.com/NipunaRanasinghe/connector-jira
 ```
 
- Import the package as a ballerina project.



- Provide your Jira user account credentials using the following steps.(If you currently dont have a Jira account, 
you can create a new Jira account from [JIRA Sign up page](https://id.atlassian.com/signup?application=mac&tenant=&continue=https%3A%2F%2Fmy.atlassian.com).
    1. Build a string of the form "username:password"
    2. Base64 encode the string
    3. Navigate to the "Package_Jira/ballerina.conf" configuration file and place the encoded string under the "base64_encoded_string" field
        
        i.e: `base64_encoded_string=YXNoYW5Ad3NvMi5jb206YXNoYW`



## Running Samples

You can easily test the following actions using the `sample.bal` file.

1. Navigate to the `sample.bal` located in the folder `Package_Jira/samples/jira/ ` .
2. Run the following commands to execute the sample.
    `jira$ ballerina run sample.bal "Run All Samples"

## Working with Jira connector actions

Ballerina Jira connector basically provides two types of functionalities which are, Connector-bound
and entity-bound actions

####Connector-bound Actions
Connector-bound actions provide generic functionalities

##### Example


####Entity-bound Actions
Entity-bound actions are special set of actions which are specified on a Jira Entity (Eg: Jira Project,Jira Issue etc.)

##### Example


Now that you have basic knowledge about to how Ballerina Jira connector works, 
use the information in the following topics to perform various operations with the connector.
nector](#working-with-jira-connector-actions)