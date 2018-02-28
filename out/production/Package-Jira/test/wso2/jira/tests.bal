package test.wso2.jira;

import ballerina.test;
import ballerina.util;
import ballerina.mime;
import ballerina.io;

function testBoolean () {
    test:assertBooleanEquals(true,false, "Value doesn't match");
    io:println("Hello World!");




}
public enum State {
    OPEN,
    CLOSED,
    ALL
}
public function main (string[] args)  {
    io:println(typeof State.OPEN);
}
