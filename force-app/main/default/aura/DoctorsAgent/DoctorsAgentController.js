({
	doInit: function (component, event, helper) {
         
        helper.getTableDatas(component,event,helper);
        
    },
    onPrev: function(component, event, helper) {        
        let pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber - 1);
        helper.setPageDataAsPerPagination(component);
    },
     onNext: function(component, event, helper) {        
        let pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber + 1);
        helper.setPageDataAsPerPagination(component);
    },
        
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.showmyspinner", true); 
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.showmyspinner", false);
    },
 
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
         var row = event.getParam('row');
        switch (action.name) {
            case 'Confirmed':
                helper.ConfirmAppointment(component, event);   
                  break;
           case 'Canceled':
                helper.CancelAppointment(component, event,helper);
                break;
            case 'Onhold':
                helper.OnHoldAppointment(component, event);
                break;
                
        }
        },
    

     onPageSizeChange: function(component, event, helper) {  
        helper.preparePagination(component, component.get('v.filteredData'));
    },
     onPageDateChange : function (component, event, helper) {
        helper.onPageDateChanges(component, event, helper);
    },
    handleScheduled : function (component, event, helper) {
      helper.handleAppointments(component, event, helper);   
    },
    
     handleWaitingList : function (component, event, helper) {
    
       
         //helper.handleAppointments(component, event, helper);
           var actions = [
            {label: 'Confirm', name: 'Confirmed'},
            {label: 'Cancel', name: 'Canceled'},
            {label: 'Onhold', name: 'Onhold'},
             
        ];
          	component.set('v.columns', [
                      {label: "Appointment Number",fieldName: "AppointmentUrl",type: "url",hideDefaultActions: true,initialWidth:220,
        	typeAttributes: { label: { fieldName: "AppointmentNumber" }, tooltip:"AppointmentNumber", target: "_blank" }  
       		},
            { label: 'Phone', fieldName: 'Phone',type:'Phone',hideDefaultActions: true},
            { label: 'SchedStartTime', fieldName: 'SchedStartTime',type:'Date/Time',hideDefaultActions: true},
             { label: 'SchedEndTime', fieldName: 'SchedEndTime',type:'Date/Time',hideDefaultActions: true},
               { label: 'Priority', fieldName: 'Appointment_Preority__c', type:'Number', hideDefaultActions: true,initialWidth: 100},
            { label: 'Status', fieldName: 'Status', type:'Picklist', hideDefaultActions: true,initialWidth: 100},
            {type: 'action',initialWidth:5, typeAttributes: { rowActions: actions } } 
            
        ]);

         const mapAcc = new Map();
         const mapStatus =new Map();
        let baseUrlOfOrg= 'https://'+location.host+'/';
         var stat='Waiting List'
        var action = component.get('c.getAppointmentDetails');
         action.setParams({
            status : stat
        });
        action.setCallback(this, function(response) {
            
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                var appointmentDetails =response.getReturnValue();

                                  for ( var i = 0; i < appointmentDetails.length; i++ ) {
                    var row = appointmentDetails[i];
                        var Appointmentrows=row.Id;
                          row.SchedStartTime =$A.localizationService.formatDate(row.SchedStartTime, "dd/MM/yyyy,hh:mm a");
                  row.SchedEndTime =$A.localizationService.formatDate(row.SchedEndTime, "dd/MM/yyyy,hh:mm a");
                      row.AppointmentUrl =baseUrlOfOrg+row.Id;
                    row.AppointmentNumber =row.AppointmentNumber;
                        if ( row.Account) {
                        row.Phone = row.Account.Phone;
                    }
                      mapAcc.set(row.Id,Appointmentrows);   
                    }
              component.set("v.AppointmentId",mapAcc);
                 component.set('v.results',appointmentDetails); 
                
                component.set('v.filteredData',appointmentDetails);
                 if(component.get('v.filteredData').length == 0){
                    component.set('v.checkValue','false');
                }
          
               helper.preparePagination(component,component.get("v.filteredData"));
                helper.handleAppointments(component, event, helper);
                helper.onPageDateChanges(component, event, helper);
        }
        });
        $A.enqueueAction(action);  
    },
    
   handleCanceled : function (component, event, helper) {
       helper.handleAppointments(component, event, helper); 
    },
   handleOnHold : function (component, event, helper) {
         helper.handleAppointments(component, event, helper);  
    },
    
})