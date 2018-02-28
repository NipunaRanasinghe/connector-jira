package src.wso2.jira.models;


public struct ProjectPointer {
    string self;
    string key;
}

public struct Project {
    string self;
    string id;
    string key;
    string name;
    string description;
    ProjectCategory category;
    //ProjectComponentPointer[] components;
    Lead lead;
 //   IssueTypePointer[] issueTypes;
    string email;
    string assigneeType;
    map versions;
    ProjectRolePointer[] roles;
    string projectTypeKey;
}
public struct ProjectCategory {
    string self;
    string id;
    string name;
    string description;
}



public struct ProjectComponentPointer {
    string self;
    string name;
}

public struct User{
    string self;
    string key;
    string name;
    string displayName;
    string emailAddress;
    map avatarUrls;
    boolean active;
    string timeZone;
    string locale;
}


public struct LeadPointer {
    string self;
    string name;
}


public struct Lead {
    User user;
}


public struct ProjectRolePointer {
    string self;
    string name;
}

public struct ProjectRole {
    string self;
    string name;
    string id;
    string description;
    Actor[] actors;
}


public struct Actor {
    string id;
    string displayName;
    string |type|;
    string name;
}




