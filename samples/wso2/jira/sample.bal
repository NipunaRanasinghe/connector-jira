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
        create jira:JiraConnector();
    }

   // models:ProjectPointer[] pointer;
    error  e;


    //var role,e = jiraConnector.getProjectRole("10314",constants:ROLE_ID_DEVELOPERS);
    //io:println(role.description);
    //io:println(e);



    //var pointer, e =  jiraConnector.getProjectSummarybyId("10314");
    //io:println(pointer);
    //io:println(e);

    //var pointers, e =  jiraProjectConnector.getAllProjects();
    ////io:println(pointer);
    //io:println(pointers);
    //io:println(e);


    var pointer, e =  jiraConnector.getProjectStatuses("10314");
    io:println(pointer[0]);
    io:println(e);


}







