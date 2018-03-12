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
import ballerina.log;
import src.wso2.jira.utils.constants;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                  Functions                                                        //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@Description {value:"Add authoriaztion header to the request"}
@Param {value:"authType: Authentication type preferred by the user"}
@Param {value:"request: The http request object which is needed to be constructed"}
public function constructAuthHeader (AuthenticationType authType, http:OutRequest request) {

    if (authType == AuthenticationType.BASIC) {

        request.addHeader("Authorization", "Basic YXNoYW5Ad3NvMi5jb206YXNoYW4xMjM");
    }
}

@Description {value:"Checks whether the http response contains any errors "}
@Param {value:"request: The http response object"}
@Param {value:"httpError: http response error object"}
public function validateResponse (http:InResponse response, http:HttpConnectorError httpError) (json, JiraConnectorError) {
    JiraConnectorError e = {|type|:null, message:"", cause:null};

    if (httpError != null) {
        e.|type| = "HTTP Error";
        e.message = httpError.message;
        e.cause = httpError.cause;
        return null, e;
    }
    else if (response.statusCode != constants:STATUS_CODE_OK && response.statusCode != constants:STATUS_CODE_CREATED
             && response.statusCode != constants:STATUS_CODE_NO_CONTENT) {
        json res;
        e.|type| = "Server Error";
        e.message = response.reasonPhrase;
        e.message = "status " + <string>response.statusCode + ": " + e.message;
        try {
            res = response.getJsonPayload();
            e.jiraServerErrorLog = res;
        }
        catch (error err) {
            log:printError(err.message);
        }
        return null, e;

    }
    else {
        try {
            json jsonResponse = response.getJsonPayload();

            return jsonResponse, null;
        }
        catch (error err) {
            log:printError(err.message);
        }
        return null, null;


    }

}

public function getHttpConfigs () (http:Options) {

    http:Options option = {
                              ssl:{
                                      trustStoreFile:"${ballerina.home}/bre/security/ballerinaTruststore.p12",
                                      trustStorePassword:"ballerina"
                                  },
                              followRedirects:{},
                              chunking:"never"
                          };
    return option;
}



transformer <error source, JiraConnectorError target> toConnectorError() {
    target = source != null ? {message:source.message, cause:source.cause} : null;
}



transformer <ProjectUpdate source, json target> toJsonProject() {
    target.key = source.key != "" ? (json)source.key : null;
    target.name = source.name != "" ? (json)source.name : null;
    target.projectTypeKey = source.projectTypeKey != "" ? (json)source.projectTypeKey : null;
    target.projectTemplateKey = source.projectTemplateKey != "" ? (json)source.projectTemplateKey : null;
    target.description = source.description != "" ? (json)source.description : null;
    target.lead = source.lead != "" ? (json)source.lead : null;
    target.url = source.lead != "" ? (json)source.url : null;
    target.assigneeType = source.assigneeType!=""?(json)source.assigneeType:null;
    target.avatarId = source.avatarId!=0?(json)source.avatarId:null;
    target.issueSecurityScheme = source.issueSecurityScheme!=0?(json)source.issueSecurityScheme:null;
    target.permissionScheme = source.permissionScheme!=0?(json)source.permissionScheme:null;
    target.notificationScheme = source.notificationScheme!=0?(json)source.notificationScheme:null;
    target.categoryId = source.categoryId!=0?(json)source.categoryId:null;
}
