package src.wso2.jira;
import  ballerina.io;
import src.wso2.jira.utils.constants;
import src.wso2.jira.models;
import ballerina.net.http;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                               Jira Project                                                         //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public struct ProjectSummary {
    string self;
    string id;
    string key;
    string name;
    string description;
    string leadName;
    string email;
    ProjectCategory projectCategory;
    IssueType[] issueTypes;
    ProjectComponentSummary[] components;
    string projectTypeKey;
}

public function <ProjectSummary project> getProjectLeadDetails()(User,JiraConnectorError){
    endpoint<http:HttpClient> jiraClient{
        create http:HttpClient (constants:JIRA_API_ENDPOINT,getHttpConfigs());
    }
    http:HttpConnectorError httpError;
    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e;
    json jsonResponse;
    error err;
    User lead;

    if(project==null) {
        e = {message:"Unable to proceed with a null structure", cause:null};
        return null,e;
    }

    constructAuthHeader(AuthenticationType.BASIC,request);
    response, httpError = jiraClient.get("/user?username="+project.leadName, request);
    jsonResponse, e = validateResponse(response, httpError);

    if (e != null) {
        return null, e;
    }

    else {
        lead, err = <User>jsonResponse;
        e = <JiraConnectorError,toConnectorError()>err;
        return lead,e;
    }



}


public function <ProjectSummary project> getRole(ProjectRoleType projectRoleType)(ProjectRole , JiraConnectorError ){
    endpoint<http:HttpClient> jiraClient{
        create http:HttpClient (constants:JIRA_API_ENDPOINT,getHttpConfigs());
    }
    http:HttpConnectorError httpError;
    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e;
    json jsonResponse;

    if(project==null) {
        e = {message:"Unable to proceed with a null structure", cause:null};
        return null,e;
    }

    constructAuthHeader(AuthenticationType.BASIC,request);
    response, httpError = jiraClient.get("/project/" + project.key + "/role/" + getProjectRoleIdFromEnum(projectRoleType), request);
    jsonResponse, e = validateResponse(response, httpError);

    if (e != null) {
        return null, e;
    }

    else {
        var role, err = <ProjectRole>jsonResponse;
        if(err!=null){
            e = <JiraConnectorError,toConnectorError()>err;
            return null,e;
        }
        return role, e;
    }
}


public function <ProjectSummary project> getStatuses()(ProjectStatus[], JiraConnectorError ){
    endpoint<http:HttpClient> jiraClient{
        create http:HttpClient (constants:JIRA_API_ENDPOINT,getHttpConfigs());
    }
    http:HttpConnectorError httpError;

    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e;
    error err;
    json jsonResponse;
    json[] jsonResponseArray;
    ProjectStatus[] statusArray = [];

    if(project==null) {
        e = {message:"Unable to proceed with a null structure", cause:null};
        return null,e;
    }

    constructAuthHeader(AuthenticationType.BASIC,request);
    response, httpError = jiraClient.get("/project/" + project.key +"/statuses", request);
    jsonResponse, e = validateResponse(response, httpError);

    if (e != null) {
        return null, e;
    }

    else {
        jsonResponseArray,err = (json[])jsonResponse;
        if(err!=null){
            e = <JiraConnectorError,toConnectorError()>err;
            return null,e;
        }
        else {
            int x = 0;
            foreach (i in jsonResponseArray) {
                statusArray[x],err = <ProjectStatus>jsonResponseArray[x];
                if(err!=null){
                    e = <JiraConnectorError,toConnectorError()>err;
                    return null,e;
                }
                x=x+1;
            }

            return statusArray,null;
        }
    }

}


public function <ProjectSummary project> addActorToRole(ProjectRoleType projectRoleType,SetActor actor)(boolean,JiraConnectorError){
    endpoint<http:HttpClient> jiraClient{
        create http:HttpClient (constants:JIRA_API_ENDPOINT,getHttpConfigs());
    }
    http:HttpConnectorError httpError;
    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e = {message:""};
    json jsonPayload;
    json jsonResponse;

    constructAuthHeader(AuthenticationType.BASIC,request);

    jsonPayload = models:addActorToRoleSchema;

    if(actor.|type|==ActorType.USER) {
        jsonPayload["user"][0]= actor.name;
    }

    else if(actor.|type|==ActorType.GROUP) {
        jsonPayload["group"][0]= actor.name;
    }

    else{
        e.message="actor type is not specified correctly";
        return false,e;
    }

    request.setJsonPayload(jsonPayload);
    response, httpError = jiraClient.post("/project/" + project.key +"/role/"+ getProjectRoleIdFromEnum(projectRoleType), request);
    jsonResponse, e = validateResponse(response, httpError);

    if (e != null) {
        return false, e;
    }

    else {
        io:println(jsonResponse);
        return true, null;
    }

}


public function <ProjectSummary project> updateProjectType(ProjectType newProjectType)(boolean,JiraConnectorError){
    endpoint<http:HttpClient> jiraClient{
        create http:HttpClient (constants:JIRA_API_ENDPOINT,getHttpConfigs());
    }
    http:HttpConnectorError httpError;

    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e = {message:""};
    json jsonResponse;

    constructAuthHeader(AuthenticationType.BASIC,request);


    response, httpError = jiraClient.put("/project/" + project.key +"/type/"+ getProjectTypeFromEnum(newProjectType), request);
    jsonResponse, e = validateResponse(response, httpError);

    if (e != null) {
        return false, e;
    }

    else {
        return true, null;
    }

}


//public function <ProjectSummary project> getAllComponents()(ProjectComponent[], JiraConnectorError ){
//    endpoint<http:HttpClient> jiraClient{
//        create http:HttpClient (constants:JIRA_API_ENDPOINT,getHttpConfigs());
//    }
//    http:HttpConnectorError httpError;
//
//    http:OutRequest request = {};
//    http:InResponse response = {};
//    JiraConnectorError e;
//    error err;
//    json jsonResponse;
//    json[] jsonResponseArray;
//    ProjectStatus[] statusArray = [];
//
//    if(project==null) {
//        e = {message:"Unable to proceed with a null structure", cause:null};
//        return null,e;
//    }
//
//    constructAuthHeader(AuthenticationType.BASIC,request);
//    response, httpError = jiraClient.get("/project/" + project.key +"/statuses", request);
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
//}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


struct BasicAuth {
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

public struct NewProjectCategory{
    string name;
    string description;
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
    //AssigneeType assigneeType;
    int avatarId;
    int issueSecurityScheme;
    int permissionScheme;
    int notificationScheme;
    int categoryId;
}



public struct JiraConnectorError{
    string |type|;
    string message;
    json jiraServerErrorLog;
    error cause;
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                         Enums                                                      //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


public enum AuthenticationType{
    BASIC
}


public enum ActorType{
    GROUP,USER
}

public enum AssigneeType {
    PROJECTLEAD,UNASSIGNED
}

public enum ProjectRoleType{
    DEVELOPERS,EXTERNAL_CONSULTANT,OBSERVER,ADMINISTRATORS,USERS,CSAT_ADMINISTRATORS,NOTIFICATIONS
}

public enum ProjectType{
    SOFTWARE,BUSINESS
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


public struct IssueType{
    string self;
    string id;
    string name;
    string description;
    string iconUrl;
    boolean subtask;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                   Component                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public struct ProjectComponent{
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

public struct ProjectComponentSummary{
    string self;
    string id;
    string name;
    string description;
}

public function <ProjectComponentSummary projectComponentSummary> fetchComponent()(ProjectComponent,JiraConnectorError){
    endpoint<http:HttpClient> jiraClient{
        create http:HttpClient (constants:JIRA_API_ENDPOINT,getHttpConfigs());
    }
    http:HttpConnectorError httpError;

    http:OutRequest request = {};
    http:InResponse response = {};
    JiraConnectorError e;
    error err;
    json jsonResponse;
    json[] jsonResponseArray;


    if(projectComponentSummary==null) {
        e = {message:"Unable to proceed with a null structure", cause:null};
        return null,e;
    }

    constructAuthHeader(AuthenticationType.BASIC,request);
    response, httpError = jiraClient.get("/component/" + projectComponentSummary.id, request);
    jsonResponse, e = validateResponse(response, httpError);

    if (e != null) {
        return null, e;
    }

    else {
        var projectComponent,err = <ProjectComponent>jsonResponse;
        if(err!=null){
            e = <JiraConnectorError,toConnectorError()>err;
            return null,e;
        }
        return projectComponent,e;
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////





////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function getProjectRoleIdFromEnum(ProjectRoleType |type|)(string){
    if (|type|==ProjectRoleType.ADMINISTRATORS) {return constants:ROLE_ID_ADMINISTRATORS;}
    else if (|type|==ProjectRoleType.CSAT_ADMINISTRATORS) {return constants:ROLE_ID_CSAT_DEVELOPERS;}
    else if (|type|==ProjectRoleType.DEVELOPERS) {return constants:ROLE_ID_DEVELOPERS;}
    else if (|type|==ProjectRoleType.EXTERNAL_CONSULTANT) {return constants:ROLE_ID_EXTERNAL_CONSULTANTS;}
    else if (|type|==ProjectRoleType.NOTIFICATIONS) {return constants:ROLE_ID_NOTIFICATIONS;}
    else if (|type|==ProjectRoleType.OBSERVER) {return constants:ROLE_ID_OBSERVER;}
    else if (|type|==ProjectRoleType.USERS) {return constants:ROLE_ID_USERS;}
    else{ return "";}
}

function getProjectTypeFromEnum(ProjectType projectType)(string){
    return (projectType==ProjectType.SOFTWARE?"software":"business");
}


