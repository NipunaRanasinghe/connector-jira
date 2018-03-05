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



@Description {value: "Jira client connector"}
public connector JiraConnector (AuthenticationType authType) {

    //creates HttpClient Endpoint
    endpoint<http:HttpClient> jiraEndpoint {
        create http:HttpClient("https://support-staging.wso2.com/jira/rest/api/2", {});
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
        json jsonPayload;
        json jsonResponse;

        constructAuthHeader(authType,request);

        json payload = models:addActorToProjectSchema;

        payload.id,_ = <int>projectRoleId;

        if(newActor.|type|==ActorType.USER) {
            payload.categorisedActors.|atlassian-user-role-actor|[0]= newActor.name;
        }

        else if(newActor.|type|==ActorType.GROUP) {
            payload.categorisedActors.|atlassian-group-role-actor|[0]= newActor.name;
        }

        else{
            e.message="actor type is not specified correctly";
            return false,e;
        }

        request.setJsonPayload(payload);
        io:println(payload);

        io:println("/project/" + projectIdOrKey+"/role/"+projectRoleId);
        response, httpError = jiraEndpoint.put("/project/" + projectIdOrKey+"/role/"+projectRoleId, request);
        jsonResponse, e = validateResponse(response, httpError);

        if (e != null) {
            return false, e;
        }

        else {
            return true, null;
        }
    }


    action getUserByName (string username){


    }


}








//*************************************************
//  Functions
//*************************************************
@Description {value:"Construct the request authoriaztion headers"}

@Param {value:"authType: Authentication type preferred by the user"}
@Param {value:"request: The http request object which is needed to be constructed"}
function constructAuthHeader (AuthenticationType authType,http:OutRequest request) {

    if (authType==AuthenticationType.BASIC){
        request.addHeader("Authorization", "Basic YXNoYW5Ad3NvMi5jb206YXNoYW4xMjM=");
    }
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

    else if(response.statusCode != constants:STATUS_CODE_OK){
        e.message = response.reasonPhrase;
        e.message = "status "+<string>response.statusCode + ": " + e.message;
        return null,e;
    }

    else {

        json jsonResponse = response.getJsonPayload();
        return jsonResponse,null;

    }

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



public enum AuthenticationType{
    BASIC
}


public enum ActorType{
    GROUP,USER
}


