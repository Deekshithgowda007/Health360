({
    
    doInit: function (component, event, helper) {
        helper.setupDataTable(component);
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
                            helper.getTableData(component, event, helper);
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
                            helper.onPageDateChanges(component, event, helper);
                        }
                    });
                    $A.enqueueAction(actions);
                    }
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