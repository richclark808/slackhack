@isTest
public with sharing class SlackPubllisherMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        // Create a fake response.
        // Set response values, and 
        // return response.
        HTTPResponse response = new HTTPResponse();
        response.setBody('success');
        if (req.getEndpoint() == 'http://TestFail')
            response.setStatusCode(401);
        else 
            response.setStatusCode(200);
        
        return response;
   }
}

         