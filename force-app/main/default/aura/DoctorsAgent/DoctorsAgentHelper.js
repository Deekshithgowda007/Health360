({ 
    getTableDatas: function (component,event,helper) {
        this.showSpinner(component,event,helper);
        if(component.get("v.AppStatus")=='Canceled'){
               component.set('v.columns', [
                      {label: "Appointment Number",fieldName: "AppointmentUrl",type: "url",hideDefaultActions: true,initialWidth:220,
        	typeAttributes: { label: { fieldName: "AppointmentNumber" }, tooltip:"AppointmentNumber", target: "_blank" }  
       		},
            { label: 'Phone', fieldName: 'Phone',type:'Phone',hideDefaultActions: true},
            { label: 'SchedStartTime', fieldName: 'SchedStartTime',type:'Date/Time',hideDefaultActions: true},
             { label: 'SchedEndTime', fieldName: 'SchedEndTime',type:'Date/Time',hideDefaultActions: true},
            { label: 'Status', fieldName: 'Status', type:'Picklist', hideDefaultActions: true,initialWidth: 100},
           
        ]);
        
        }
                   else{
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
            { label: 'Status', fieldName: 'Status', type:'Picklist', hideDefaultActions: true,initialWidth: 100},
            {type: 'action',initialWidth:5, typeAttributes: { rowActions: actions } } 
        ]);
        }
         const mapAcc = new Map();
            const mapStatus =new Map();
        let baseUrlOfOrg= 'https://'+location.host+'/';
         var stat=component.get("v.AppStatus");
        var action = component.get('c.getAppointmentDetails');
         action.setParams({
            status : stat
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                this.hideSpinner(component,event,helper);
                var appointmentDetails =response.getReturnValue();
                if(appointmentDetails.length > 0){
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
                 component.set("v.showtable",true);
                 component.set("v.buttonshow",true);
                 component.set('v.showmyspinner',true);
                 
                component.set('v.filteredData',appointmentDetails);
                 if(component.get('v.filteredData').length == 0){
                    component.set('v.checkValue','false');
                }
                this.preparePagination(component, appointmentDetails);
                              
            }
            else if(appointmentDetails.length == 0){
                component.set("v.showtable",false);
                component.set("v.buttonshow",false);  
           }
        }
       
        });
        $A.enqueueAction(action);
    },
  preparePagination: function (component, imagesRecords) {
        let countTotalPage = Math.ceil(imagesRecords.length/component.get("v.pageSize"));
        let totalPage = countTotalPage > 0 ? countTotalPage : 1;
        component.set("v.totalPages", totalPage);
        component.set("v.currentPageNumber", 1);
        this.setPageDataAsPerPagination(component);
    },
    setPageDataAsPerPagination: function(component) {
        let data = [];
        let pageNumber = component.get("v.currentPageNumber");
        let pageSize = component.get("v.pageSize");
        let filteredData = component.get('v.filteredData');
        let x = (pageNumber - 1) * pageSize;
        for (; x < (pageNumber) * pageSize; x++){
            if (filteredData[x]) {
                data.push(filteredData[x]);
               
            }
        }
        component.set("v.results", data);
        
    },
   
    CancelAppointment:function(component,event,helper){
         var action = event.getParam('action');
        var row = event.getParam('row');
         var getMap=component.get("v.AppointmentId");
            var SAId=getMap.get(row.Id);
         var actions=component.get("c.updateCancel");
                    actions.setParams({
                        serviceAppointmentIds : SAId
                    });
         actions.setCallback(this, function(response){
                        var state=response.getState();
          if(state === "SUCCESS"){
                            var result=response.getReturnValue();
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({        
                                title: "Success!",      
                                message: "Appointment has been Canceled successfully.",
                                type:"success",
                                mode:"pester"      
                            });
                            toastEvent.fire();
                            this.getTableDatas(component, event, helper);
                        }
                        });
                        
         $A.enqueueAction(actions);
    },  
    ConfirmAppointment :function(component,event,helper){
               var action = event.getParam('action');
        var row = event.getParam('row');
         var getMap=component.get("v.AppointmentId");
            var SAId=getMap.get(row.Id);
         var actions=component.get("c.updateConfirm");
                    actions.setParams({
                        serviceAppointmentIds:SAId
                    });
         actions.setCallback(this, function(response){
                        var state=response.getState();
            // var error=response.getError();
          if(state === "SUCCESS"){
                            var result=response.getReturnValue();
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({        
                                title: "Success!",      
                                message: "Appointment has been Confirmed successfully.",
                                type:"success",
                                mode:"pester"      
                            });
                            toastEvent.fire();
                            this.getTableDatas(component, event, helper);
                        }
                        });
         $A.enqueueAction(actions); 
        
    },
    OnHoldAppointment: function(component,event,helper){
         var action = event.getParam('action');
        var row = event.getParam('row');
         var getMap=component.get("v.AppointmentId");
            var SAId=getMap.get(row.Id);
         var actions=component.get("c.updateOnHold");
                    actions.setParams({
                        ServiceAppointmentIds:SAId
                    });
         actions.setCallback(this, function(response){
                        var state=response.getState();
            // var error=response.getError();
          if(state === "SUCCESS"){
                            var result=response.getReturnValue();
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({        
                                title: "Success!",      
                                message: "Appointment has been On Hold.",
                                type:"success",
                                mode:"pester"      
                            });
                            toastEvent.fire();
                            this.getTableDatas(component, event, helper);
                        }
                        });
         $A.enqueueAction(actions);
    },
     onPageDateChanges: function(component, event, helper) {
        this.showSpinner(component,event,helper);
         var today = new Date();        
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
        if(dd < 10){
            dd = '0' + dd;
        } 
        if(mm < 10){
            mm = '0' + mm;
        }
        
     var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
/*if(component.get("v.myDate") != '' && component.get("v.myDate") < todayFormattedDate){
    
            component.set("v.dateValidationError" , true);
         component.set("v.results",[]);
         
            
        }else{*/
            component.set("v.dateValidationError" , false);
        var FetchDate=component.find("DateChange").get("v.value");
          if(FetchDate==null){
            this.getTableDatas(component,event, helper);
        }
         else{
            component.set("v.myDate",FetchDate);
            let baseUrlOfOrg= 'https://'+location.host+'/';
              var stat=component.get("v.AppStatus");
            var methodcall=component.get("c.fetchContactByDates");
            methodcall.setParams({
                selectedDate :FetchDate,
                status :stat
            });
            methodcall.setCallback(this, function(response){
                var state=response.getState();
                if(state === "SUCCESS"){
                    this.hideSpinner(component,event,helper);
                    var result=response.getReturnValue();
                    if(result.length > 0){
                    for (var i = 0; i < result.length; i++) { 
                var row = result[i];
                row.Department = row.Account.Name;
                row.AppointmentUrl =baseUrlOfOrg+row.Id;
                row.Status = row.Status;
                 row.SchedStartTime =$A.localizationService.formatDate(row.SchedStartTime, "dd/MM/yyyy,hh:mm a");
                  row.SchedEndTime =$A.localizationService.formatDate(row.SchedEndTime, "dd/MM/yyyy,hh:mm a");
                row.AppointmentNumber =row.AppointmentNumber;
                        
                         if ( row.Account) {
                        row.Phone = row.Account.Phone;
                    }
            }
                    component.set('v.results', result);
                    component.set('v.filteredData', result);
                    component.set("v.showtable",true);
                    component.set("v.buttonshow",true);
                     
                    
                     if(component.get('v.filteredData').length == 0){
                        component.set('v.checkValue','false');
                    }
                    this.preparePagination(component, result);
                }
                    
                    
                else if(result.length == 0){
                    component.set("v.showtable",false);
                    component.set("v.buttonshow",false); 
                      
               } 
                } 
                else if (state === "ERROR") {
                    console.log('error'+state);
                }
                return null;  
            });
            $A.enqueueAction(methodcall);
     }
        //}
    },
    handleAppointments :function(component,event,helper){
         var tab = event.getSource();
        switch (tab.get('v.id')) {
                  case 'Scheduled' :
                var time=component.get("v.myDate");
                if(time==null){
                    var status='Scheduled';
                    component.set("v.AppStatus",status);
                    this.getTableDatas(component, event, helper);
                }
                else{
                    var status='Scheduled';
                    component.set("v.AppStatus",status);
                    this.onPageDateChanges(component, event, helper);
                }
                break;
                     case 'Waiting' :
                var time=component.get("v.myDate");
                if(time==null){
                    var status='Waiting List';
                    component.set("v.AppStatus",status);
                    this.getTableDatas(component, event, helper);
                }
                else{
                    var status='Waiting List';
                    component.set("v.AppStatus",status);
                    this.onPageDateChanges(component, event, helper);
                }
                break;
                     case 'Canceled' :
                var time=component.get("v.myDate");
                if(time==null){
                    var status='Canceled';
                    component.set("v.AppStatus",status);
                    this.getTableDatas(component, event, helper);
                }
                else{
                    var status='Canceled';
                    component.set("v.AppStatus",status);
                    this.onPageDateChanges(component, event, helper);
                }
                break;
                     case 'Onhold' :
                var time=component.get("v.myDate");
                if(time==null){
                    var status='On hoLd';
                    component.set("v.AppStatus",status);
                    this.getTableDatas(component, event, helper);
                }
                else{
                    var status='On hoLd';
                    component.set("v.AppStatus",status);
                    this.onPageDateChanges(component, event, helper);
                }
                break;
        }
    },
    showSpinner: function (component, event, helper) {
        component.set('v.showmyspinner',true);
        //component.set('v.showtable',true);
        
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");  
    },
    
    hideSpinner: function (component, event, helper) {
        window.setTimeout(
            $A.getCallback(function() {
                component.set('v.showmyspinner',false);
                //component.set('v.showtable',false);
                var spinner = component.find("mySpinner");
                $A.util.addClass(spinner, "slds-hide");
            }), 1000
        );        
    },
    
})