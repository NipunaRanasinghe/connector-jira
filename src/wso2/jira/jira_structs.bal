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
import src.wso2.jira.utils.constants;
import ballerina.net.http;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                               Jira Project                                                         //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public struct Project {
    string self;
    string id;
    string key;
    string name;
    string description;
    string leadName;
    string projectTypeKey;
    AvatarUrls avatarUrls;
    ProjectCategory projectCategory;
    IssueType[] issueTypes;
    ProjectComponentSummary[] components;
    ProjectVersion[] versions;
}

public function <Project project> getProjectLeadUserDetails () (User, JiraConnectorError) {
    endpoint<http:HttpClient> jiraClient {
        create http:HttpClient(constants:JIRA_API_ENDPOINT, getHttpConfigs());
    }
    http:HttpConnectorError httpError;
    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e;
    json jsonResponse;
    error err;
    User lead;

    if (project == null) {
        e = {message:"Unable to proceed with a null structure", cause:null};
        return null, e;
    }

    constructAuthHeader(AuthenticationType.BASIC, request);
    response, httpError = jiraClient.get("/user?username=" + project.leadName, request);
    jsonResponse, e = validateResponse(response, httpError);

    if (e != null) {
        return null, e;
    }

    else {
        lead, err = <User>jsonResponse;
        e = <JiraConnectorError, toConnectorError()>err;
        return lead, e;
    }



}

public function <Project project> getRole (ProjectRoleType projectRoleType) (ProjectRole, JiraConnectorError) {
    endpoint<http:HttpClient> jiraClient {
        create http:HttpClient(constants:JIRA_API_ENDPOINT, getHttpConfigs());
    }
    http:HttpConnectorError httpError;
    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e;
    json jsonResponse;

    if (project == null) {
        e = {message:"Unable to proceed with a null structure", cause:null};
        return null, e;
    }

    constructAuthHeader(AuthenticationType.BASIC, request);
    response, httpError = jiraClient.get("/project/" + project.key + "/role/" +
                                         getProjectRoleIdFromEnum(projectRoleType), request);
    jsonResponse, e = validateResponse(response, httpError);

    if (e != null) {
        return null, e;
    }

    else {
        var role, err = <ProjectRole>jsonResponse;
        if (err != null) {
            e = <JiraConnectorError, toConnectorError()>err;
            return null, e;
        }
        return role, e;
    }
}

public function <Project project> addActorToRole (ProjectRoleType projectRoleType, NewActor actor) (boolean, JiraConnectorError) {
    endpoint<http:HttpClient> jiraClient {
        create http:HttpClient(constants:JIRA_API_ENDPOINT, getHttpConfigs());
    }
    http:HttpConnectorError httpError;
    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e = {message:""};
    json jsonPayload;
    json jsonResponse;

    constructAuthHeader(AuthenticationType.BASIC, request);

    if (actor.|type| == ActorType.USER) {
        jsonPayload["user"] = [actor.name];
    }

    else if (actor.|type| == ActorType.GROUP) {
        jsonPayload["group"] = [actor.name];
    }

    else {
        e.message = "actor type is not specified correctly";
        return false, e;
    }

    request.setJsonPayload(jsonPayload);
    response, httpError = jiraClient.post("/project/" + project.key + "/role/" +
                                          getProjectRoleIdFromEnum(projectRoleType), request);
    jsonResponse, e = validateResponse(response, httpError);

    if (e != null) {
        return false, e;
    }

    else {
        return true, null;
    }

}

public function <Project project> removeActorFromRole (ProjectRoleType projectRoleType, string actorName,ActorType actorType) (boolean, JiraConnectorError) {
    endpoint<http:HttpClient> jiraClient {
        create http:HttpClient(constants:JIRA_API_ENDPOINT, getHttpConfigs());
    }
    http:HttpConnectorError httpError;
    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e = {message:""};
    json jsonResponse;
    string queryParam;

    constructAuthHeader(AuthenticationType.BASIC, request);

    if (actorType == ActorType.USER) {
        queryParam = "?user="+actorName;
    }
    else if (actorType == ActorType.GROUP) {
        queryParam = "?group="+actorName;
    }
    else {
        e.message = "actor type is not specified correctly";
        return false, e;
    }


    response, httpError = jiraClient.delete("/project/" + project.key + "/role/" +
                                          getProjectRoleIdFromEnum(projectRoleType)+queryParam, request);
    jsonResponse, e = validateResponse(response, httpError);

    if (e != null) {
        return false, e;
    }

    else {

        return true, null;
    }

}

@Description {value:"Gets all issue types with valid status values for a project."}
public function <Project project> getAllStatuses () (ProjectStatus[], JiraConnectorError) {
    endpoint<http:HttpClient> jiraClient {
        create http:HttpClient(constants:JIRA_API_ENDPOINT, getHttpConfigs());
    }
    http:HttpConnectorError httpError;

    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e;
    error err;
    json jsonResponse;
    json[] jsonResponseArray;
    ProjectStatus[] statusArray = [];

    if (project == null) {
        e = {message:"Unable to proceed with a null structure", cause:null};
        return null, e;
    }

    constructAuthHeader(AuthenticationType.BASIC, request);
    response, httpError = jiraClient.get("/project/" + project.key + "/statuses", request);
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
        else {
            int x = 0;
            foreach (i in jsonResponseArray) {
                statusArray[x], err = <ProjectStatus>jsonResponseArray[x];
                if (err != null) {
                    e = <JiraConnectorError, toConnectorError()>err;
                    return null, e;
                }
                x = x + 1;
            }

            return statusArray, null;
        }
    }

}

@Description {value:"Updates the type of a project."}
public function <Project project> updateProjectType (ProjectType newProjectType) (boolean, JiraConnectorError) {
    endpoint<http:HttpClient> jiraClient {
        create http:HttpClient(constants:JIRA_API_ENDPOINT, getHttpConfigs());
    }
    http:HttpConnectorError httpError;

    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e = {message:""};
    json jsonResponse;

    constructAuthHeader(AuthenticationType.BASIC, request);


    response, httpError = jiraClient.put("/project/" + project.key + "/type/" + getProjectTypeFromEnum(newProjectType), request);
    jsonResponse, e = validateResponse(response, httpError);

    if (e != null) {
        return false, e;
    }

    else {
        return true, null;
    }

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


struct Authentication {
    string username;
    string password;
}

struct BasicAuthBase64 {
    string token;
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

public struct ProjectStatus {
    string self;
    string name;
    string id;
    json statuses;
}

public struct User {
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

public struct NewActor {
    ActorType |type|;
    string name;
}

public struct NewProjectCategory {
    string name;
    string description;
}

public struct ProjectUpdate {
    string key;
    string name;
    string projectTypeKey;
    string projectTemplateKey;
    string description;
    string lead;
    string url;
    string assigneeType;
    int avatarId;
    int issueSecurityScheme;
    int permissionScheme;
    int notificationScheme;
    int categoryId;
}

public struct NewProject {
    string key;
    string name;
    string projectTypeKey;
    string projectTemplateKey;
    string description;
    string lead;
    string url;
    string assigneeType;
    int avatarId;
    int issueSecurityScheme;
    int permissionScheme;
    int notificationScheme;
    int categoryId;
}

public struct JiraConnectorError {
    string |type|;
    string message;
    json jiraServerErrorLog;
    error cause;
}

public struct IssueType {
    string self;
    string id;
    string name;
    string description;
    string iconUrl;
    boolean subtask;
}

public struct ProjectVersion {
    string self;
    string id;
    string name;
    boolean archived;
    boolean released;
    string releaseDate;
    boolean overdue;
    string userReleaseDate;
    string projectId;
}

public struct AvatarUrls {
    string |16x16|;
    string |24x24|;
    string |32x32|;
    string |48x48|;
}

public struct Avatar {
    string id;
    boolean isSystemAvatar;
    boolean isSelected;
    boolean isDeletable;
    AvatarUrls urls;
    boolean selected;
}




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                           Project Components                                                       //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


public struct ProjectComponentSummary {
    string self;
    string id;
    string name;
    string description;
}

public function <ProjectComponentSummary projectComponentSummary> expandComponent () (ProjectComponent, JiraConnectorError) {
    endpoint<http:HttpClient> jiraClient {
        create http:HttpClient(constants:JIRA_API_ENDPOINT, getHttpConfigs());
    }
    http:HttpConnectorError httpError;

    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e;
    error err;
    json jsonResponse;


    if (projectComponentSummary == null) {
        e = {message:"Unable to proceed with a null structure", cause:null};
        return null, e;
    }

    constructAuthHeader(AuthenticationType.BASIC, request);
    response, httpError = jiraClient.get("/component/" + projectComponentSummary.id, request);
    jsonResponse, e = validateResponse(response, httpError);

    if (e != null) {
        return null, e;
    }

    else {
        try {
            jsonResponse["leadName"] = jsonResponse["lead"]["name"];
            jsonResponse["assigneeName"] = jsonResponse["assignee"]["name"];
            jsonResponse["realAssigneeName"] = jsonResponse["realAssignee"]["name"];
        }
        catch (error er) {
            e = <JiraConnectorError, toConnectorError()>err;
            return null, e;
        }

        var projectComponent, err = <ProjectComponent>jsonResponse;
        if (err != null) {
            e = <JiraConnectorError, toConnectorError()>err;
            return null, e;
        }
        return projectComponent, e;
    }
}

public struct ProjectComponent {
    string self;
    string id;
    string name;
    string description;
    string leadName;
    string assigneeName;
    string assigneeType;
    string realAssigneeName;
    string realAssigneeType;
    boolean isAssigneeTypeValid;
    string project;
    string projectId;
}

public function <ProjectComponent projectComponent> getLeadUserDetails () (User, JiraConnectorError) {
    endpoint<http:HttpClient> jiraClient {
        create http:HttpClient(constants:JIRA_API_ENDPOINT, getHttpConfigs());
    }
    http:HttpConnectorError httpError;

    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e;
    error err;
    json jsonResponse;

    if (projectComponent == null) {
        e = {message:"Unable to proceed with a null structure", cause:null};
        return null, e;
    }

    constructAuthHeader(AuthenticationType.BASIC, request);
    response, httpError = jiraClient.get("/user?username=" + projectComponent.leadName, request);
    jsonResponse, e = validateResponse(response, httpError);

    if (e != null) {
        return null, e;
    }

    else {
        var lead, err = <User>jsonResponse;
        e = <JiraConnectorError, toConnectorError()>err;
        return lead, e;
    }
}

public function <ProjectComponent projectComponent> fetAssigneeUserDetails () (User, JiraConnectorError) {
    endpoint<http:HttpClient> jiraClient {
        create http:HttpClient(constants:JIRA_API_ENDPOINT, getHttpConfigs());
    }
    http:HttpConnectorError httpError;

    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e;
    error err;
    json jsonResponse;

    if (projectComponent == null) {
        e = {message:"Unable to proceed with a null structure", cause:null};
        return null, e;
    }

    constructAuthHeader(AuthenticationType.BASIC, request);
    response, httpError = jiraClient.get("/user?username=" + projectComponent.assigneeName, request);
    jsonResponse, e = validateResponse(response, httpError);

    if (e != null) {
        return null, e;
    }

    else {
        var lead, err = <User>jsonResponse;
        e = <JiraConnectorError, toConnectorError()>err;
        return lead, e;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////









////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                         Enums                                                      //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public enum AuthenticationType {
    BASIC
}

public enum ActorType {
    GROUP, USER
}

public enum AssigneeType {
    PROJECTLEAD, UNASSIGNED
}

public enum ProjectRoleType {
    DEVELOPERS, EXTERNAL_CONSULTANT, OBSERVER, ADMINISTRATORS, USERS, CSAT_ADMINISTRATORS, NOTIFICATIONS
}

public enum ProjectType {
    SOFTWARE, BUSINESS
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function getProjectRoleIdFromEnum (ProjectRoleType |type|) (string) {
    if (|type| == ProjectRoleType.ADMINISTRATORS) {
        return constants:ROLE_ID_ADMINISTRATORS;
    }
    else if (|type| == ProjectRoleType.CSAT_ADMINISTRATORS) {
        return constants:ROLE_ID_CSAT_DEVELOPERS;
    }
    else if (|type| == ProjectRoleType.DEVELOPERS) {
        return constants:ROLE_ID_DEVELOPERS;
    }
    else if (|type| == ProjectRoleType.EXTERNAL_CONSULTANT) {
        return constants:ROLE_ID_EXTERNAL_CONSULTANTS;
    }
    else if (|type| == ProjectRoleType.NOTIFICATIONS) {
        return constants:ROLE_ID_NOTIFICATIONS;
    }
    else if (|type| == ProjectRoleType.OBSERVER) {
        return constants:ROLE_ID_OBSERVER;
    }
    else if (|type| == ProjectRoleType.USERS) {
        return constants:ROLE_ID_USERS;
    }
    else {
        return "";
    }
}

function getProjectTypeFromEnum (ProjectType projectType) (string) {
    return (projectType == ProjectType.SOFTWARE ? "software" : "business");
}


