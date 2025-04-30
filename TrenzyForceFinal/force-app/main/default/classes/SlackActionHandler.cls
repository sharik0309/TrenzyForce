@RestResource(urlMapping='/SlackAction/*')
global without sharing class SlackActionHandler {
    
    @HttpPost
    global static void handleAction() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        
        System.debug('=== SlackActionHandler Start'); 
        System.debug('Request Header: '+req.headers); 
        System.debug('Request Params: '+req.params); 
        System.debug('Request Header: '+req.requestBody?.toString());
        
        String payload;
        // Support both Slack (x-www-form-urlencoded) and direct JSON POST
        if (req.params != null && req.params.containsKey('payload')) {
            payload = req.params.get('payload');
        } else if (req.requestBody != null) {
            payload = req.requestBody.toString();
        }
        
        if (String.isBlank(payload)) {
            res.statusCode = 400;
            res.responseBody = Blob.valueOf('{"error":"No payload provided"}');
            return;
        }
        
        try {
            // Parse JSON payload
            Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(payload);
            List<Object> actions = (List<Object>) data.get('actions');
            
            if (actions == null || actions.isEmpty()) {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf('{"error":"No actions found"}');
                return;
            }
            Map<String, Object> action = (Map<String, Object>) actions[0];
            String actionId = (String) action.get('action_id');
            String recordId = (String) action.get('value');
            
            System.debug('RECORDID'+recordId);
            System.debug('actionID'+actionId);
            
            if (String.isBlank(actionId) || String.isBlank(recordId)) {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf('{"error":"Missing action_id or recordId"}');
                return;
            }
            
            
            if (actionId == 'pause_campaign') {
            
               Ad_Campaign__c camp = [SELECT Id, Status__c FROM Ad_Campaign__c WHERE Id = :recordId LIMIT 1];
                camp.Status__c = 'Paused';
                update camp;
                
                
                res.statusCode = 200;
                res.responseBody = Blob.valueOf('{"status":"Campaign marked as completed"}');
            } 
            
            if (actionId == 'reallocate_budget') {
            
               Ad_Campaign__c campReallocate = [SELECT Id, Re_Allocate_Budget__c FROM Ad_Campaign__c WHERE Id = :recordId LIMIT 1];
                campReallocate.Re_Allocate_Budget__c  = true;
                update campReallocate;
                
                
                res.statusCode = 200;
                res.responseBody = Blob.valueOf('{"status":"Campaign marked as completed"}');
            } else {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf('{"error":"Unknown action_id"}');
            }
            
        } catch (Exception e) {
            res.statusCode = 500;
            System.debug('111111'+res.responseBody);
            res.responseBody = Blob.valueOf('{"error":' + JSON.serialize(e.getMessage()) + '}');
        }
    }
}