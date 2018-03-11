package test.wso2.jira;

import ballerina.test;
import ballerina.util;
import ballerina.mime;
import ballerina.io;


public function main (string[] args)  {
    SampleStruct source = {name:"Nipuna",state:State.OPEN};
    var target,_ = <json>source;
}




public struct SampleStruct {
    string name;
    State state;
}

public enum State{
    OPEN,CLOSED
}