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

@Description {value: "Jira client connector"}

public connector jiraConnector () {

    //creates HttpClient Endpoint
    endpoint <http:HttpClient> jiraEndpoint {
        create http:HttpClient("https://support-staging.wso2.com/jira/rest/api/2", {} );
    }
    http:HttpConnectorError httpError;


    action getAllProjects() (ProjectSummary[], error){
        http:OutRequest request = {};
        http:InResponse response = {};
        ProjectSummary[] projects = [];
        error e = {message:"" ,cause:null};
        json jsonResponse;
        json[] jsonResponseArray;
        constructAuthHeader(request);
        response, httpError = jiraEndpoint.get("/project", request);
        jsonResponse,e = validateResponse(response, httpError);

        if (e!=null) {
            return null,e;
        }

        else{
            jsonResponseArray, e = (json[])jsonResponse;
            int x =0;
            foreach (i in jsonResponseArray){
                projects[x],e = <ProjectSummary>i;
                x=x+1;
            }
            return projects,e;
        }

    }



    action getProjectSummarybyId(string id) (ProjectSummary, error){
        http:OutRequest request = {};
        http:InResponse response = {};
        ProjectSummary project;
        error e = {message:"" ,cause:null};
        json jsonResponse;
        constructAuthHeader(request);

        response, httpError = jiraEndpoint.get("/project/" + id, request);
        jsonResponse,e = validateResponse(response, httpError);

        if (e!=null) {
            return null,e;
        }

        else{
            project, e = <ProjectSummary>jsonResponse;
            return project, e;
        }

    }



}


@Description {value:"Construct the request headers"}
@Param {value:"request: The http request object"}
function constructAuthHeader (http:OutRequest request) {
    request.addHeader("Authorization","Basic YXNoYW5Ad3NvMi5jb206YXNoYW4xMjM=");
}


@Description {value:"Check whether the response contains any errors "}
@Param {value:"request: The http request object"}
function validateResponse(http:InResponse response, http:HttpConnectorError httpError)(json,error){

    error e = {message:"" ,cause:null};

    if(httpError!=null){
        e.message = httpError.message;
        e.cause = httpError.cause;
        io:println(e);
        return null,e;
    }
    else {

        json jsonResponse = response.getJsonPayload();

        if (response.statusCode != constants:STATUS_CODE_OK) {
            e.message,_ = (string)jsonResponse.errorMessages[0];
            e.message = "status "+<string>response.statusCode + ": " + e.message;
            io:println(e);
            return null,e;
        }

        else{
            return jsonResponse,null;
        }
    }

}


//*************************************************
//  Struct Templates
//*************************************************
// #TODO Move these structs to another package once https://github.com/ballerina-lang/ballerina/issues/4736 is fixed.



struct BasicAuth{
    string username;
    string password;
}


struct BasicAuthBase64{
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
