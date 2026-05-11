({
    setupDataTable: function (component) {
        var actions = [
            { label: 'Cancel Appointment', name: 'delete' }
        ];
        component.set('v.columns', [
            {label: "Appointment Number",fieldName: "AppointmentUrl",type: "url",hideDefaultActions: true,initialWidth:220,
        	typeAttributes: { label: { fieldName: "AppointmentNumber" }, tooltip:"AppointmentNumber", target: "_blank" }  
       		},
            { label: 'Appointment Date', fieldName: 'DueDate',type:'DateTime',hideDefaultActions: true},
            { label: 'Department', fieldName: 'Department',type:'text',hideDefaultActions: true},
            { label: 'Provider', fieldName: 'Provider',type:'text',hideDefaultActions: true},
            { label: 'Visit Type', fieldName: 'VisitType',hideDefaultActions: true},
            { label: 'Status', fieldName: 'Status',hideDefaultActions: true},
            {label: 'Notes', fieldName: 'Comments', hideDefaultActions: true},
            {type: 'action', typeAttributes: { rowActions: actions } }
        ]);
       },
            
            
       getData: function (component) {
            component.set("v.isLoading", true);
            let baseUrlOfOrg= 'https://'+location.host+'/';
            var recordId = component.get("v.recordId");
            const action = component.get("c.getAppointment");
            action.setParams({ recordId : recordId });
            action.setCallback(this, response => {
            component.set("v.isLoading", false);
            const state = response.getState();
            if (state === "SUCCESS") {
            	var rows = response.getReturnValue();
                //console.log(JSON.stringify(rows.apptData));
            	for (var i = 0; i < rows.length; i++) { 
            		var row = rows[i]; 
                	//as data columns with relationship __r can not be displayed directly in data table, so generating dynamic columns 
        			if(row.CarePractnFacilityAppts && row.CarePractnFacilityAppts.length > 0){
                		var jrows = row.CarePractnFacilityAppts;
                		for ( var j = 0; j < jrows.length; j++ ) {  
                				//alert('inside'+j);
                            row.Provider = jrows[j].HealthcarePractitionerFacility.Practitioner.Name;  
                			row.Department = jrows[j].HealthcarePractitionerFacility.Account.Name;
                   
                        }
        			}
        			if(row.WorkType){
            			row.VisitType = row.WorkType.Name;
        			}
        			row.DueDate = $A.localizationService.formatDate(row.DueDate, "MM/dd/yyyy, hh:mm a");
        			row.AppointmentUrl = baseUrlOfOrg+row.Id;
    			}
    		component.set('v.allData', rows);
    		component.set('v.filteredData', rows);
    		if(component.get('v.filteredData').length == 0){
    			component.set('v.checkValue','false');
			}
 			this.preparePagination(component, rows);
		
			} 
            else if (state === "ERROR") {
    			console.log('error'+state);
			}
		return null;
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
           component.set("v.tableData", data);
       },
})