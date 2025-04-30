/**
 *  Class Name: SlackMessageActionSender
 *  Description:  This class will be used in the flow to send message with blocks via Slack.
 *  Author: Jakson Monteiro
 *  Created: April 16, 2025
 */

public class SlackBlockKitSender {
    @InvocableMethod(label='Post Block Kit to Slack' description='Sends a Block Kit message to a Slack channel')
    public static void postToSlack(List<SlackMessageRequest> requests) {
        for (SlackMessageRequest request : requests) {
            sendBlockKitMessage(request.channelId, request.blockKitJson);
        }
    }

    @Future(callout=true)
    private static void sendBlockKitMessage(String channelId, String blockKitJson) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        // Use Named Credential for secure endpoint management
        req.setEndpoint('callout:SlackAPI/chat.postMessage');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer '+[SELECT BotToken__c FROM SlackConfig__mdt LIMIT 1].BotToken__c); // If using bot token

        // Construct the payload
        String payload = JSON.serialize(new Map<String, Object>{
            'channel' => channelId,
            'blocks' => JSON.deserializeUntyped(blockKitJson)
        });

        req.setBody(payload);

        try {
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                System.debug('Message sent successfully: ' + res.getBody());
            } else {
                System.debug('Error sending message: ' + res.getStatusCode() + ' ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }
    }

    // Input wrapper class for invocable method
    public class SlackMessageRequest {
        @InvocableVariable(label='Channel ID' required=true)
        public String channelId;

        @InvocableVariable(label='Block Kit JSON' required=true)
        public String blockKitJson;
    }
}