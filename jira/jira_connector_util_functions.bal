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

package jira;
import ballerina/net.http;
import ballerina/config;
import ballerina/mime;
import ballerina/io;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                  Functions                                                        //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@Description {value:"Add authoriaztion header to the request"}
@Param {value:"authType: Authentication type preferred by the user"}
@Param {value:"request: The http out request object"}
public function constructAuthHeader (http:Request request) {

    //read "authentication_type" field from ballerina.conf
    if (base64EncodedString != "") {
        request.addHeader("Authorization", "Basic " + base64EncodedString);
    }
}

@Description {value:"Checks whether the http response contains any errors "}
@Param {value:"request: The http response object"}
@Param {value:"connectionError: http response error object"}
public function getValidatedResponse (http:Response|http:HttpConnectorError httpConnectorResponse) returns json|JiraConnectorError {

    JiraConnectorError e = {};
    mime:EntityError err = {};
    json jsonResponse;
    //checks for any http errors
    match httpConnectorResponse {
        http:HttpConnectorError errorOut => {
            e = {^"type":"HTTP Error", message:errorOut.message, cause:connectionError.cause};
            return e;
        }
        http:Response response => {
            if (response.statusCode != STATUS_CODE_OK && response.statusCode != STATUS_CODE_CREATED
                && response.statusCode != STATUS_CODE_NO_CONTENT) {//checks for invalid server responses
                e = {^"type":"Server Error", message:"status " + <string>response.statusCode + ": " + response.reasonPhrase};
                var payloadOutput = response.getJsonPayload();
                match payloadOutput {
                    json jsonOutput => e.jiraServerErrorLog = jsonOutput;
                    mime:EntityError errorOut => err = errorOut;
                }
                return e;

            } else {//if there is no any http or server error
                var payloadOutput = response.getJsonPayload();
                match payloadOutput {
                    json jsonOutput => jsonResponse = jsonOutput;
                    mime:EntityError errorOut => err = errorOut;
                }
                return jsonResponse;
            }
        }
    }
}

function validateAuthentication (string username, string password) returns boolean|JiraConnectorError {
    endpoint http:ClientEndpoint jiraLoginHttpClientEP {targets:[{uri:jira_authentication_ep}], chunking:http:Chunking.NEVER,
        followRedirects:{enabled:true, maxCount:5}};

    JiraConnectorError e = {};
    error err = {};
    mime:EntityError errr = {};
    json jsonResponse;
    json jsonPayload;
    http:Request request = {};

    jsonPayload = {"username":username, "password":password};
    request.setJsonPayload(jsonPayload);

    var output = jiraLoginHttpClientEP -> post("/", request);
    match output {
        http:HttpConnectorError errorOut => {
            e = {^"type":"HTTP Error", message:errorOut.message, cause:errorOut.cause};
            return e;
        }

        http:Response response => {
            if (response.statusCode != STATUS_CODE_OK) {
                e = {^"type":"Server Error", message:"status " + <string>response.statusCode + ": " + response.reasonPhrase};
                var payloadOutput = response.getJsonPayload();
                match payloadOutput {
                    json jsonOutput => e.jiraServerErrorLog = jsonOutput;
                    mime:EntityError errorOut => errr = {};
                }
                return e;
            } else {
                return true;
            }
        }
    }

}


function getProjectRoleIdFromEnum (ProjectRoleType ^"type") returns string {
    if (^"type" == ProjectRoleType.ADMINISTRATORS) {
        return ROLE_ID_ADMINISTRATORS;
    } else if (^"type" == ProjectRoleType.CSAT_ADMINISTRATORS) {
        return ROLE_ID_CSAT_DEVELOPERS;
    } else if (^"type" == ProjectRoleType.DEVELOPERS) {
        return ROLE_ID_DEVELOPERS;
    } else if (^"type" == ProjectRoleType.EXTERNAL_CONSULTANT) {
        return ROLE_ID_EXTERNAL_CONSULTANTS;
    } else if (^"type" == ProjectRoleType.NOTIFICATIONS) {
        return ROLE_ID_NOTIFICATIONS;
    } else if (^"type" == ProjectRoleType.OBSERVER) {
        return ROLE_ID_OBSERVER;
    } else if (^"type" == ProjectRoleType.USERS) {
        return ROLE_ID_USERS;
    } else {
        return "";
    }
}

function getProjectTypeFromEnum (ProjectType projectType) returns string {
    return (projectType == ProjectType.SOFTWARE ? "software" : "business");
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                  Transformers                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


transformer <error source, JiraConnectorError target> toConnectorError() {
    target = source.message != "" ? {message:source.message, cause:source.cause} : {};
}

transformer <ProjectRequest source, json target> ProjectRequestToJson() {
    target.key = source.key != "" ? source.key : null;
    target.name = source.name != "" ? source.name : null;
    target.projectTypeKey = source.projectTypeKey != "" ? source.projectTypeKey : null;
    target.projectTemplateKey = source.projectTemplateKey != "" ? source.projectTemplateKey : null;
    target.description = source.description != "" ? source.description : null;
    target.lead = source.lead != "" ? source.lead : null;
    target.url = source.url != "" ? source.url : null;
    target.assigneeType = source.assigneeType != "" ? source.assigneeType : null;
    target.avatarId = source.avatarId != "" ? source.avatarId : null;
    target.issueSecurityScheme = source.issueSecurityScheme != "" ? source.issueSecurityScheme : null;
    target.permissionScheme = source.permissionScheme != "" ? source.permissionScheme : null;
    target.notificationScheme = source.notificationScheme != "" ? source.notificationScheme : null;
    target.categoryId = source.categoryId != "" ? source.categoryId : null;
}

transformer <json source, ProjectSummary target> jsonToProjectSummary() {
    target.self = source.self.toString();
    target.id = source.id.toString();
    target.key = source.key.toString();
    target.name = source.name.toString();
    target.description = source.description != null ? source.description.toString() : "";
    target.projectTypeKey = source.projectTypeKey.toString();
    target.category = source.projectCategory != null ? source.projectCategory.name.toString() : "";
}

transformer <json source, ProjectCategory target> jsonToProjectCategory() {
    target.self = source.self != null ? source.self.toString() : "";
    target.name = source.name != null ? source.name.toString() : "";
    target.id = source.id != null ? source.id.toString() : "";
    target.description = source.description != null ? source.description.toString() : "";
}

function isEmpty (error|JiraConnectorError e) returns boolean {
    match e {
        error err => return err.message == "";
        JiraConnectorError err => return err.message == "";
    }
}

function jsonToIssue (json source) returns Issue|error {
    Issue target = {};
    target.self = source.self.toString();
    target.id = source.id.toString();
    target.key = source.key.toString();

    target.summary = source.fields != null ?
                     source.fields.summary != null ?
                     source.fields.summary.toString() : "" : "";

    target.creatorName = source.fields != null ?
                         source.fields.creator != null ?
                         source.fields.creator.name != null ?
                         source.fields.creator.name.toString() : "" : "" : "";

    target.assigneeName = source.fields != null ?
                          source.fields.assignee != null ?
                          source.fields.assignee.name != null ?
                          source.fields.assignee.name.toString() : "" : "" : "";

    target.reporterName = source.fields != null ?
                          source.fields.reporter != null ?
                          source.fields.reporter.name != null ?
                          source.fields.reporter.name.toString() : "" : "" : "";

    target.priorityId = source.fields != null ?
                        source.fields.priority != null ?
                        source.fields.priority.id != null ?
                        source.fields.priority.id.toString() : "" : "" : "";

    target.resolutionId = source.fields != null ?
                          source.fields.resolution != null ?
                          source.fields.resolution.id != null ?
                          source.fields.resolution.id.toString() : "" : "" : "";

    target.statusId = source.fields != null ?
                      source.fields.status != null ?
                      source.fields.status.id != null ?
                      source.fields.status.id.toString() : "" : "" : "";

    target.timespent = source.fields != null ?
                       source.fields.timespent != null ?
                       source.fields.timespent.toString() : "" : "";

    target.aggregatetimespent = source.fields != null ?
                                source.fields.aggregatetimespent != null ?
                                source.fields.aggregatetimespent.toString() : "" : "";

    target.createdDate = source.fields != null ?
                         source.fields.createdDate != null ?
                         source.fields.createdDate.toString() : "" : "";

    target.dueDate = source.fields != null ?
                     source.fields.dueDate != null ?
                     source.fields.dueDate.toString() : "" : "";

    target.resolutionDate = source.fields != null ?
                            source.fields.resolutionDate != null ?
                            source.fields.resolutionDate.toString() : "" : "";

    target.project = source.fields != null ?
                     source.fields.project != null ?
                     <ProjectSummary, jsonToProjectSummary()>source.fields.project : {} : {};

    target.parent = source.fields != null ?
                    source.fields.parent != null ?
                    jsonToIssueSummary(source.fields.parent) : {} : {};

    json jsonIssueType = source.fields != null ?
                         source.fields.issueType != null ?
                         source.fields.issueType : null : null;
    if (jsonIssueType != null) {
        var out = <IssueType>jsonIssueType;
        match out {
            IssueType issueType => target.issueType = issueType;
            error e => target.issueType = {};
        }
    } else {
        target.issueType = {};
    }

    int i = 0;
    foreach (field in source.fields.getKeys()) {
        if (field.hasPrefix("custom_field")) {
            target.customFields[i] = source.fields.field;
            i = i + 1;
        }
    }

    return target;
}


function jsonToIssueSummary (json source) returns IssueSummary {
    IssueSummary target = {};
    target.self = source.self.toString();
    target.id = source.id.toString();
    target.key = source.key.toString();

    target.priorityId = source.priority != null ?
                        source.priority.id != null ?
                        source.priority.id.toString() : "" : "";

    target.statusId = source.status != null ?
                      source.status.id != null ?
                      source.status.id.toString() : "" : "";

    json jsonIssueType = source.fields != null ?
                         source.fields.issueType != null ?
                         source.fields.issueType : null : null;
    if (jsonIssueType != null) {
        var out = <IssueType>jsonIssueType;
        match out {
            IssueType issueType => target.issueType = issueType;
            error e => target.issueType = {};
        }
    } else {
        target.issueType = {};
    }

    return target;
}


