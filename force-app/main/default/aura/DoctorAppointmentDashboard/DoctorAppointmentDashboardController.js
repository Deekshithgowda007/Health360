({
    afterLoad: function(component, event, helper) {
        var code = new jsOTP.totp().getOtp('12345');
        component.set("v.doctorOtpCode", code);
    },
    
    doInit: function (component, event, helper) {
        helper.setupDataTable(component);
        helper.initializeDashboard(component, event, helper);
    },

    lookupDoctorByEmail: function(component, event, helper) {
        var emailAddress = (component.get("v.doctorLoginEmail") || '').trim();
        if (!emailAddress) {
            var emptyEmailToast = $A.get("e.force:showToast");
            emptyEmailToast.setParams({
                title: "Error!",
                mode:"dismissible",
                message: "Please enter your registered doctor email.",
                type:"error"
            });
            emptyEmailToast.fire();
            return;
        }

        var action = component.get("c.getPractitionerContextByEmail");
        action.setParams({
            emailAddress: emailAddress
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                if (result && result.found && result.practitionerId) {
                    component.set("v.contactId", result.practitionerId);
                    component.set("v.doctorName", result.practitionerName);
                    component.set("v.doctorEmail", result.doctorEmail || emailAddress);
                    component.set("v.doctorResolved", true);
                    component.set("v.doctorAuthenticated", false);
                    component.set("v.doctorOtpInput", "");
                    component.set("v.doctorOtpSent", false);
                    component.set("v.ShowTimeField", false);
                    component.set("v.ShowToast", true);
                    component.set("v.ShowTable", false);
                    component.set("v.AppStatus", "Scheduled");
                    helper.sendDoctorOtpForResolvedDoctor(component);
                } else {
                    var noDoctorToast = $A.get("e.force:showToast");
                    noDoctorToast.setParams({
                        title: "Error!",
                        mode:"dismissible",
                        message: "No doctor account is mapped to this email.",
                        type:"error"
                    });
                    noDoctorToast.fire();
                }
            } else {
                var errors = response.getError();
                var message = "Could not validate doctor email.";
                if (errors && errors[0] && errors[0].message) {
                    message = errors[0].message;
                }
                var errorToast = $A.get("e.force:showToast");
                errorToast.setParams({
                    title: "Error!",
                    mode:"dismissible",
                    message: message,
                    type:"error"
                });
                errorToast.fire();
            }
        });
        $A.enqueueAction(action);
    },

    sendDoctorOtp: function(component, event, helper) {
        if (!component.get("v.doctorResolved")) {
            var noDoctorToast = $A.get("e.force:showToast");
            noDoctorToast.setParams({
                title: "Error!",
                mode:"dismissible",
                message: "Please enter your registered doctor email first.",
                type:"error"
            });
            noDoctorToast.fire();
            return;
        }
        helper.sendDoctorOtpForResolvedDoctor(component);
    },

    verifyDoctorOtp: function(component, event, helper) {
        var enteredOtp = (component.get("v.doctorOtpInput") || '').trim();
        var generatedOtp = component.get("v.doctorOtpCode");
        if (!enteredOtp) {
            var emptyOtpToast = $A.get("e.force:showToast");
            emptyOtpToast.setParams({
                title: "Error!",
                mode:"dismissible",
                message: "Please enter OTP.",
                type:"error"
            });
            emptyOtpToast.fire();
            return;
        }

        if (enteredOtp !== generatedOtp) {
            var invalidOtpToast = $A.get("e.force:showToast");
            invalidOtpToast.setParams({
                title: "Error!",
                mode:"dismissible",
                message: "Please enter valid OTP.",
                type:"error"
            });
            invalidOtpToast.fire();
            return;
        }

        component.set("v.doctorAuthenticated", true);
        component.set("v.ShowTimeField", true);
        component.set("v.ShowToast", false);
        component.set("v.ShowTable", true);
        var successToast = $A.get("e.force:showToast");
        successToast.setParams({
            title: "Success!",
            mode:"pester",
            message: "Doctor verification completed.",
            type:"success"
        });
        successToast.fire();
        helper.getTableData(component, event, helper);
    },
    
    onNext: function(component, event, helper) {        
        let pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber + 1);
        helper.setPageDataAsPerPagination(component);
    },
    
    onPrev: function(component, event, helper) {        
        let pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber - 1);
        helper.setPageDataAsPerPagination(component);
    },
    
    onFirst: function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.setPageDataAsPerPagination(component); 
    },
    
    onLast: function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.setPageDataAsPerPagination(component);
    },
    
    onPageSizeChange: function(component, event, helper) {    
        helper.preparePagination(component, component.get('v.filteredData'));
    },
    handleComponentEventPass : function(component, event, helper) {
        if (component.get("v.doctorResolved")) {
            return;
        }
        helper.handleComponentEventPassed(component, event, helper);
    },
    
    handleAction : function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        var getStatus=component.get("v.AppointmentStatus");
        var Stat=getStatus.get(row.Id);
        if(Stat == 'Canceled'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                mode:"dismissible",
                message: "Appointment Already Canceled",
                type:"error"
            });
            toastEvent.fire();
        }
        else{
            var getMap=component.get("v.AppointmentId");
            var SAId=getMap.get(row.Id);
            switch (action.name) {
                case 'delete':
                     var time=component.get("v.DateTime");
                if(time==null){
                    helper.showSpinner(component);
                    var actions=component.get("c.updateCancel");
                    actions.setParams({
                        serviceAppointmentIds:SAId
                    });
                    actions.setCallback(this, function(response){
                        var state=response.getState();
                        var error=response.getError();
                        if(state === "SUCCESS"){
                            var result=response.getReturnValue();
                            helper.hideSpinner(component);
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({        
                                title: "Success!",      
                                message: "Appointment has been Canceled successfully.",
                                type:"success",
                                mode:"pester"      
                            });
                            toastEvent.fire();
                            helper.refreshCurrentView(component, event, helper);
                        }
                    });
                    $A.enqueueAction(actions);
                    }
                    
                    else{
                        helper.showSpinner(component);
                    var actions=component.get("c.updateCancel");
                    actions.setParams({
                        serviceAppointmentIds:SAId
                    });
                    actions.setCallback(this, function(response){
                        var state=response.getState();
                        var error=response.getError();
                        
                        if(state === "SUCCESS"){
                            var result=response.getReturnValue();
                            helper.hideSpinner(component);
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({        
                                title: "Success!",      
                                message: "Appointment has been Canceled successfully.",
                                type:"success",
                                mode:"pester"      
                            });
                            toastEvent.fire();
                            helper.refreshCurrentView(component, event, helper);
                        }
                    });
                    $A.enqueueAction(actions);
                    }
                    break;

                case 'complete':
                    if(Stat == 'Completed'){
                        var completedToast = $A.get("e.force:showToast");
                        completedToast.setParams({
                            title: "Info",
                            mode:"dismissible",
                            message: "Appointment is already completed.",
                            type:"info"
                        });
                        completedToast.fire();
                        return;
                    }
                    helper.showSpinner(component);
                    var completeAction = component.get("c.updateAppointmentStatus");
                    completeAction.setParams({
                        serviceAppointmentId: SAId,
                        newStatus: 'Completed'
                    });
                    completeAction.setCallback(this, function(response){
                        helper.hideSpinner(component);
                        if(response.getState() === "SUCCESS"){
                            var successToast = $A.get("e.force:showToast");
                            successToast.setParams({
                                title: "Success!",
                                mode:"pester",
                                message: "Appointment marked as completed.",
                                type:"success"
                            });
                            successToast.fire();
                            helper.refreshCurrentView(component, event, helper);
                        } else {
                            var completeErrors = response.getError();
                            var completeMessage = 'Could not update appointment status.';
                            if (completeErrors && completeErrors[0] && completeErrors[0].message) {
                                completeMessage = completeErrors[0].message;
                            }
                            var errorToast = $A.get("e.force:showToast");
                            errorToast.setParams({
                                title: "Error!",
                                mode:"dismissible",
                                message: completeMessage,
                                type:"error"
                            });
                            errorToast.fire();
                        }
                    });
                    $A.enqueueAction(completeAction);
                    break;

                case 'remind':
                    if(Stat != 'Scheduled'){
                        var remindInfoToast = $A.get("e.force:showToast");
                        remindInfoToast.setParams({
                            title: "Info",
                            mode:"dismissible",
                            message: "Reminders can be sent only for scheduled appointments.",
                            type:"info"
                        });
                        remindInfoToast.fire();
                        return;
                    }
                    helper.showSpinner(component);
                    var remindAction = component.get("c.sendAppointmentReminder");
                    remindAction.setParams({
                        serviceAppointmentId: SAId
                    });
                    remindAction.setCallback(this, function(response){
                        helper.hideSpinner(component);
                        if(response.getState() === "SUCCESS"){
                            var reminderResult = response.getReturnValue();
                            var reminderMessage = "Reminder sent";
                            if (reminderResult && reminderResult.patientReminderSent && reminderResult.doctorReminderSent) {
                                reminderMessage = "Reminder sent to both patient and doctor.";
                            } else if (reminderResult && reminderResult.patientReminderSent) {
                                reminderMessage = "Reminder sent to patient.";
                            } else if (reminderResult && reminderResult.doctorReminderSent) {
                                reminderMessage = "Reminder sent to doctor.";
                            }
                            var reminderToast = $A.get("e.force:showToast");
                            reminderToast.setParams({
                                title: "Success!",
                                mode:"pester",
                                message: reminderMessage,
                                type:"success"
                            });
                            reminderToast.fire();
                        } else {
                            var reminderErrors = response.getError();
                            var reminderErrorMessage = 'Could not send appointment reminder.';
                            if (reminderErrors && reminderErrors[0] && reminderErrors[0].message) {
                                reminderErrorMessage = reminderErrors[0].message;
                            }
                            var reminderErrorToast = $A.get("e.force:showToast");
                            reminderErrorToast.setParams({
                                title: "Error!",
                                mode:"dismissible",
                                message: reminderErrorMessage,
                                type:"error"
                            });
                            reminderErrorToast.fire();
                        }
                    });
                    $A.enqueueAction(remindAction);
                    break;
                
                case 'Edit':
                    component.set("v.FlowPopup",true);
                    component.set("v.Homepopup",false);
                    
                    const flows = component.find("flowData");
                    var inputVariables = [
                        {
                            name:"varServiceAppId",
                            type:"String",
                            value:SAId
                        }
                    ];
                    flows.startFlow("Editing_Appointment_Flow",inputVariables);
                    break;
            }
        } 
        
    },
    
    onPageDateChange : function (component, event, helper) {
        helper.onPageDateChanges(component, event, helper);
    },
    
    updateSelectedText: function (component, event) {
        var selectedRows = event.getParam('selectedRows');
        component.set('v.selectedRowsCount', selectedRows.length);
        var slectCount =selectedRows.length;
        var setRows = [];
        for ( var i = 0; i < selectedRows.length; i++ ) {
            setRows.push(selectedRows[i]);
        }
        component.set("v.selectedLeads", setRows);
        console.log('selected data:'+setRows);
        if(slectCount>0){
            component.set('v.ButtonShow', true);
        }else{
            component.set('v.ButtonShow', false);
        }
    },
    
    handleConfirmDialog : function(component, event, helper) {
        component.set('v.showCancelBox', true);
    },
    
    handleClickCancel : function(component, event, helper) {
        var records = component.get("v.selectedLeads");
        var Appcancel=records[0].ServiceAppointment.Status;
        if(Appcancel == 'Canceled'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                mode:"dismissible",
                message: "Appointment Already Canceled",
                type:"error"
            });
            toastEvent.fire();
             component.set('v.showCancelBox', false);
        }
            else{
        helper.deltingCheckboxAccounts(component, event, records);
            }
    },
    
    handleConfirmDialogCancel : function(component, event, helper) {
        component.set('v.showCancelBox', false);
    },
    
    handleActive: function (component, event, helper) {
        helper.handleActives(component, event, helper);
    },
    
    handlecancel: function (component, event, helper) {
        helper.handleActives(component, event, helper);
    },
    
    handlecompleted: function (component, event, helper) {
        helper.handleActives(component, event, helper);
    },
    
})
