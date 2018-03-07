package src.wso2.jira;
import  ballerina.io;
import ballerina.builtin;

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


public struct NewProjectCategory{
    string name;
    string description;
}


public enum AuthenticationType{
    BASIC
}


public enum ActorType{
    GROUP,USER
}

public enum AssigneeType {
    PROJECTLEAD,UNASSIGNED
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



public struct ConnectorError{
    string |type|;
    string message;
    json jiraServerErrorLog;
    error cause;
}