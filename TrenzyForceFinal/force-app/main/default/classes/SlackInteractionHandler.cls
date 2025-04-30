@RestResource(urlMapping='/SlackInteractionHandler')
global with sharing class SlackInteractionHandler {

   /* @HttpPost
    global static void handleSlackInteraction() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        // Decode Slack's payload
        String encodedBody = req.requestBody.toString();
        System.debug('Raw Incoming: ' + encodedBody);

        if (!encodedBody.startsWith('payload=')) {
            res.statusCode = 400;
            res.responseBody = Blob.valueOf('Invalid payload');
            return;
        }

        String decodedPayload = EncodingUtil.urlDecode(encodedBody.replaceFirst('payload=', ''), 'UTF-8');
        Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(decodedPayload);
        System.debug('Decoded Payload: ' + payload);

        // Extract key data
        String triggerId = (String) payload.get('trigger_id');
        List<Object> actions = (List<Object>) payload.get('actions');
        Map<String, Object> firstAction = (Map<String, Object>) actions[0];
        String actionId = (String) firstAction.get('action_id');
        String campaignId = (String) firstAction.get('value'); // Assuming we passed Campaign ID in button

        if (actionId != 'reallocate_budget') {
            res.statusCode = 200;
            res.responseBody = Blob.valueOf('Ignored non-budget action');
            return;
        }

        // Get campaign details
        Ad_Campaign__c campaign = [SELECT Id, Name, CTR__c FROM Ad_Campaign__c WHERE Id = :campaignId LIMIT 1];

        // Build Slack modal
        Map<String, Object> modalPayload = new Map<String, Object>{
            'trigger_id' => triggerId,
            'view' => new Map<String, Object>{
                'type' => 'modal',
                'callback_id' => 'reallocate_modal',
                'title' => new Map<String, Object>{ 'type' => 'plain_text', 'text' => 'Reallocate Budget' },
                'submit' => new Map<String, Object>{ 'type' => 'plain_text', 'text' => 'Submit' },
                'blocks' => new List<Object>{
                    new Map<String, Object>{
                        'type' => 'section',
                        'text' => new Map<String, Object>{
                            'type' => 'mrkdwn',
                            'text' => '*Campaign Name:* ' + campaign.Name + '\n*CTR:* ' + campaign.CTR__c + '%\n*Current Budget:* $' 
                        }
                    },
                    new Map<String, Object>{
                        'type' => 'input',
                        'block_id' => 'budget_block',
                        'element' => new Map<String, Object>{
                            'type' => 'plain_text_input',
                            'action_id' => 'new_budget',
                            'placeholder' => new Map<String, Object>{ 'type' => 'plain_text', 'text' => 'Enter new budget (USD)' }
                        },
                        'label' => new Map<String, Object>{ 'type' => 'plain_text', 'text' => 'New Budget' }
                    }
                }
            }
        };

        // Call Slack API (views.open)
        HttpRequest slackReq = new HttpRequest();
        slackReq.setEndpoint('callout:SlackAPI/api/views.open');
        slackReq.setMethod('POST');
        slackReq.setHeader('Content-Type', 'application/json');
        slackReq.setBody(JSON.serialize(modalPayload));

        Http http = new Http();
        HttpResponse slackRes = http.send(slackReq);

        System.debug('Slack Modal Response: ' + slackRes.getBody());
        res.statusCode = 200;
        res.responseBody = Blob.valueOf('Modal launched');
    } */
}