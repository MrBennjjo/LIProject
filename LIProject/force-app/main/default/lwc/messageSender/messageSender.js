import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import sendMessage from '@salesforce/apex/TwilioMessageHelper.sendAccountMessage'

export default class MessageSender extends LightningElement {
    @api recordId;
    messageBody = '';
    // whether or not we're in the process of sending a message (controls input enablement and spinner)
    sending = false;

    handleSendSMS(event){
        // only send message if the body is > 0 in length 
        if(this.messageBody.length > 0){
            this.sending = true;
            sendMessage({accId: this.recordId, messageBody: this.messageBody})
                // if we successfully sent the message, display a positive toast message
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
            // if there was an error whilst sending the message, display an error toast and the error on screen
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
        // binds the messageBody to the value of the textarea
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
