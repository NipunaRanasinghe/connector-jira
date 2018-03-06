//
// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.


package src.wso2.jira;

import ballerina.net.http;
import src.wso2.jira.models;
import ballerina.io;
import ballerina.collections;
import src.wso2.jira.utils.constants;
import ballerina.config;
import ballerina.runtime;



@Description {value: "Jira client connector"}
public connector JiraConnector (AuthenticationType authType) {

    //creates HttpClient Endpoint
    endpoint<http:HttpClient> jiraEndpoint {
        create http:HttpClient(constants:JIRA_API_ENDPOINT, getConnectorConfigs());
    }
    http:HttpConnectorError httpError;


    action getAllProjects () (ProjectSummary[], error) {
        http:OutRequest request = {};
        http:InResponse response = {};
        ProjectSummary[] projects = [];
        error e = {message:"", cause:null};
        json jsonResponse;
        json[] jsonResponseArray;
        constructAuthHeader(authType,request);
        response, httpError = jiraEndpoint.get("/project", request);
        jsonResponse, e = validateResponse(response, httpError);

        if (e != null) {
            return null, e;
        }

        else {
            jsonResponseArray, e = (json[])jsonResponse;
            int x = 0;
            foreach (i in jsonResponseArray) {
                projects[x], e = <ProjectSummary>i;
                x = x + 1;
            }
            return projects, e;
        }

    }

    //@Description {value:"Get Jira Project information"}
    //@Param {value: "string containing the unique key/id of the project"}
    action getProjectSummary (string projectIdOrKey) (ProjectSummary, error) {
        http:OutRequest request = {};
        http:InResponse response = {};
        ProjectSummary project;
        error e = {message:"", cause:null};
        json jsonResponse;
        constructAuthHeader(authType,request);

        response, httpError = jiraEndpoint.get("/project/" + projectIdOrKey, request);
        jsonResponse, e = validateResponse(response, httpError);

        if (e != null) {
            return null, e;
        }

        else {
            project, e = <ProjectSummary>jsonResponse;
            return project, e;
        }

    }

    //@Description {value: "Get the list of roles assigned to the project"}
    //@Param {value: "string containing the unique key/id of project"}
    //@Param {value: "string containing the unique id of the project role"}
    action getProjectRole (string projectIdOrKey, string projectRoleId) (ProjectRole, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        error e = {message:"", cause:null};
        json jsonResponse;

        constructAuthHeader(authType,request);

        response, httpError = jiraEndpoint.get("/project/" + projectIdOrKey + "/role/" + projectRoleId, request);
        jsonResponse, e = validateResponse(response, httpError);

        if (e != null) {
            return null, e;
        }

        else {
            var role, e = <ProjectRole>jsonResponse;
            return role, e;
        }

    }


    //@Description {value:"Get all issue types with valid status values for a project"}
    //@Param {value: "string containing of the unique key/id of project"}
    action getProjectStatuses (string projectIdOrKey) (ProjectStatus[], error) {
        http:OutRequest request = {};
        http:InResponse response = {};
        error e = {message:"", cause:null};
        json jsonResponse;
        json[] jsonResponseArray;
        ProjectStatus[] statusArray = [];

        constructAuthHeader(authType,request);

        response, httpError = jiraEndpoint.get("/project/" + projectIdOrKey+"/statuses", request);
        jsonResponse, e = validateResponse(response, httpError);

        if (e != null) {
            return null, e;
        }

        else {
            jsonResponseArray,e = (json[])jsonResponse;
            if(e!=null){
                return null,e;
            }
            else {
                int x = 0;
                foreach (i in jsonResponseArray) {
                    statusArray[x],e = <ProjectStatus>jsonResponseArray[x];
                    if(e!=null){return null,e;}
                    x=x+1;
                }

                return statusArray,null;
            }
        }



        }


    @Description {value:"Updates a project role to include the specified actors (users or groups)"}
    action addActorToProject(string projectIdOrKey,string projectRoleId,SetActor newActor)(boolean, error){
        http:OutRequest request = {};
        http:InResponse response = {};
        ProjectSummary project;
        error e = {message:"", cause:null};
        json jsonPayload = {};
        json jsonResponse;

        constructAuthHeader(authType,request);


       // json payload = models:addActorToProjectSchema;

        //payload.id,_ = <int>projectRoleId;

        //if(newActor.|type|==ActorType.USER) {
        //    payload.categorisedActors.|atlassian-user-role-actor|[0]= newActor.name;
        //}
        //
        //else if(newActor.|type|==ActorType.GROUP) {
        //    payload.categorisedActors.|atlassian-group-role-actor|[0]= newActor.name;
        //}
        //
        //else{
        //    e.message="actor type is not specified correctly";
        //    return false,e;
        //}


        jsonPayload = {"group":["support.client.AAALIFEDEV.user"]};
        request.setJsonPayload(jsonPayload);
        //request.setHeader("Authorization"," Basic YXNoYW5Ad3NvMi5jb206YXNoYW4xMjM");
        //request.setHeader("Content-Type","application/json");

        constructContentLengthHeader(request);

        response, httpError = jiraEndpoint.post("/project/" + projectIdOrKey+"/role/"+projectRoleId, request);
        //response, httpError = jiraEndpoint.post("/project/" + projectIdOrKey+"/role/"+projectRoleId, request);
        io:println("/project/" + projectIdOrKey+"/role/"+projectRoleId);

        jsonResponse, e = validateResponse(response, httpError);

        if (e != null) {
            return false, e;
        }

        else {
            io:println(jsonResponse);
            return true, null;
        }
    }


    action getAllProjectCategories()(ProjectCategory[],error){
        http:OutRequest request = {};
        http:InResponse response = {};
        ProjectCategory[] projectCategories = [];
        error e = {message:"", cause:null};
        json jsonResponse;
        json[] jsonResponseArray;
        constructAuthHeader(authType,request);
        response, httpError = jiraEndpoint.get("/projectCategory", request);
        jsonResponse, e = validateResponse(response, httpError);

        if (e != null) {
            return null, e;
        }

        else {
            jsonResponseArray, e = (json[])jsonResponse;
            int x = 0;
            foreach (i in jsonResponseArray) {
                projectCategories[x], e = <ProjectCategory>i;
                x = x + 1;
            }
            return projectCategories, e;
        }

    }


    action createNewProjectCategory(SetProjectCategory newCategory)(boolean,error){
        http:OutRequest request = {};
        http:InResponse response = {};
        error e = null;
        json jsonResponse;
        json jsonPayload;

        constructAuthHeader(authType,request);

        jsonPayload,e = <json>newCategory;
        if(e!=null){return false,e;}

        request.setJsonPayload(jsonPayload);
        constructContentLengthHeader(request);

        response, httpError = jiraEndpoint.post("/projectCategory", request);
        jsonResponse, e = validateResponse(response, httpError);
        if (e != null) {
            return false, e;
        }

        else {
            return true,null;
        }

    }


    action getUserByName (string username){


    }


}











//*************************************************
//  Functions
//*************************************************
@Description {value:"Add authoriaztion header to the request"}
@Param {value:"authType: Authentication type preferred by the user"}
@Param {value:"request: The http request object which is needed to be constructed"}
function constructAuthHeader (AuthenticationType authType,http:OutRequest request) {

    if (authType==AuthenticationType.BASIC){

        request.addHeader("Authorization", "Basic YXNoYW5Ad3NvMi5jb206YXNoYW4xMjM");
    }
}


function constructContentLengthHeader (http:OutRequest request) {
   // request.addHeader("Transfer-Encoding","chunked");
  //  request.addHeader("Content-Length", <string>request.getContentLength());
    io:println(request.getContentLength());
    io:println(request.getHeader("Content-Type"));
    request.setHeader("Cache-Control","no-cache");
    //request.setHeader("Transfer-Encoding","deflate");
    //io:println(request.getHeader("Transfer-Encoding"));
   // request.addHeader("Postman-Token","987f3bee-2885-c855-a529-90b1d8f07335");
   //request.addHeader("Content-Length", "0");
}




@Description {value:"Checks whether the http response contains any errors "}
@Param {value:"request: The http response object"}
@Param{value:"httpError: http response error object"}
function validateResponse(http:InResponse response, http:HttpConnectorError httpError)(json,error){

    error e = {message:"" ,cause:null};

    if(httpError!=null){
        e.message = httpError.message;
        e.cause = httpError.cause;
        return null,e;
    }

    else if(response.statusCode != constants:STATUS_CODE_OK && response.statusCode != constants:STATUS_CODE_CREATED && response.statusCode != constants:STATUS_CODE_NO_CONTENT){
        error ee;
        json res;
        io:println(response);
        e.message = response.reasonPhrase;
        e.message = "status "+<string>response.statusCode + ": " + e.message;
        try {
            res = response.getJsonPayload();
            var cause,ee = (string)res.errorMessages[0];
            if(ee==null){e.message = e.message+ "- " + cause; }
        }
        catch(error err){
            io:println(err.message);

        }

        return null,e;



    }

    else {

        json jsonResponse = response.getJsonPayload();
        return jsonResponse,null;

    }

}




function getConnectorConfigs() (http:Options) {
    http:Options option = {
                              ssl: {
                                       trustStoreFile:"${ballerina.home}/bre/security/ballerinaTruststore.p12",
                                       trustStorePassword:"ballerina"
                                   },
                              followRedirects: {},
                              chunking:"never"
                          };
    return option;
}




//*************************************************
//  Struct Templates
//*************************************************
// #TODO Move these structs to another package once https://github.com/ballerina-lang/ballerina/issues/4736 is fixed.


struct BasicAuth {
    string username;
    string password;
}


struct BasicAuthBase64 {
    string token;
}


public struct ProjectSummary {
    string self;
    string id;
    string key;
    string name;
    ProjectCategory projectCategory;
    string projectTypeKey;
}


public struct ProjectCategory {
    string self;
    string id;
    string name;
    string description;
}



public struct ProjectRole {
    string self;
    string name;
    string description;
    Actor[] actors;
}

public struct Actor {
    string id;
    string name;
    string displayName;
    string |type|;
}


public struct ProjectStatus{
    string self;
    string name;
    string id;
    json statuses;
}


public struct User{
    string self;
    string key;
    string name;
    string displayName;
    string emailAddress;
    json avatarUrls;
    boolean active;
    string timeZone;
    string locale;
}






public struct SetActor{
    ActorType |type|;
    string name;

}

public struct SetProjectCategory{
    string name;
    string description;
}



public enum AuthenticationType{
    BASIC
}


public enum ActorType{
    GROUP,USER
}


