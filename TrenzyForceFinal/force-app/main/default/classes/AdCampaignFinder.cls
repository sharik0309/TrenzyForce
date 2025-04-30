public with sharing class AdCampaignFinder {
    
    /**
     * Finds an Ad_Campaign__c record based on input string containing the Auto Number (CMP-0003).
     * @param inputString The input string that contains the Auto Number.
     * @return A formatted response string.
     */
    @invocableMethod
    public static List<Response> findCampaignRecord(List<Request> inputList) {
        String inputString;
        List<Response> responses = new List<Response>();
        List<Ad_Campaign__c> adCampaigns = new List<Ad_Campaign__c>();
        for(Request input : inputList){
     	inputString = input.campaignName;
        // Find pattern like CMP-0003
        Pattern cmpPattern = Pattern.compile('(CMP-\\d{4,})');
        Matcher cmpMatcher = cmpPattern.matcher(inputString);
        
        Response response= new Response();
        if (cmpMatcher.find()) {
            String autoNumber = cmpMatcher.group(1);
            
            // Query the record
            Ad_Campaign__c inputCampaign = [
                SELECT Id, Name, Campaign_Name__c ,Clicks__c ,CPM__c ,CTR__c,Brand__c,Budget_Remaining__c,Budget_Allocated__c 
                FROM Ad_Campaign__c
                WHERE Name = :autoNumber
                LIMIT 1
            ];
            
            if (inputCampaign != null) {
                 adCampaigns = [Select Id,Name,Campaign_Name__c,CTR__c,Budget_Remaining__c,Budget_Allocated__c from Ad_Campaign__c where Brand__c  =: inputCampaign.Brand__c   
                               				and Id!=:inputCampaign.Id order by CTR__c desc limit 2];
           
            if (adCampaigns != null && adCampaigns.size()>0) {
                String jsonString = JSON.serialize(adCampaigns);
                response.Prompt = jsonString;
                
            } else {
                 response.Prompt = 'No Record found with AutoNumber:'+autoNumber;
            }
        } else {
             response.Prompt = 'Error: No valid Campaign AutoNumber found in input.';
        }
        responses.add(response);
        }
        
    }
        return responses;
    }

    public class Request{
        @InvocableVariable
        public String CampaignName;
    }    
    public class Response{
        @InvocableVariable
        public String Prompt;
    }
}