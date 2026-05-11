import { LightningElement, wire, api, track } from 'lwc';
import getContacts from '@salesforce/apex/AppointmentDataForTable.getAppointment';

const COLUMNS = [
    {  
        label: "Salesforce Appointment",  
        fieldName: "AppointmentUrl",  
        type: "url",  
        hideDefaultActions: true,
        typeAttributes: { label: { fieldName: "AppointmentNumber" }, tooltip:"AppointmentNumber", target: "_blank" }  
       },
   // { label: 'Salesforce Appointment', fieldName: 'ApptUrl',  type: 'url', typeAttributes: {label: { fieldName: 'AppointmentNumber' }, target: '_blank'}, sortable: true },
    { label: 'Appointment ID', fieldName: 'Appointment_ID__c',hideDefaultActions: true},
    { label: 'Appointment Date', fieldName: 'DueDate', hideDefaultActions: true },
    { label: 'Department', fieldName: 'Department_ID__c', hideDefaultActions: true },
    { label: 'Provider', fieldName: 'ContactId', hideDefaultActions: true},
    { label: 'Visit Type', fieldName: 'WorkTypeId', hideDefaultActions: true},
    { label: 'Status', fieldName: 'Status', hideDefaultActions: true},
    {label: 'Notes', fieldName: 'Notes__c', hideDefaultActions: true}
];
export default class AppointmentDataTable extends LightningElement {

    data;
    columns = COLUMNS;
    @api recordId;
    totalRecords = 0; 
    pageSize = 3; 
    totalPages;
    pageNumber = 1;
    recordsToDisplay = [];
    @track checkValue = false;
    @track loaded=false;
    get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }

    /*@wire(getContacts,{recordId:'$recordId'})
    appointmentData(result) {
        if (result.data) {
            this.data = result.data;
            this.error = undefined;
           
        } else if (result.error) {
            this.error = result.error;
            this.data = undefined;
        }
    }*/
connectedCallback(){
    this.getApptRecords();
}
   getApptRecords(){
    let baseUrlOfOrg= 'https://'+location.host+'/';
        getContacts({recordId: this.recordId})
        .then(result => {
                    var apptObj = [];
                    result.forEach(apptRec => {
                       // alert(apptRec.Department_ID__r.Name + apptRec.Id);
                        apptObj.push({'Appointment_ID__c':apptRec.Appointment_ID__c,'DueDate':apptRec.DueDate,'Department_ID__c':apptRec.Department_ID__r.Name,
                    'ContactId':apptRec.Contact.Name,'WorkTypeId':apptRec.WorkType.Name,'Status':apptRec.Status,'Notes__c':apptRec.Notes__c,'AppointmentNumber':apptRec.AppointmentNumber,
                'AppointmentUrl':baseUrlOfOrg+apptRec.Id})
                    });
                    this.data = apptObj;
                    this.totalRecords = apptObj.length;
                    this.paginationHelper();
                    if(apptObj.length == 0){
                        this.checkValue = true;
                    }
                    this.loaded = true;
                })
                .catch(error => {
                    
                   // alert("error ", JSON.stringify(this.error));
                    this.message = undefined;
                    this.error = error;
                    // eslint-disable-next-line no-console
                    
                });
        }

       /* handleRowAction(event) {
            alert(event.detail.row.Id);
            this[NavigationMixin.GenerateUrl]({
                type: "standard__recordPage",
                attributes: {
                    recordId: event.detail.row.Id,
                    actionName: "view"
                }
            }).then((url) => {
                window.open(url, "_blank");
            });
        }*/

        paginationHelper() {
            this.recordsToDisplay = [];
            // calculate total pages
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            // set page number 
            if (this.pageNumber <= 1) {
                this.pageNumber = 1;
            } else if (this.pageNumber >= this.totalPages) {
                this.pageNumber = this.totalPages;
            }
            // set records to display on current page 
            for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
                if (i === this.totalRecords) {
                    break;
                }
                this.recordsToDisplay.push(this.data[i]);
            }
        }

        previousPage() {
            this.pageNumber = this.pageNumber - 1;
            this.paginationHelper();
        }
        nextPage() {
            this.pageNumber = this.pageNumber + 1;
            this.paginationHelper();
        }

}