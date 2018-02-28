package samples.wso2.jira;

import ballerina.net.http;
import src.wso2.jira;
import src.wso2.jira.models;
import ballerina.io;


public function main (string[] args) {


    endpoint <jira:jiraConnector> jiraConnector {
        create jira:jiraConnector();
    }

   // models:ProjectPointer[] pointer;
    error  e;



    //
    //var pointer, e =  jiraConnector.getProjectSummarybyId("10314");
    //io:println(pointer);
    //io:println(e);

    var pointers, e =  jiraConnector.getAllProjects();
    //io:println(pointer);
    io:println(pointers);
    io:println(e);


    //pointers,e = jiraConnector.getallProjects();



    //responseProjectList, e = githubConnector.getRepositoryProjects("vlgunarathne", "carbon-apimgt", "open");
    //responseProjectList, e = githubConnector.getRepositoryProjects("vlgunrathne", "ProLAd-ExpertSystem", "open");
    //println(responseProjectList);
    //println(e);
    //println("=========================================================");
    //
    //responseProjectList, e = githubConnector.getOrganizationProjects("wso23", "open");
    //println(responseProjectList);
    //println(e);
    //println("=========================================================");

    //github:Project singleProject;
    //singleProject, e = githubConnector.getProject("wso2", "testgrid", 1);
    ////singleProject, e = githubConnector.getProject("vlgunarathne", "ProLAd-ExpertSystem", 1);
    //println(singleProject);
    //println(e);


}

