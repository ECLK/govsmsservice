import ballerina/http;
import ballerina/config;
import chamil/govsms;
import ballerina/log;

listener http:Listener hl = new(9090);

govsms:Configuration govsmsConfig = {
     username: config:getAsString("eclk.govsms.username"),
     password: config:getAsString("eclk.govsms.password")
};
govsms:Client smsClient = new (govsmsConfig);
string sourceDepartment = config:getAsString("eclk.govsms.source");

@http:ServiceConfig {
    basePath: "/"
}
service GovSMS on hl {
    @http:ResourceConfig {
        path: "/send/{targetMobile}",
        body: "message",
        methods: ["POST"]
    }
    resource function sendSMS(http:Caller hc, http:Request hr, string targetMobile, string message) returns @tainted error? {
        log:printInfo(string`Sending SMS to ${targetMobile}`);
        govsms:Response gr = check smsClient->sendSms(sourceDepartment, <@untainted> message, <@untainted> targetMobile);
        check hc->accepted(<@untainted> gr.toString());
    }
}
