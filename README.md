[![Build Status](https://travis-ci.org/wso2-ballerina/package-jira.svg?branch=master)](https://travis-ci.org/wso2-ballerina/package-jira)

# Ballerina JIRA Connector
This Ballerina client connector allows to connect to Atlassian JIRA, which provides bug tracking, issue tracking, 
and project management functions. It uses the JIRA REST API to connect to JIRA, work with JIRA 
projects, view and update issues, work with jira user accounts, and more. It also handles basic authentication, 
provides auto completion and type conversions.

![Overview](docs/resources/Overview.png)

### Compatibility

| Ballerina Version   | JIRA REST API Version |
|:-------------------:|:---------------------:|
| 0.981.1             | 7.2.2                  |


### Why do you need the REST API for JIRA

The JIRA REST API is an ideal solution for the developers who want to integrate JIRA with other standalone or web applications, 
and administrators who want to script interactions with the JIRA server. Because the JIRA REST API is based on open 
standards, you can use any web development language to access the API.


The following sections provide information on how to use Ballerina JIRA Connector.

- [Getting started](#getting-started)
- [Authentication](#authentication)
- [Working with JIRA Connector Actions](#working-with-jira-connector-actions)


## Getting started

- Refer `https://ballerina.io/learn/getting-started/` to download Ballerina and install tools.

- Create a new Ballerina project by executing the following command.
  
  `<PROJECT_ROOT_DIRECTORY>$ ballerina init`
  
- Import the jira package to your Ballerina program as follows.This will download the jira7 artifacts from the 
`ballerina central` to your local repository.

```ballerina
   import wso2/jira7;
```

## Authentication

> **Note -** 
*JIRA’s REST API is protected by the same restrictions which are provided via JIRAs standard web interface.
This means that if you do not have valid jira credentials, you are accessing JIRA anonymously. Furthermore, 
if you log in and do not have permission to view something in JIRA, you will not be able to view it using the 
Ballerina JIRA Connector as well.*

Ballerina JIRA connector currently provides basic authentication as the authentication method.  
Please follow the following steps to authenticate your connector.
     
- Obtain your JIRA user account credentials(username and password).
  If you currently dont have a JIRA account, you can create a new JIRA account from 
  [JIRA Sign-Up Page](https://id.atlassian.com/signup?application=mac&tenant=&continue=https%3A%2F%2Fmy.atlassian.com).

- Provide the credentials to your endpoint in the initialization step, as shown 
in the following sample code.

```ballerina
import ballerina/http;
import wso2/jira7;

//Creation of connector endpoint
endpoint jira7:Client jiraEndpoint {
    clientConfig:{
        url:"https://support-staging.wso2.com/jira",
        auth:{
            scheme:http:BASIC_AUTH,
            username:"username",
            password:"password"
        }
    }
};
```

## Working with JIRA connector actions

All actions of JIRA Connector are **single-return type actions**, which will returns either response or an error.
Response can be either a `ballerina record` or a boolean value,depending on the context.
Error response is also a ballerina record of type`JiraConnectorError`. 

If a action was successfull, then the requested struct object or boolean `true` response will be returned or otherwise 
will returns an Connector error with error message,error type and cause.

### Example
* Request 
```ballerina
import ballerina/http;
import wso2/jira7;

function main(string... args) {

    //Creating the jira endpoint
    endpoint jira7:Client jiraEndpoint {
        clientConfig:{
            url:"https://support-staging.wso2.com/jira",
            auth:{
                scheme:http:BASIC_AUTH,
                username:"username",
                password:"password"
            }
        }
    };

    jira7:JiraConnectorError jiraError = {};
    jira7:Project project = {};
    string projectKey = "RRDEVSPRT";

    //Endpoint Action
    var result = jiraEndpoint -> getProject(projectKey);
    match result{
        jira7:Project p => project = p;
        jira7:JiraConnectorError e => jiraError = err;
    }
}
```

* Response Object
```ballerina
public type Project record {
    string self;
    string id;
    string key;
    string name;
    string description;
    string leadName;
    string projectTypeKey;
    AvatarUrls avatarUrls;
    ProjectCategory projectCategory;
    IssueType[] issueTypes;
    ProjectComponentSummary[] components;
    ProjectVersion[] versions;
}
```

* Error Object
```ballerina
public type JiraConnectorError record {
    string message;
    error? cause;
    string ^"type";
    json jiraServerErrorLog;   
}
```

Now that you have basic knowledge about to how Ballerina JIRA endpoint works, 
use the information in the following sections to perform various operations with the endpoint.

- [Working with Projects in JIRA](#working-with-projects-in-jira)

- [Working with Project Categories in JIRA](#working-with-project-categories-in-jira)

- [Working with Project Components in JIRA](#working-with-project-components-in-jira)

- [Working with Issues in JIRA](#working-with-issues-in-jira)


***
### Working with Projects in JIRA
***
#### API Reference
- getAllProjectSummaries()
- getAllDetailsFromProjectSummary()
- getProject()
- createProject()
- updateProject()
- deleteProject()
- getLeadUserDetailsOfProject()
- getRoleDetailsOfProject()
- addUserToRoleOfProject()
- addGroupToRoleOfProject()
- removeUserFromRoleOfProject()
- removeGroupFromRoleOfProject()
- getAllIssueTypeStatusesOfProject()
- changeTypeOfProject()

***
### Working with Project Categories in JIRA
***
#### API Reference
- getAllProjectCategories()
- createProjectCategory()
- getProjectCategory()
- deleteProjectCategory()

***
### Working with Project Components in JIRA
***
#### API Reference
- createProjectComponent()
- getProjectComponent()
- deleteProjectComponent()
- getAssigneeUserDetailsOfProjectComponent()
- getLeadUserDetailsOfProjectComponent()

***
### Working with Issues in JIRA
***
#### API Reference
- createIssue()
- updateIssue()
- deleteIssue()
