package samples.wso2.jira;

//import ballerina.net.http;
import src.wso2.jira;
//import src.wso2.jira.models;
import ballerina.io;
//import src.wso2.jira.utils.constants;
//import src.wso2.jira.connectors;


public function main (string[] args) {


    //endpoint <jira:jiraProjectConnector> jiraProjectConnector {
    //    create jira:jiraProjectConnector();
    //}

    endpoint <jira:JiraConnector> jiraConnector {
        create jira:JiraConnector(jira:AuthenticationType.BASIC);
    }
   // models:ProjectPointer[] pointer;
    jira:JiraConnectorError e;


    //var role,e = jiraConnector.getProjectRole("10314",constants:ROLE_ID_DEVELOPERS);
    //io:println(role.description);
    //io:println(e);


    //var project, e =  jiraConnector.getProjectSummary("10314");
    //io:println(project);
    //io:println(e);

    //var pointer2, e =  project.getRole(jira:ProjectRoleType.EXTERNAL_CONSULTANT);
    //io:println(pointer2);
    //io:println(e);


    //var pointer2, e =  project.getStatuses();
    //io:println(pointer2);
    //io:println(e);


    //var pointer2, e =  project.updateProjectType("");
    //io:println(pointer2);
    //io:println(e);

    //jira:SetActor newActor = {name:"support.client.AAALIFEDEV.user",|type|:jira:ActorType.GROUP};
    //var pointer2, e =  pointer.addActorToRole(jira:ProjectRoleType.EXTERNAL_CONSULTANT,newActor);
    //io:println(pointer2);
    //io:println(e);





    //var pointers, e =  jiraProjectConnector.getAllProjects();
    ////io:println(pointer);
    //io:println(pointers);
    //io:println(e);




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


    //jira:NewProject newProject = {key:"NIPUNATESTB",name: "Connector Check4 - Production Support",
    //projectTypeKey:"software",
    //projectTemplateKey:"com.pyxis.greenhopper.jira:basic-software-development-template",
    //description: "Example Project description",
    //lead: "pasan@wso2.com",
    //url: "http://atlassian.com",
    //assigneeType: "PROJECT_LEAD",
    //avatarId: 10005,
    //issueSecurityScheme: 10000,
    //permissionScheme: 10075,
    //notificationScheme: 10086,
    //categoryId: 10000};
    //
    //var pointer, e =  jiraConnector.createNewProject(newProject);
    //io:println(pointer);
    //io:println(e);

    var project, e =  jiraConnector.getProject("10314");
    io:println(project);
    io:println(e);



    //var pointer2, e =  project.updateProjectType(jira:ProjectType.SOFTWARE);
    //io:println(pointer2);
    //io:println(e);

    var pointer2, e =  project.components[0].fetchComponent();
    io:println(pointer2);
    io:println(e);

    var pointer3, e =  pointer2.getLeadDetails();
    io:println(pointer2);
    io:println(e);

}







