import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

// Import the Discount__c field
import DISCOUNT_FIELD from '@salesforce/schema/Account.Applicable_Discount__c';

export default class DiscountDisplay extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: [DISCOUNT_FIELD] })
    account;
}