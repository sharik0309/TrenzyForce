/**
 * @description       : 
 * @author            : InMobi
 * @group             : 
 * @last modified on  : 04-30-2025
 * @last modified by  : InMobi
**/
public with sharing class TrenzyAdSpendsController {
    @AuraEnabled(cacheable=true)
    public static List<Ad_Spends__c> getSpends(Id recordId) {
        /*return [
            SELECT Id, Trenzy_Key__c, ctr__c, budget_allocated__c, budget_spent__c
            FROM Trenzy_Ad_Spends__dlm
            WHERE KQ_id1__c = :recordId
        ];*/
        return [
            SELECT Id, Ad_Spend_Date__c, CTR__c , Clicks__c, Conversions__c,CPC__c,CPM__c,Impressions__c 
            FROM Ad_Spends__c
            WHERE Ad_Campaign__c = :recordId
        ];
    }
}