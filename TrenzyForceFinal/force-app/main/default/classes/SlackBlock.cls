public class SlackBlock {
    @InvocableMethod(label='Post Block Kit to Slack' description='Sends a Block Kit message to a Slack channel')
    public static void postToSlack(List<SlackMessageRequest> requests) {
        for (SlackMessageRequest request : requests) {
            sendBlockKitMessage(request.channelId, request.blockKitJson, request.message);
        }
    }

    @Future(callout=true)
    private static void sendBlockKitMessage(String channelId, String blockKitJson, String message) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        // Use Named Credential for secure endpoint management
        req.setEndpoint('callout:SlackAPI/chat.postMessage');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer '+[SELECT BotToken__c FROM SlackConfig__mdt LIMIT 1].BotToken__c);

        // Construct the payload
        Map<String, Object> payloadMap = new Map<String, Object>{
            'channel' => channelId
        };
        
        // Add blocks if blockKitJson is provided
        if (String.isNotBlank(blockKitJson)) {
            payloadMap.put('blocks', JSON.deserializeUntyped(blockKitJson));
        }
        
        // Add text message if provided
        if (String.isNotBlank(message)) {
            payloadMap.put('text', message);
        }

        req.setBody(JSON.serialize(payloadMap));

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

        @InvocableVariable(label='Block Kit JSON' required=false)
        public String blockKitJson;

        @InvocableVariable(label='Message' required=false)
        public String message;
    }
}