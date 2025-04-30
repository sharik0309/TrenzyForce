// PredictedSuccessController.cls
public with sharing class PredictedSuccessController {
    
    @AuraEnabled(cacheable=true)
    public static Decimal getPredictedSuccess(Id campaignId) {
        String cname  = [
            SELECT id,name 
            FROM Ad_Campaign__c 
            WHERE Id = :campaignId
            LIMIT 1
        ].name;
        


        Trenzy_Campaign_Success_Prediction_Job__dlm prediction = [
            SELECT success__c
            FROM Trenzy_Campaign_Success_Prediction_Job__dlm
            WHERE PrimaryObjectPk__c = : cname
            LIMIT 1
        ];

        


        
        
        if (prediction != null && prediction.success__c != null) {
            return prediction.success__c.setScale(2, RoundingMode.HALF_UP);
        } else {
            return null;
        }
    }
}