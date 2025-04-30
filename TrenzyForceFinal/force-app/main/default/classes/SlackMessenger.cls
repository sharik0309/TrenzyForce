/**
 *  Class Name: SlackMessenger
 *  Description:  This class will be used in the flow to send message to Slack Channel as a TrenzyBot created in Slack.
 *  Author: Jakson Monteiro
 *  Created: April 16, 2025
 */
public class SlackMessenger {
@InvocableMethod(label='Post to Slack' description='Send a message to a Slack channel' iconName='slds:standard:slack')
    public static void postToSlack(List<Request> requests)
    {
        for(Request req : requests) {
            sendMessage(req.channel, req.message);
        }
    }
    
    @future(callout=true)
    private static void sendMessage(String channel, String message)
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:SlackAPI/chat.postMessage');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer '+[Select BotToken__c from SlackConfig__mdt  LIMIT 1].BotToken__c); //Replace here with BOT TOKEN
        String body = JSON.serialize(new Map<String,String>{
            'channel' => channel,
                'text' => message
        });
        request.setBody(body);
        
        try
        {
            HttpResponse response = http.send(request);
            if(response.getStatusCode() != 200)
            {
                System.debug('Error: ' +response.getbody());
            }
        }
        catch (Exception e)
        {
            System.debug('Exception: ' + e.getMessage());
        }
    }
    
    public class Request {
        @InvocableVariable(required= true)
        public String channel;
        @InvocableVariable(required=true)
        public String message;
    }
}