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
//

package src.wso2.jira;
import ballerina.net.http;
import src.wso2.jira.utils.constants;

//global variables to provide authentication in bind functions


@Description {value:"Jira client connector"}
@Param {value:"username: Jira account username"}
@Param {value:"password: Jira user account password"}
public connector JiraConnector (AuthenticationType authType) {

    //creates HttpClient Endpoint
    endpoint<http:HttpClient> jiraEndpoint {
        create http:HttpClient(constants:JIRA_API_ENDPOINT, getHttpConfigs());
    }
    http:HttpConnectorError httpError;


    action getAllProjectSummaries () (Project[], JiraConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        Project[] projects = [];
        JiraConnectorError e;
        error err;
        json jsonResponse;
        json[] jsonResponseArray;

        constructAuthHeader(authType, request);
        response, httpError = jiraEndpoint.get("/project", request);
        jsonResponse, e = validateResponse(response, httpError);

        if (e != null) {
            return null, e;
        }
        else {
            jsonResponseArray, err = (json[])jsonResponse;
            if (err != null) {
                e = <JiraConnectorError, toConnectorError()>err;
                return null, e;
            }
            int x = 0;
            foreach (jsonProject in jsonResponseArray) {

                jsonProject.leadName = jsonProject.lead == null ? "" :
                                       jsonProject.lead.name == null ? "" : jsonProject.lead.name;
                jsonProject.issueTypes = jsonProject.issueTypes == null ? [] : jsonProject.issueTypes;
                jsonProject.description = jsonProject.description == null ? "" : jsonProject.description;
                jsonProject.components = jsonProject.components == null ? [] : jsonProject.components;
                jsonProject.versions = jsonProject.versions == null ? [] : jsonProject.versions;

                projects[x], err = <Project>jsonProject;
                if (err != null) {
                    e = <JiraConnectorError, toConnectorError()>err;
                    return null, e;
                }
                x = x + 1;
            }
            return projects, e;
        }

    }

    @Description {value:"Get Jira Project information"}
    @Param {value: "string containing the unique key/id of the project"}
    action getProject (string projectIdOrKey) (Project, JiraConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        Project project;
        JiraConnectorError e;
        error err;

        json jsonResponse;
        constructAuthHeader(authType, request);

        response, httpError = jiraEndpoint.get("/project/" + projectIdOrKey, request);
        jsonResponse, e = validateResponse(response, httpError);

        if (e != null) {
            return null, e;
        }

        else {
            jsonResponse["leadName"] = jsonResponse["lead"]["name"];
            project, err = <Project>jsonResponse;
            e = <JiraConnectorError, toConnectorError()>err;
            return project, e;
        }

    }

    action createNewProject (NewProject newProject) (boolean, JiraConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        JiraConnectorError e;
        error err;
        json jsonResponse;
        json jsonPayload;
        constructAuthHeader(authType, request);

        jsonPayload, err = <json>newProject;
        if (err != null) {
            e = <JiraConnectorError, toConnectorError()>err;
            return false, e;
        }

        request.setJsonPayload(jsonPayload);


        response, httpError = jiraEndpoint.post("/project", request);
        jsonResponse, e = validateResponse(response, httpError);

        if (e != null) {
            return false, e;
        }

        else {
            return true, e;
        }

    }

    action updateProject (string projectIdOrKey, ProjectUpdate update) (boolean, JiraConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        JiraConnectorError e;
        error err;
        json jsonResponse;
        json jsonPayload;
        constructAuthHeader(authType, request);

        jsonPayload = <json,toJsonProject()>update;
        if (err != null) {
            e = <JiraConnectorError, toConnectorError()>err;
            return false, e;
        }

        request.setJsonPayload(jsonPayload);

        response, httpError = jiraEndpoint.put("/project/"+projectIdOrKey, request);
        jsonResponse, e = validateResponse(response, httpError);

        if (e != null) {
            return false, e;
        }

        else {
            return true, e;
        }

    }

    action deleteProject (string projectIdOrKey) (boolean, JiraConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        JiraConnectorError e;
        json jsonResponse;
        constructAuthHeader(authType, request);

        response, httpError = jiraEndpoint.delete("/project/" + projectIdOrKey, request);
        jsonResponse, e = validateResponse(response, httpError);

        if (e != null) {
            return false, e;
        }

        else {
            return true,e;
        }

    }

    action getAllProjectCategories () (ProjectCategory[], JiraConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        ProjectCategory[] projectCategories = [];
        JiraConnectorError e;
        error err;
        json jsonResponse;
        json[] jsonResponseArray;
        constructAuthHeader(authType, request);
        response, httpError = jiraEndpoint.get("/projectCategory", request);
        jsonResponse, e = validateResponse(response, httpError);

        if (e != null) {
            return null, e;
        }

        else {
            jsonResponseArray, err = (json[])jsonResponse;
            int x = 0;
            foreach (jsonProjectCategory in jsonResponseArray) {
                projectCategories[x], err = <ProjectCategory>jsonProjectCategory;
                if (err != null) {
                    e = <JiraConnectorError, toConnectorError()>err;
                    return null, e;
                }
                x = x + 1;
            }
            return projectCategories, e;
        }

    }

    action createNewProjectCategory (NewProjectCategory newCategory) (boolean, JiraConnectorError) {

        http:OutRequest request = {};
        http:InResponse response = {};
        JiraConnectorError e = null;
        error err;
        json jsonResponse;
        json jsonPayload;

        constructAuthHeader(authType, request);

        jsonPayload, err = <json>newCategory;
        if (err != null) {
            e = <JiraConnectorError, toConnectorError()>err;
            return false, e;
        }

        request.setJsonPayload(jsonPayload);

        response, httpError = jiraEndpoint.post("/projectCategory", request);
        jsonResponse, e = validateResponse(response, httpError);
        if (e != null) {
            return false, e;
        }

        else {
            return true, null;
        }

    }

    action deleteProjectCategory (string projectCategoryId) (boolean, JiraConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        JiraConnectorError e = null;
        json jsonResponse;

        constructAuthHeader(authType, request);

        response, httpError = jiraEndpoint.delete("/projectCategory/" + projectCategoryId, request);
        jsonResponse, e = validateResponse(response, httpError);
        if (e != null) {
            return false, e;
        }
        else {
            return true, null;
        }
    }


    //This Action is replaced by a struct-bound function
     //@Description {value: "Get the list of roles assigned to the project"}
    //@Param {value: "string containing the unique key/id of project"}
    //@Param {value: "string containing the unique id of the project role"}
    //action getProjectRole (string projectIdOrKey, string projectRoleId) (ProjectRole, JiraConnectorError) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //    JiraConnectorError e;
    //    json jsonResponse;
    //
    //    constructAuthHeader(authType,request);
    //
    //    response, httpError = jiraEndpoint.get("/project/" + projectIdOrKey + "/role/" + projectRoleId, request);
    //    jsonResponse, e = validateResponse(response, httpError);
    //
    //    if (e != null) {
    //        return null, e;
    //    }
    //
    //    else {
    //        var role, err = <ProjectRole>jsonResponse;
    //        if(err!=null){
    //            e = <JiraConnectorError,toConnectorError()>err;
    //            return null,e;
    //        }
    //        return role, e;
    //    }
    //
    //}

    //This Action is replaced by a struct-bound function
    //@Description {value:"Get all issue types with valid status values for a project"}
    //@Param {value: "string containing of the unique key/id of project"}
    //action getProjectStatuses (string projectIdOrKey) (ProjectStatus[], JiraConnectorError) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //    JiraConnectorError e;
    //    error err;
    //    json jsonResponse;
    //    json[] jsonResponseArray;
    //    ProjectStatus[] statusArray = [];
    //
    //    constructAuthHeader(authType,request);
    //
    //    response, httpError = jiraEndpoint.get("/project/" + projectIdOrKey+"/statuses", request);
    //    jsonResponse, e = validateResponse(response, httpError);
    //
    //    if (e != null) {
    //        return null, e;
    //    }
    //
    //    else {
    //        jsonResponseArray,err = (json[])jsonResponse;
    //        if(err!=null){
    //            e = <JiraConnectorError,toConnectorError()>err;
    //            return null,e;
    //        }
    //        else {
    //            int x = 0;
    //            foreach (i in jsonResponseArray) {
    //                statusArray[x],err = <ProjectStatus>jsonResponseArray[x];
    //                if(err!=null){
    //                    e = <JiraConnectorError,toConnectorError()>err;
    //                    return null,e;
    //                }
    //                x=x+1;
    //            }
    //
    //            return statusArray,null;
    //        }
    //    }
    //
    //
    //
    //    }

    //This Action is replaced by a struct-bound function
    //@Description {value:"Updates a project role to include the specified actors (users or groups)"}
    //action addActorToProject(string projectIdOrKey,string projectRoleId,SetActor newActor)(boolean, JiraConnectorError){
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //    Project project;
    //    JiraConnectorError e = {message:""};
    //    json jsonPayload;
    //    json jsonResponse;
    //
    //    constructAuthHeader(authType,request);
    //
    //
    //    jsonPayload = models:addActorToRoleSchema;
    //
    //
    //
    //    if(newActor.|type|==ActorType.USER) {
    //        jsonPayload["user"][0]= newActor.name;
    //    }
    //
    //    else if(newActor.|type|==ActorType.GROUP) {
    //        jsonPayload["group"][0]= newActor.name;
    //    }
    //
    //    else{
    //        e.message="actor type is not specified correctly";
    //        return false,e;
    //    }
    //
    //    request.setJsonPayload(jsonPayload);
    //    response, httpError = jiraEndpoint.post("/project/" + projectIdOrKey+"/role/"+projectRoleId, request);
    //    jsonResponse, e = validateResponse(response, httpError);
    //
    //    if (e != null) {
    //        return false, e;
    //    }
    //
    //    else {
    //        io:println(jsonResponse);
    //        return true, null;
    //    }
    //}
}







