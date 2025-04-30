// predictedSuccess.js
import { LightningElement, api, wire } from 'lwc';
import getPredictedSuccess from '@salesforce/apex/PredictedSuccessController.getPredictedSuccess';

export default class CampaignSuccessPredictionRateLwc extends LightningElement {
    @api recordId; // campaign record ID
    predictedSuccess;
    errorMessage; // property to store error messages

    @wire(getPredictedSuccess, { campaignId: '$recordId' })
    wiredPredictedSuccess({ error, data }) {
        if (data) {
            this.predictedSuccess = data;
            // Successfully fetched predicted success
        } else if (error) {
            this.errorMessage = 'An error occurred while fetching the predicted success rate.';
            // Optionally, log the error using a logging framework
            // logError('Error fetching predicted success:', error);
        }
    }
}