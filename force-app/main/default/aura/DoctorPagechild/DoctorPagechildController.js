({
    doInit :function(component, event,helper) {
        alert(component);
     helper.getspecialityWithDoctors(component,event,helper);
        //helper.getDoctors(component,event,helper);
    },
  showHospitalssforCare:  function(component,event,helper) { 
        component.set("v.careDoctors",true);
        component.set("v.showHospitalssforCare",true);
        component.set("v.welcomepage",false);
        component.set("v.showBookAppointment",false);
        component.set("v.showrecords",false);
       
},
     getDoctors : function(component, event, helper,handleAllSearch) {
        //component.set("v.showrecords",false);
        var getSelectedDocIds =component.get("v.getDocId");
        var csId =component.get('v.careIds');
        var accId =component.get('v.AccId');
        var action = component.get("c.fetchDoctor");
        
        action.setParams({
            csId :csId,
            accId:accId,
            DocId:getSelectedDocIds
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var vertical = response.getReturnValue();
                component.set('v.countdoctor',vertical.practitioners.length);
                component.set("v.showcount",true);
                if(vertical.practitioners.length >0){
                    
                    if(handleAllSearch == "handleAllSearch"){
                        var practitioners=[];
                        for(var i=0;i<vertical.practitioners.length;i++){
                            
                            if(getSelectedDocIds ===vertical.practitioners[i].PractitionerId && accId === vertical.practitioners[i].AccountId && csId === vertical.practitioners[i].SpecialtyId){
                                practitioners.push(vertical.practitioners[i]);
                                component.set("v.CareList","");
                                component.set("v.CareList",practitioners);
                                component.set("v.CareSpecilityforHeading",practitioners[0].Specialty.Name);
                                component.set("v.HospitalforHeading",practitioners[0].Account.Name);
                                component.set('v.CheckForSpecilaity',true);
                                console.log(JSON.stringify(component.get("v.CareList"))+'all process');
                                component.set('v.filteredData', practitioners);
                                component.set("v.welcomepage",false);
                                component.set('v.showrecords',true);
                                component.set("v.showHome",true);
                                component.set("v.showHospitalss",false);
                                
                            }
                            
                            
                            else if(getSelectedDocIds != vertical.practitioners[i].PractitionerId && accId == vertical.practitioners[i].AccountId && csId == vertical.practitioners[i].SpecialtyId ){
                                component.set("v.showrecords",false);
                                component.set("v.showBookAppointment",true);
                                
                                
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    title :$A.get("$Label.c.Info"),
                                    message:$A.get("$Label.c.We_couldnt_find_anything_that_matches_your_search_criteria_Refine_your_search_a"),
                                    duration:' 7000',
                                    key: 'info_alt',
                                    type: 'info',
                                    mode: 'dismissible'
                                });
                                //toastEvent.preventDefault();
                                toastEvent.fire();
                                event.preventDefault();
                                //   $A.get('e.force:refreshView').fire();
                                
                                
                                
                            }
                                else if(getSelectedDocIds == vertical.practitioners[i].PractitionerId && accId != vertical.practitioners[i].AccountId && csId == vertical.practitioners[i].SpecialtyId){
                                }
                            
                        }
                        
                    }
                    else if(handleAllSearch == "Doc&&Care"){
                        var practitioners=[];
                        for(var i=0;i<vertical.practitioners.length;i++){
                            if(getSelectedDocIds ==vertical.practitioners[i].PractitionerId ){
                                practitioners.push(vertical.practitioners[i]);
                            }
                        }
                        component.set("v.CareSpecilityforHeading",practitioners[0].Specialty.Name);
                        component.set("v.HospitalforHeading",practitioners[0].Account.Name);
                        component.set('v.CheckForSpecilaity',true);
                        component.set("v.CareList","");
                        component.set("v.CareList",practitioners);
                        component.set('v.filteredData', practitioners);
                        console.log(JSON.stringify(component.get("v.filteredData"))+'all process');
                        component.set("v.welcomepage",false);
                        component.set('v.showrecords',true);
                        component.set("v.showHome",false);
                        component.set("v.showHospitalss",true);
                        component.set("v.showHospitalssforCare",false);
                        this.hideSpinner(component);
                    } 
                    
                        else if(handleAllSearch =="Acc&care"){
                            const getCare = new Map();
                            var getspeciality=[];
                            for(var i=0;i<vertical.practitioners.length;i++){
                                if( getCare.length ==0 ||(!getCare.get(vertical.practitioners[i].Specialty.Name))){
                                    getspeciality.push(vertical.practitioners[i]);
                                    getCare.set(vertical.practitioners[i].Specialty.Name ,vertical.practitioners[i].Specialty.Name);
                                    
                                }
                            }
                            component.set("v.CareSpecilityforHeading",getspeciality[0].Specialty.Name);
                            component.set("v.HospitalforHeading",getspeciality[0].Account.Name);
                            component.set('v.CheckForSpecilaity',true);
                            component.set("v.CareList",getspeciality);
                            console.log(JSON.stringify(component.get("v.CareList"))+'acc And care');
                            component.set('v.filteredData',vertical.practitioners);
                            component.set("v.showHome",true);
                            component.set("v.showHospitalss",false);
                            component.set('v.showrecords',true);
                            component.set("v.showHospitalssforCare",false);
                            
                        }
                            else if(handleAllSearch =="Acc"){
                                const getCare = new Map();
                                var getspeciality=[];
                                for(var i=0;i<vertical.practitioners.length;i++){
                                    if( getCare.length ==0 ||(!getCare.get(vertical.practitioners[i].Specialty.Name))){
                                        getspeciality.push(vertical.practitioners[i]);
                                        getCare.set(vertical.practitioners[i].Specialty.Name ,vertical.practitioners[i].Specialty.Name);
                                    }
                                }
                                component.set("v.CareList",getspeciality);
                                console.log(JSON.stringify(component.get("v.CareList"))+'acc And care');
                                component.set('v.filteredData',vertical.practitioners);
                                component.set("v.showHospitalss",true);
                                component.set("v.showHospitalssforCare",false);
                                component.set("v.showHome",false);
                            }
                    // component.set("v.getDocId","");
                    this.preparePagination(component,component.get("v.filteredData"));
                    component.set("v.showSubspeciality",true );
                    component.set("v.showDoctors",true );
                    component.set("v.showsubcount",false); 
                    component.set("v.SubCareList",vertical.subSpeciality);
                    component.set("v.providerFound",true);
                    component.set("v.showPginationbutton",true);
                }
                
                else{
                    var getdoNulll =  component.get("v.doNull");
                    if(getdoNulll == null){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title :$A.get("$Label.c.Info"),
                            message:$A.get("$Label.c.Please_Select_Speciality_Doctor_Or_Hospital"),
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'info',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                        
                    }
                    else{
                        component.set("v.showBookAppointment",true);
                        component.set("v.showrecords",false);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            
                            title :$A.get("$Label.c.Info"),
                            message:$A.get("$Label.c.We_couldnt_find_anything_that_matches_your_search_criteria_Refine_your_search_a"),
                            duration:' 8000',
                            key: 'info_alt',
                            type: 'info',
                            mode: 'dismissible'  
                        });
                        //  toastEvent.preventDefault();
                        toastEvent.fire();
                        
                        //   $A.get('e.force:refreshView').fire();
                        //   $A.get("e.force:closeQuickAction").fire()
                        
                        //  }
                    }
                }
                
                if(vertical.subSpeciality.length >0){
                    component.set("v.showsub",true);
                    
                }
                else{
                    component.set("v.showsub",false);
                }
                window.setTimeout(
                    $A.getCallback(function() {
                        component.set('v.showmyspinner',false);
                        var spinner = component.find("mySpinner");
                        $A.util.addClass(spinner, "slds-hide");
                    }), 1000
                );       
            } 
        });
        
        $A.enqueueAction(action);
    }, 
      BackToHospital:  function(component,event,helper) { 
        component.set("v.welcomepage",true);
        component.set("v.showBookAppointment",false);
        component.set("v.showrecords",false);
        component.set('v.careIds',null);
        component.set("v.viewdoctordetails",false);

      }   
})