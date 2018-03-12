package samples.wso2.jira;

//import ballerina.net.http;
//import src.wso2.jira.models;
import ballerina.io;
import src.wso2.jira;
//import src.wso2.jira.utils.constants;
//import src.wso2.jira.connectors;


public function main (string[] args) {




    endpoint<jira:JiraConnector> jiraConnector {
        create jira:JiraConnector(jira:AuthenticationType.BASIC);
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Test - Jira Project
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    jira:JiraConnectorError e;
    boolean result;

    //var role,e = jiraConnector.getProjectRole("10314",constants:ROLE_ID_DEVELOPERS);
    //io:println(role.description);
    //io:println(e);
    //
    //var project, e =  jiraConnector.getProjectSummary("10314");
    //io:println(project);
    //io:println(e);


    var projects, e = jiraConnector.getAllProjectSummaries();
    io:println(projects);
    io:println(e);


    //Creates new a project named "Test Project - Production Support"
    jira:NewProject newProject =
    {
        key:"TEST-PROJECT",
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

    result, e = jiraConnector.createNewProject(newProject);
    io:println(pointer);
    io:println(e);


    result, e = jiraConnector.createNewProject(newProject);
    io:println(pointer);
    io:println(e);



    //Fetch jira Project using Id
    var project, e = jiraConnector.getProject("10017");
    io:println(project);
    io:println(e);

    //Get jira user details of project lead
    var lead, e = project.getProjectLeadUserDetails();
    io:println(lead);
    io:println(e);

    //View Current Developers assigned to the project.
    var developers, e = project.getRole(jira:ProjectRoleType.DEVELOPERS);
    io:println(developers);
    io:println(e);

    //Add new group(actor) "support.client.AAALIFEDEV.user" to the the current developers role.
    jira:NewActor newActor = {name:"support.client.AAALIFEDEV.user", |type|:jira:ActorType.GROUP};
    result, e = project.addActorToRole(jira:ProjectRoleType.EXTERNAL_CONSULTANT, newActor);
    io:println(result);
    io:println(e);

    //Remove group "support.client.AAALIFEDEV.user" from the the current developers role.
    result, e = project.removeActorFromRole(jira:ProjectRoleType.DEVELOPERS, "support.client.AAALIFEDEV.user", jira:ActorType.GROUP);
    io:println(result);
    io:println(e);

    //Gets all issue types with valid status values for a project
    var statuses, e = project.getAllStatuses();
    io:println(statuses);
    io:println(e);

    //Updates the type of the project ("business" or "software")
    result, e = project.updateProjectType(jira:ProjectType.SOFTWARE);
    io:println(result);
    io:println(e);

    //get full details of a selected project component
    var component, e = project.components[0].expandComponent();
    io:println(component);
    io:println(e);

    //expand jira user details of the lead
    var user, e = component.getLeadUserDetails();
    io:println(user);
    io:println(e);



    result, e = project.updateProjectType(jira:ProjectType.SOFTWARE);
    io:println(pointer2);
    io:println(e);




    result, e = project.updateProjectType(jira:ProjectType.SOFTWARE);
    io:println(result);
    io:println(e);



    var pointers, e = jiraConnector.getAllProjectSummaries();
    //io:println(pointer);
    io:println(pointers);
    io:println(e);




    //var pointer, e =  jiraConnector.getProjectStatuses("10314");
    //io:println(pointer[0]);
    //io:println(e);

    //jira:SetActor newActor = {name:"support.client.AAALIFEDEV.user",|type|:jira:ActorType.GROUP};
    //var pointer, e =  jiraConnector.addActorToProject("10314",constants:ROLE_ID_DEVELOPERS,newActor);
    //io:println(pointer);
    //io:println(e);


    //jira:SetProjectCategory newCategory = {name:"new",description:"newCategory"};
    //var pointer, e =  jiraConnector.createNewProjectCategory(newCategory);
    //io:println(pointer);
    //io:println(e);
    //
    //
    //var pointer, e =  jiraConnector.deleteProjectCategory("10571");
    //io:println(pointer);
    //io:println(e);





    //var pointer2, e =  project.updateProjectType(jira:ProjectType.SOFTWARE);
    //io:println(pointer2);
    //io:println(e);


    //var pointer2, e = project.components[0].fetchComponent();
    //io:println(pointer2);
    //io:println(e);
    //
    //var pointer3, e = pointer2.getLeadDetails();
    //io:println(pointer2);
    //io:println(e);

}







