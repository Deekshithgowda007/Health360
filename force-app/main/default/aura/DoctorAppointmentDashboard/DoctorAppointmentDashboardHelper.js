({
    setupDataTable: function (component) {
        var actions = [
            { label: 'Cancel Appointment', name: 'delete' },
            { label: 'Mark Completed', name: 'complete' },
            { label: 'Send Reminder', name: 'remind' },
            { label: 'Edit Appointment', name: 'Edit' },
        ];
            component.set('v.columns', [
            {label: "Appointment Number",fieldName: "AppointmentUrl",type: "url",hideDefaultActions: true,initialWidth:220,
            typeAttributes: { label: { fieldName: "AppointmentNumber" }, tooltip:"AppointmentNumber", target: "_blank" }  
            },
            { label: 'Appointment Date', fieldName: 'SchedStartTime',type:'DateTime',hideDefaultActions: true},
            { label: 'Facility', fieldName: 'Department',type:'text',hideDefaultActions: true},
            { label: 'Practitioner', fieldName: 'Provider',type:'text',hideDefaultActions: true},
            { label: 'Visit Type', fieldName: 'VisitType',hideDefaultActions: true},
            { label: 'Status', fieldName: 'Status',hideDefaultActions: true},
            {type: 'action', typeAttributes: { rowActions: actions } }
        ]);
    },

    initializeDashboard: function(component, event, helper) {
        var action = component.get("c.getLoggedInPractitionerContext");
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                if (result && result.found && result.doctorEmail) {
                    component.set("v.doctorLoginEmail", result.doctorEmail);
                }
            }
        });
        $A.enqueueAction(action);
    },

    sendDoctorOtpForResolvedDoctor: function(component) {
        var code = new jsOTP.totp().getOtp('12345');
        component.set("v.doctorOtpCode", code);

        var action = component.get("c.sendDoctorOtpByEmail");
        action.setParams({
            emailAddress: component.get("v.doctorEmail"),
            doctorName: component.get("v.doctorName"),
            otp: component.get("v.doctorOtpCode")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS" && response.getReturnValue() === true) {
                component.set("v.doctorOtpSent", true);
                var otpToast = $A.get("e.force:showToast");
                otpToast.setParams({
                    title: "Success!",
                    mode:"pester",
                    message: "OTP sent to your registered doctor email.",
                    type:"success"
                });
                otpToast.fire();
            } else {
                var errors = response.getError();
                var message = "Could not send doctor OTP.";
                if (errors && errors[0] && errors[0].message) {
                    message = errors[0].message;
                }
                var otpErrorToast = $A.get("e.force:showToast");
                otpErrorToast.setParams({
                    title: "Error!",
                    mode:"dismissible",
                    message: message,
                    type:"error"
                });
                otpErrorToast.fire();
            }
        });
        $A.enqueueAction(action);
    },

    clearTableState: function(component) {
        component.set("v.AppointmentId", new Map());
        component.set("v.AppointmentStatus", new Map());
        component.set("v.allData", []);
        component.set("v.filteredData", []);
        component.set("v.tableData", []);
        component.set("v.showtabledata", false);
        component.set("v.ButtonShow", false);
        component.set("v.selectedLeads", []);
        component.set("v.currentPageNumber", 1);
        component.set("v.totalPages", 1);
    },

    refreshCurrentView: function(component, event, helper) {
        var selectedDate = component.get("v.DateTime");
        if (selectedDate) {
            this.onPageDateChanges(component, event, helper);
        } else {
            this.getTableData(component, event, helper);
        }
    },
    
    handleComponentEventPassed : function(component, event, helper){
        var selectedAccountGetFromEvent = event.getParam("selelectedrecordByEvent");
        if(selectedAccountGetFromEvent != null){
        component.set("v.contactId",selectedAccountGetFromEvent.Id);
        component.set("v.ShowTimeField",true);
        component.set("v.ShowToast",false);
        component.set("v.ShowTable",true);
        var status='Scheduled';
        component.set("v.AppStatus",status);
        this.getTableData(component, event, helper);
        }
        else{
            var selectedAccountGetFromEvent = event.getParam("selelectednullrecord");
            $A.get('e.force:refreshView').fire();
        }
    },
    
    getTableData :  function(component, event, helper){
        const mapAcc = new Map();
        const mapStatus =new Map();
        this.showSpinner(component, event, helper);
        let baseUrlOfOrg= 'https://'+location.host+'/';
        var stat=component.get("v.AppStatus");
        var conId=component.get("v.contactId");
        var methodcall=component.get("c.fetchContact");
        methodcall.setParams({
            conId : conId,
            status : stat
        });
        methodcall.setCallback(this, function(response){
            var state=response.getState();
            if(state === "SUCCESS"){
                var result=response.getReturnValue();
                if(result.length > 0){
                this.hideSpinner(component, event, helper);
                for (var i = 0; i < result.length; i++) { 
                    var row = result[i];  
                    var jrows = row.HealthcarePractitionerFacility;
                    row.Provider = jrows.Practitioner.Name;  
                    row.Department = jrows.Account.Name;
                    var Appointmentrows=row.ServiceAppointment;
                    row.SchedStartTime =$A.localizationService.formatDate(Appointmentrows.SchedStartTime, "MM/dd/yyyy, hh:mm a");
                    row.Status = Appointmentrows.Status;
                    row.AppointmentUrl =baseUrlOfOrg+Appointmentrows.Id;
                    row.AppointmentNumber =Appointmentrows.AppointmentNumber;
                    if(Appointmentrows.WorkType.Name){
                        row.VisitType = Appointmentrows.WorkType.Name;
                    }
                    mapAcc.set(row.Id, Appointmentrows.Id);
                    mapStatus.set(row.Id, Appointmentrows.Status);
                }
                component.set("v.AppointmentId",mapAcc);
                component.set("v.AppointmentStatus",mapStatus);
                component.set('v.allData', result);
                component.set('v.showtabledata', true);
                component.set('v.filteredData', result);
                if(component.get('v.filteredData').length == 0){
                    component.set('v.checkValue','false');
                }
                this.preparePagination(component, result);
                }
                else if(result.length == 0){
                    this.clearTableState(component);
                    this.hideSpinner(component, event, helper);
                }
            } 
            else if (state === "ERROR") {
                console.log('error'+state);
            }
            return null;
        });
        $A.enqueueAction(methodcall);
        var forclose = component.find("lookup-pill");
        if (forclose) {
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');
        }
        var searchRes = component.find("searchRes");
        if (searchRes) {
            $A.util.addClass(searchRes, 'slds-is-close');
            $A.util.removeClass(searchRes, 'slds-is-open');
        }
        var lookUpTarget = component.find("lookupField");
        if (lookUpTarget) {
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');
        }
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
        component.set("v.tableData", data);
    },
    
    showSpinner: function (component, event, helper) {
        component.set('v.showmyspinner',true);
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");  
    },
    
    hideSpinner: function (component, event, helper) {
        window.setTimeout(
            $A.getCallback(function() {
                component.set('v.showmyspinner',false);
                var spinner = component.find("mySpinner");
                $A.util.addClass(spinner, "slds-hide");
            }), 1000
        );        
    },
    
    deltingCheckboxAccounts : function(component, event, deltIds, helper) {
        var time=component.get("v.DateTime");
        this.showSpinner(component, event, helper);
        var action = component.get("c.cancelRecord");
        action.setParams({
            cancelIds : deltIds
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result=response.getReturnValue();
                this.hideSpinner(component, event, helper);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({        
                    title: "Success!",      
                    message: "Appointment has been Canceled successfully.",
                    type:"success",
                    mode:"pester"      
                });
                toastEvent.fire();
                if(time==null){
                    this.getTableData(component, event, helper);
                    component.set('v.showCancelBox', false);
                }
                else{
                    this.onPageDateChanges(component, event, helper);
                    component.set('v.showCancelBox', false);
                    component.set("v.ButtonShow",false);
                    component.set("v.selectedLeads",[]);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                              errors[0].message);
                    }
                } 
            }
        });
        
        $A.enqueueAction(action);
    },
    
    onPageDateChanges: function(component, event, helper) {
        this.showSpinner(component,event, helper);
        var SelectedCon=component.get("v.contactId");
        var FetchDate=component.find("DateChange").get("v.value");
        if(FetchDate==null){
            this.getTableData(component,event, helper);
        }
        else{
            component.set("v.DateTime",FetchDate);
            var status=component.get("v.AppStatus");
            let baseUrlOfOrg= 'https://'+location.host+'/';
            var methodcall=component.get("c.fetchContactByDate");
            methodcall.setParams({
                selectedCon : SelectedCon,
                selectedDate :FetchDate,
                status : status
                
            });
            methodcall.setCallback(this, function(response){
                var state=response.getState();
                if(state === "SUCCESS"){
                    this.hideSpinner(component,event, helper);
                    var result=response.getReturnValue();
                    if(result.length > 0){
                    for (var i = 0; i < result.length; i++) { 
                        var row = result[i];  
                        var jrows = row.HealthcarePractitionerFacility;
                        row.Provider = jrows.Practitioner.Name;  
                        row.Department = jrows.Account.Name;
                        var Appointmentrows=row.ServiceAppointment;
                        row.SchedStartTime =$A.localizationService.formatDate(Appointmentrows.SchedStartTime, "MM/dd/yyyy, hh:mm a");
                        row.Status = Appointmentrows.Status;
                        row.AppointmentUrl =baseUrlOfOrg+Appointmentrows.Id;
                        row.AppointmentNumber =Appointmentrows.AppointmentNumber;
                        if(Appointmentrows.WorkType.Name){
                            row.VisitType = Appointmentrows.WorkType.Name;
                        }
                    }
                    component.set('v.allData', result);
                        component.set('v.showtabledata', true);
                    component.set('v.filteredData', result);
                    if(component.get('v.filteredData').length == 0){
                        component.set('v.checkValue','false');
                    }
                    this.preparePagination(component, result);
                    }
                    else if(result.length == 0){
                        this.clearTableState(component);
                        this.hideSpinner(component,event, helper);
                    }
                } 
                else if (state === "ERROR") {
                    console.log('error'+state);
                }
                return null;  
            });
            $A.enqueueAction(methodcall);
        } 
    },
    
    handleActives: function (component, event, helper) {
        var tab = event.getSource();
        switch (tab.get('v.id')) {
            case 'badge' :
                var time=component.get("v.DateTime");
                if(time==null){
                    var status='Scheduled';
                    component.set("v.AppStatus",status);
                    this.getTableData(component, event, helper);
                }
                else{
                    var status='Scheduled';
                    component.set("v.AppStatus",status);
                    this.onPageDateChanges(component, event, helper);
                }
                break;
                
            case 'cancel' :
                var time=component.get("v.DateTime");
                if(time==null){
                    var status='Canceled';
                    component.set("v.AppStatus",status);
                    this.getTableData(component, event, helper);
                }
                else{
                    var status='Canceled';
                    component.set("v.AppStatus",status);
                    this.onPageDateChanges(component, event, helper);
                }
                break;
                
                case 'complete' :
                var time=component.get("v.DateTime");
                if(time==null){
                    var status='Completed';
                    component.set("v.AppStatus",status);
                    this.getTableData(component, event, helper);
                }
                else{
                    var status='Completed';
                    component.set("v.AppStatus",status);
                    this.onPageDateChanges(component, event, helper);
                }
                break;
        }
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
        component.set("v.allData", data);
    },
    
})
