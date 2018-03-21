import ballerina.io;
import src.jira;
import ballerina.net.http;
import ballerina.mime;
import ballerina.config;
import ballerina.log;

public function main (string[] args) {

    runAllSamples();

}

function runAllSamples () {

    jira:JiraConnectorError e;
    boolean result;
    boolean isValid;
    jira:JiraConnector jiraConnector = {};

    io:println("started running samples..\n");

    //**************************************************************************************************************
    //Validates provided user credentials
    io:println("\n\n");
    io:println("validating user credentials..");
    isValid, e = jiraConnector.authenticate("ashan@wso2.com","ashan123");
    printSampleResponse(e);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////                                          Samples - Jira Project                                                  //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //**************************************************************************************************************
    //Gets descriptions of all the existing jira projects
    io:println("\n\n");
    io:println("BIND FUNCTION: getAllProjectSummaries()");
    var projects, e = jiraConnector.getAllProjectSummaries();
    printSampleResponse(e);


    //**************************************************************************************************************
    //Gets detailed representation using a project summary object.
    io:println("\n\n");
    io:println("BIND FUNCTION: projectSummary.getAllDetails()");
    jira:Project project;
    try {
       project, e = projects[0].getAllDetails();
        printSampleResponse(e);
    }
    catch(error err){

    }



    //**************************************************************************************************************
    //Creates new a project named "Test Project - Production Support"

    jira:ProjectRequest newProject =
    {
        key:"TESTPROJECT",
        name:"Test Project - Production Support",
        projectTypeKey:"software",
        projectTemplateKey:"com.pyxis.greenhopper.jira:basic-software-development-template",
        description:"Example Project description",
        lead:"pasan@wso2.com",
        url:"http://atlassian.com",
        assigneeType:"PROJECT_LEAD",
        avatarId:"10005",
        issueSecurityScheme:"10000",
        permissionScheme:"10075",
        notificationScheme:"10086",
        categoryId:"10000"
    };
    io:println("\n\n");
    io:println("BIND FUNCTION: createProject()");
    result, e = jiraConnector.createProject(newProject);
    printSampleResponse(e);


    //**************************************************************************************************************
    //Partially updates details of an existing project
    jira:ProjectRequest projectUpdate =
    {
        lead:"inshaf@wso2.com",
        projectTypeKey:"business"

    };
    io:println("\n\n");
    io:println("BIND FUNCTION: updateProject()");
    result, e = jiraConnector.updateProject("TESTPROJECT", projectUpdate);
    printSampleResponse(e);


    //**************************************************************************************************************
    //Deletes an existing project from jira
    io:println("\n\n");
    io:println("BIND FUNCTION: deleteProject()");
    result, e = jiraConnector.deleteProject("TESTPROJECT");
    printSampleResponse(e);


    //**************************************************************************************************************
    //Fetches jira Project details using project id (or project key)
    io:println("\n\n");
    io:println("BIND FUNCTION: getProject()");
    project, e = jiraConnector.getProject("10314");
    io:println(project);
    printSampleResponse(e);


    //**************************************************************************************************************
    //Get jira user details of project lead
    io:println("\n\n");
    io:println("BIND FUNCTION: project.getProjectLeadUserDetails()");
    var lead, e = project.getProjectLeadUserDetails();
    printSampleResponse(e);


    //**************************************************************************************************************
    //View Current Developers assigned to the project.
    io:println("\n\n");
    io:println("BIND FUNCTION: project.getRoleDetails()");
    var developers, e = project.getRoleDetails(jira:ProjectRoleType.DEVELOPERS);
    printSampleResponse(e);

    //**************************************************************************************************************
    //Add user "pasan@wso2.com" to "developers" role.
    io:println("\n\n");
    io:println("BIND FUNCTION: project.addUserToRole()");
    result, e = project.addUserToRole(jira:ProjectRoleType.EXTERNAL_CONSULTANT, "pasan@wso2.com");
    printSampleResponse(e);

    //**************************************************************************************************************
    //Add group "support.client.AAALIFEDEV.user" to "developers" role.
    io:println("\n\n");
    io:println("BIND FUNCTION: project.addGroupToRole()");
    result, e = project.addGroupToRole(jira:ProjectRoleType.EXTERNAL_CONSULTANT, "support.client.AAALIFEDEV.user");
    printSampleResponse(e);

    //**************************************************************************************************************
    //Remove user "pasan@wso2.com" from "developers" role.
    io:println("\n\n");
    io:println("BIND FUNCTION: project.removeUserFromRole()");
    result, e = project.removeUserFromRole(jira:ProjectRoleType.DEVELOPERS, "pasan@wso2.com");
    printSampleResponse(e);

    //**************************************************************************************************************
    //Remove group "support.client.AAALIFEDEV.user" from "developers" role.
    io:println("\n\n");
    io:println("BIND FUNCTION: project.removeGroupFromRole()");
    result, e = project.removeGroupFromRole(jira:ProjectRoleType.DEVELOPERS, "support.client.AAALIFEDEV.user");
    printSampleResponse(e);


    //**************************************************************************************************************
    //Gets all issue types with valid status values for a project
    io:println("\n\n");
    io:println("BIND FUNCTION: project.getAllIssueTypeStatuses()");
    var statuses, e = project.getAllIssueTypeStatuses();
    printSampleResponse(e);

    //**************************************************************************************************************
    //Updates the type of the project ("business" or "software")
    io:println("\n\n");
    io:println("BIND FUNCTION: project.changeProjectType()");
    result, e = project.changeProjectType(jira:ProjectType.SOFTWARE);
    printSampleResponse(e);

    //**************************************************************************************************************
    //get full details of a selected project component
    io:println("\n\n");
    io:println("BIND FUNCTION: componentSummary.getDetails()");
    var component, e = project.components[0].getAllDetails();
    printSampleResponse(e);


    //**************************************************************************************************************
    //expand jira user details of the lead
    io:println("\n\n");
    io:println("BIND FUNCTION: component.getLeadUserDetails()");
    var user, e = component.getLeadUserDetails();
    printSampleResponse(e);




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////                                          Samples - Jira Project Category                                         //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //gets information of all existing project categories
    io:println("\n\n");
    io:println("BIND FUNCTION: getAllProjectCategories()");
    var categories, e = jiraConnector.getAllProjectCategories();
    printSampleResponse(e);


    //creates new jira project category
    io:println("\n\n");
    io:println("BIND FUNCTION: createProjectCategory()");
    jira:ProjectCategoryRequest newCategory = {name:"test-new category", description:"newCategory"};
    result, e = jiraConnector.createProjectCategory(newCategory);
    printSampleResponse(e);


    //var pointer, e =  jiraConnector.deleteProjectCategory("10571");
    //io:println(pointer);
    //io:println(e);

}


function printSampleResponse (jira:JiraConnectorError e) {
    if (e == null) {
        io:println("Successfull");
    } else {
        io:println("Failed");
        io:println(e);
    }
}

