Connects to JIRA from Ballerina. 

# Package Overview

The JIRA connector allows you to view, create, update, and delete projects, project categories, project components, user 
accounts, and issues through the JIRA REST API. It handles basic authentication.

**JIRA Project Operations**

The `wso2/jira` package contains operations to create new JIRA projects, update or delete existing projects, and get all 
the information using either the ID or key of the project. It also contains operations for adding or removing users and 
groups related to a project role, viewing user account details of the project lead, viewing assignable issue types for a 
given project, etc.

**JIRA Project Category Operations**

The `wso2/jira` package contains operations that get all available project categories, delete existing categories, and 
create new project categories.

**JIRA Project Component Operations**

The `wso2/jira` package contains operations that get all details of a given project component, delete existing 
components, create a new project component related to a specific project, etc.

**JIRA Issue Operations**

The `wso2/jira` package contains operations that get all the details of a given issue using the issue key, delete existing 
issues, create new issues, etc.

## Compatibility
|                    |    Version     |  
|:------------------:|:--------------:|
| Ballerina Language |    0.981.1     |
| JIRA REST API      |    7.2.2       |  

## Sample
First, import the `wso2/jira7` package into the Ballerina project.
```ballerina
import wso2/jira7;
```
**Obtaining Credentials to Run the Sample**

1. Visit [Atlassian](https://id.atlassian.com/signup) and create an Atlassian Account.
2. Obtain the following credentials and base URL.
    * Username
    * Password  

You can now enter the credentials in the HTTP client config.
```ballerina
endpoint jira7:Client jiraEP {
    clientConfig:{
        url:baseUrl
        auth:{
            scheme:http:BASIC_AUTH,
            username:username,
            password:password
        }
    }
};
```
The `getAllProjectSummaries` function returns the project summary of all the projects.
```ballerina
var output = jiraEP->getAllProjectSummaries();
match output {
    jira7:ProjectSummary[] projectSummaryArray => io:println(projectSummaryArray);
    jira7:JiraConnectorError e => io:println(e);
}
```
The `createProject` function creates a JIRA project with the given name.
```ballerina
var output = jiraEP->createProject("TST_PROJECT");
match output {
    jira7:Project p => io:println(p);
    jira7:JiraConnectorError e => io:println(e);
}
```
The `createIssue` function creates an issue with the given issue details. `IssueRequest` is a structure that contains all 
the data that is required to create the issue. 
```ballerina
jira7:IssueRequest newIssue = {
    key: "TEST_ISSUE",
    summary: "This is a test issue created for the Ballerina JIRA Connector",
    issueTypeId: "10002",
    projectId: ”1234”,
    assigneeName: “username”
};
var output = jiraEP->createIssue(newIssue);
match output {
    jira7:Issue issue => io:println(issue);
    jira7:JiraConnectorError e => io:println(e);
}
```