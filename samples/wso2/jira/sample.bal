package samples.wso2.jira;
import ballerina.io;
import src.wso2.jira;



public function main (string[] args) {


    endpoint<jira:JiraConnector> jiraConnector {
        create jira:JiraConnector();
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                         Samples - Jira Project                                                 //
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
    //**************************************************************************************************************
    //Gets descriptions of all the existing jira projects
    io:println("\n\n");
    io:println("ACTION: getAllProjectSummaries()");
    var projects, e = jiraConnector.getAllProjectSummaries();
    io:println(projects);
    io:println(e);


    //**************************************************************************************************************
    //Creates new a project named "Test Project - Production Support"

    jira:NewProject newProject =
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
    jira:ProjectUpdate projectUpdate =
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
    io:println("BIND FUNCTION: project.getRole()");
    var developers, e = project.getRole(jira:ProjectRoleType.DEVELOPERS);
    io:println(developers);
    io:println(e);


    //**************************************************************************************************************
    //Add new group(actor) "support.client.AAALIFEDEV.user" to the the current developers role.
    io:println("\n\n");
    io:println("BIND FUNCTION: project.addActorToRole()");
    jira:NewActor newActor = {name:"support.client.AAALIFEDEV.user", |type|:jira:ActorType.GROUP};
    result, e = project.addActorToRole(jira:ProjectRoleType.EXTERNAL_CONSULTANT, newActor);
    io:println(result);
    io:println(e);


    //**************************************************************************************************************
    //Remove group "support.client.AAALIFEDEV.user" from the the current developers role.
    io:println("\n\n");
    io:println("BIND FUNCTION: project.removeActorFromRole()");
    result, e = project.removeActorFromRole(jira:ProjectRoleType.DEVELOPERS, "support.client.AAALIFEDEV.user",
                                            jira:ActorType.GROUP);
    io:println(result);
    io:println(e);


    //**************************************************************************************************************
    //Gets all issue types with valid status values for a project
    io:println("\n\n");
    io:println("BIND FUNCTION: project.getAllStatuses()");
    var statuses, e = project.getAllStatuses();
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
    io:println("BIND FUNCTION: componentSummary.expandComponent()");
    var component, e = project.components[0].expandComponent();
    io:println(component);
    io:println(e);


    //**************************************************************************************************************
    //expand jira user details of the lead
    io:println("\n\n");
    io:println("BIND FUNCTION: component.getLeadUserDetails()");
    var user, e = component.getLeadUserDetails();
    io:println(user);
    io:println(e);




    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                        Samples - Jira Project Category                                         //
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
    io:println(projectCategory);
    io:println(e);


    var pointer, e =  jiraConnector.deleteProjectCategory("10571");
    io:println(pointer);
    io:println(e);





    var pointer2, e =  project.updateProjectType(jira:ProjectType.SOFTWARE);
    io:println(pointer2);
    io:println(e);


    var pointer2, e = project.components[0].fetchComponent();
    io:println(pointer2);
    io:println(e);

    var pointer3, e = pointer2.getLeadDetails();
    io:println(pointer2);
    io:println(e);

}







