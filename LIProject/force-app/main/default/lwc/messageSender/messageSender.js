import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import sendMessage from '@salesforce/apex/TwilioMessageHelper.sendAccountMessage'

export default class MessageSender extends LightningElement {
    @api recordId;
    messageBody = '';
    sending = false;
    @track error;
    @track success;

    handleSendSMS(event){
        // only send message if it's > 0 
        if(this.messageBody.length > 0){
            this.sending = true;
            sendMessage({accId: this.recordId, messageBody: this.messageBody})
                .then(result => {
                    this.sending = false;
                    this.messageBody = '';
                    const evt = new ShowToastEvent({
                        title: 'Success',
                        message: 'Successfully sent message.',
                        variant: 'success'
                    });
                    this.dispatchEvent(evt);
                })
                .catch(error => {
                    this.sending = false;
                    const evt = new ShowToastEvent({
                        title: 'Error',
                        message: error,
                        variant: 'error'
                    });
                    this.dispatchEvent(evt);
                })
        }
    }

    handleInputChange(event) {
        this.messageBody = event.detail.value;
    }

    handleInputFocus(event) {
        // modify parent to properly highlight visually
        const classList = event.target.parentNode.classList;
        classList.add('lgc-highlight');
    }

    handleInputBlur(event) {
        // modify parent to properly remove highlight
        const classList = event.target.parentNode.classList;
        classList.remove('lgc-highlight');
    }
}