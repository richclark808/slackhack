public with sharing class SlackPublisher {
    
    // Step 1 = Replace the URL Webhook with the one you created in Slack, this is unique
    // to YOUR channel. This one will be deleted after the webinar
    private static final String slackURL = 'https://hooks.slack.com/services/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';
    
    // We use an inner class to encapsulate the attributes we want to receive
    // from Salesforce. We can easily extend this to include extra info, such 
    // as for posting attachments 
    public class MessagePost {
        @InvocableVariable(label='Slack Message')
        public String postText;        
    }
    
    // I like invocable apex as I can write utility classes that are well maintained,
    // unit tested and stable. Our Admins can then break it from Declarative usage and
    // they get to fix the issues instead of me ;)
    @InvocableMethod(label='Post Simple Message to Slack')
    public static void postToSlack(List<MessagePost> msgs) {
        // We're only posting the first one here to avoid overloading Slack channel
        // I'd recommend against mass posts, your slack users will leave the channel if you do!
        MessagePost p = msgs[0];   
        Map<String,Object> msg = new Map<String,Object>();
        msg.put('text', p.postText);
        msg.put('mrkdwn', true);
        String body = JSON.serialize(msg);    
        System.enqueueJob(new QueueableSlackCall(slackURL, 'POST', body));
    }


    public class QueueableSlackCall implements System.Queueable, Database.AllowsCallouts {
         
        private final String url;
        private final String method;
        private final String body;
         
        public QueueableSlackCall(String url, String method, String body) {
            this.url = url;
            this.method = method;
            this.body = body;
        }
         
        public void execute(System.QueueableContext ctx) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod(method);
            req.setBody(body);
            Http http = new Http();
            HttpResponse res = http.send(req);
        }
 
    }
    
}
