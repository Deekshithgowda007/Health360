({ 
    getspecialityWithDoctors:function(component,event,helper){
        component.set("v.showPginationbutton",true);
        var getDoctorsIds =component.get("v.doctorsIds");
        var getHospitalId=component.get('v.AccId');
        var getcontactId =component.get('v.selectedaccId');
        var action = component.get("c.getSpecialityHospiatalByDoctors");
       alert('action');
        action.setParams({
            '0034x00001Ci0qrAAB':getDoctorsIds,
            hospId:getHospitalId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            alert(state);
            if (state === "SUCCESS") {
                var show = response.getReturnValue();
                            alert(show);

                console.log(JSON.stringify((show[0].Specialty.Name))+"czrespeciality");
                component.set('v.filteredData',show);
                component.set('v.CareSpecilityforHeading',show[0].Specialty.Name);
                component.set('v.HospitalforHeading',show[0].Account.Name);
                component.set('v.CheckForSpecilaity',true);
                component.set("v.showSubspeciality",true );
                component.set('v.CareList',show);
                console.log(JSON.stringify(component.get("v.CareList")+"carelistsss"));
                component.set('v.showrecords',true);
                component.set('v.welcomepage',false);
                component.set('v.providerFound',true);
                component.set("v.showDoctors",true);
                component.set("v.showcount",true);
                component.set('v.countdoctor',show.length);
                
            }
            this.preparePagination(component,component.get("v.filteredData"));
        });
        $A.enqueueAction(action);
    },
    
    
    
  
   
})