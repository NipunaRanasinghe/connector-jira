package samples.wso2.jira;

import ballerina.net.http;
import src.wso2.jira;
import src.wso2.jira.models;
import ballerina.io;
import src.wso2.jira.utils.constants;
import src.wso2.jira.connectors;


public function main (string[] args) {


    //endpoint <jira:jiraProjectConnector> jiraProjectConnector {
    //    create jira:jiraProjectConnector();
    //}

    endpoint <jira:JiraConnector> jiraConnector {
        create jira:JiraConnector(jira:AuthenticationType.BASIC);
    }
   // models:ProjectPointer[] pointer;
    error  e;


    //var role,e = jiraConnector.getProjectRole("10314",constants:ROLE_ID_DEVELOPERS);
    //io:println(role.description);
    //io:println(e);



    //var pointer, e =  jiraConnector.getProjectSummary("10314");
    //io:println(pointer);
    //io:println(e);

    //var pointers, e =  jiraProjectConnector.getAllProjects();
    ////io:println(pointer);
    //io:println(pointers);
    //io:println(e);


    //var pointer, e =  jiraConnector.getProjectStatuses("10314");
    //io:println(pointer[0]);
    //io:println(e);

    jira:SetActor newActor = {name:"support.client.AAALIFEDEV.user",|type|:jira:ActorType.GROUP};
    var pointer, e =  jiraConnector.addActorToProject("10314",constants:ROLE_ID_DEVELOPERS,newActor);
    io:println(pointer);
    io:println(e);


    //jira:SetProjectCategory newCategory = {name:"new",description:"newCategory"};
    //var pointer, e =  jiraConnector.createNewProjectCategory(newCategory);
    //io:println(pointer);
    //io:println(e);





}







