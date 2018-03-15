//package samples.jira;
import ballerina.io;
import src.jira;


public function main (string[] args) {

    if(lengthof(args)==0){
        io:println("Error: No argument found");
    }else if(args[0]=="Run All Examples") {
        runAllSamples();
    }else{
        io:println("Invalid Argument: "+args[0]);
    }
}







function runAllSamples(){
    endpoint<jira:JiraConnector> jiraConnector {
        create jira:JiraConnector();
    }

    jira:JiraConnectorError e;
    boolean result;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                         Samples - Jira Project                                                 //
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    //**************************************************************************************************************
    //Gets descriptions of all the existing jira projects
    io:println("\n\n");
    io:println("ACTION: getAllProjectSummaries()");
    var projects, e = jiraConnector.getAllProjectSummaries();

    io:println(projects);
    io:println(e);


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
        avatarId:10005,
        issueSecurityScheme:10000,
        permissionScheme:10075,
        notificationScheme:10086,
        categoryId:10000
    };
    io:println("\n\n");
    io:println("ACTION: createNewProject()");
    result, e = jiraConnector.createNewProject(newProject);
    io:println(result);
    io:println(e);


    //**************************************************************************************************************
    //Partially updates details of an existing project
    jira:ProjectRequest projectUpdate =
    {
        lead:"inshaf@wso2.com",
        projectTypeKey:"business"

    };
    io:println("\n\n");
    io:println("ACTION: updateProject()");
    result, e = jiraConnector.updateProject("TESTPROJECT",projectUpdate);
    io:println(result);
    io:println(e);


    //**************************************************************************************************************
    //Deletes an existing project from jira
    io:println("\n\n");
    io:println("ACTION: deleteProject()");
    result, e = jiraConnector.deleteProject("TESTPROJECT");
    io:println(result);
    io:println(e);


    //**************************************************************************************************************
    //Fetches jira Project details using project id (or project key)
    io:println("\n\n");
    io:println("ACTION: getProject()");
    var project, e = jiraConnector.getProject("10314");
    io:println(project);
    io:println(e);


    //**************************************************************************************************************
    //Get jira user details of project lead
    io:println("\n\n");
    io:println("BIND FUNCTION: project.getProjectLeadUserDetails()");
    var lead, e = project.getProjectLeadUserDetails();
    io:println(lead);
    io:println(e);


    //**************************************************************************************************************
    //View Current Developers assigned to the project.
    io:println("\n\n");
    io:println("BIND FUNCTION: project.getRoleDetails()");
    var developers, e = project.getRoleDetails(jira:ProjectRoleType.DEVELOPERS);
    io:println(developers);
    io:println(e);

    //**************************************************************************************************************
    //Add user "pasan@wso2.com" to "developers" role.
    io:println("\n\n");
    io:println("BIND FUNCTION: project.addUserToRole()");
    result, e = project.addUserToRole(jira:ProjectRoleType.EXTERNAL_CONSULTANT,"pasan@wso2.com");
    io:println(result);
    io:println(e);

    //**************************************************************************************************************
    //Add group "support.client.AAALIFEDEV.user" to "developers" role.
    io:println("\n\n");
    io:println("BIND FUNCTION: project.addGroupToRole()");
    result, e = project.addGroupToRole(jira:ProjectRoleType.EXTERNAL_CONSULTANT, "support.client.AAALIFEDEV.user");
    io:println(result);
    io:println(e);

    //**************************************************************************************************************
    //Remove user "pasan@wso2.com" from "developers" role.
    io:println("\n\n");
    io:println("BIND FUNCTION: project.removeUserFromRole()");
    result, e = project.removeUserFromRole(jira:ProjectRoleType.DEVELOPERS, "pasan@wso2.com");
    io:println(result);
    io:println(e);

    //**************************************************************************************************************
    //Remove group "support.client.AAALIFEDEV.user" from "developers" role.
    io:println("\n\n");
    io:println("BIND FUNCTION: project.removeGroupFromRole()");
    result, e = project.removeGroupFromRole(jira:ProjectRoleType.DEVELOPERS, "support.client.AAALIFEDEV.user");
    io:println(result);
    io:println(e);


    //**************************************************************************************************************
    //Gets all issue types with valid status values for a project
    io:println("\n\n");
    io:println("BIND FUNCTION: project.getAllIssueTypeStatuses()");
    var statuses, e = project.getAllIssueTypeStatuses();
    io:println(statuses);
    io:println(e);


    //**************************************************************************************************************
    //Updates the type of the project ("business" or "software")
    io:println("\n\n");
    io:println("BIND FUNCTION: project.changeProjectType()");
    result, e = project.changeProjectType(jira:ProjectType.SOFTWARE);
    io:println(result);
    io:println(e);


    //**************************************************************************************************************
    //get full details of a selected project component
    io:println("\n\n");
    io:println("BIND FUNCTION: componentSummary.getDetails()");
    var component, e = project.components[0].getAllDetails();
    io:println(component);
    io:println(e);


    //**************************************************************************************************************
    //expand jira user details of the lead
    io:println("\n\n");
    io:println("BIND FUNCTION: component.getLeadUserDetails()");
    var user, e = component.getLeadUserDetails();
    io:println(user);
    io:println(e);




    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////                                        Samples - Jira Project Category                                         //
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //gets information of all existing project categories
    io:println("\n\n");
    io:println("ACTION: getAllProjectCategories()");
    var categories, e =  jiraConnector.getAllProjectCategories();
    io:println(categories);
    io:println(e);


    //creates new jira project category
    io:println("\n\n");
    io:println("ACTION: createNewProjectCategory()");
    jira:NewProjectCategory newCategory = {name:"test-new category",description:"newCategory"};
    result, e =  jiraConnector.createNewProjectCategory(newCategory);
    io:println(result);
    io:println(e);


    //var pointer, e =  jiraConnector.deleteProjectCategory("10571");
    //io:println(pointer);
    //io:println(e);

}


function printSampleResponse(jira:JiraConnector e){
    if(e!=null){
        io:println();
    }


}