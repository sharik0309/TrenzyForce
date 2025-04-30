import { LightningElement, api, wire } from 'lwc';
import getSpends from '@salesforce/apex/TrenzyAdSpendsController.getSpends';

export default class TrenzyAdSpends extends LightningElement {
    @api recordId; // AdCampaign__c record ID from the page
    spends = [];
    columns = [
        { label: 'Ad Spend Date', fieldName: 'Ad_Spend_Date__c', type: 'Date' },
        { label: 'CTR', fieldName: 'CTR__c', type: 'number' },
        { label: 'Clicks', fieldName: 'Clicks__c', type: 'number' },
        { label: 'Conversions', fieldName: 'Conversions__c', type: 'number' },
        { label: 'CPC', fieldName: 'CPC__c', type: 'number' },
        { label: 'CPM', fieldName: 'CPM__c', type: 'number' },
        { label: 'Impressions', fieldName: 'Impressions__c', type: 'number' }
    ];

    // @wire(getRelatedListRecords, {
    //     parentRecordId: '$recordId',
    //     relatedListId: 'Trenzy_Ad_Spends__r',
    //     fields: [DATE_FIELD, AMOUNT_FIELD]
    // })
    // spends;

    @wire(getSpends, { recordId: '$recordId' })
    spends({ error, data }) {
        if (data) {
            this.spends = data;
            console.log('Fetched spends:', this.spends);
        } else if (error) {
            console.error('Error fetching spends:', error);
        }
    }
}