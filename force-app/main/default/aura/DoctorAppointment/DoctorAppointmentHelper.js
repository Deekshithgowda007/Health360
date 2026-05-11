({ 
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
    
    
    getsubspecialityDoctors :function(component,event,helper){ 
        var getDoctorsId =component.get('v.subspecialityId'); 
        var action = component.get("c.SubspecialityDoctors");
        
        action.setParams({
            taxId :getDoctorsId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var getDoctoors = response.getReturnValue(); 
                component.set('v.countdoctor',getDoctoors.length);
                
                component.set("v.selectedaccId",getDoctoors);
                component.set("v.filteredData","");
                component.set('v.filteredData', getDoctoors);
                this.preparePagination(component,getDoctoors);
                component.set("v.showDoctors",true );
                component.set("v.showPagination",false );
                component.set("v.showcount",true);   
            }
            
        }); 
        $A.enqueueAction(action);
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
    setPageDataAsPerPagination: function(component) {
        let data = [];
        let pageNumber = component.get("v.currentPageNumber");
        let pageSize = component.get("v.pageSize");
        let filteredData = component.get('v.filteredData');
        let x = (pageNumber - 1) * pageSize;
        for (; x < (pageNumber) * pageSize; x++){
            if (filteredData[x]) {
                data.push(filteredData[x]);
                component.set("v.showBookAppointment",false);
            }
        }
        component.set("v.selectedaccId", data);
        console.log("doctors"+JSON.stringify(data[0].Practitioner.Name + " " +data[0].Specialty.Name));
        component.set("v.subspecialityId", data);
        
    },
    preparePagination: function (component, imagesRecords) {
        let countTotalPage = Math.ceil(imagesRecords.length/component.get("v.pageSize"));
        let totalPage = countTotalPage > 0 ? countTotalPage : 1;
        component.set("v.totalPages", totalPage);
        component.set("v.currentPageNumber", 1);
        this.setPageDataAsPerPagination(component);
    },
    prepareHospital: function (component, imagesRecords) {
        let countTotalPage = Math.ceil(imagesRecords.length/component.get("v.pageSizes"));
        let totalPage = countTotalPage > 0 ? countTotalPage : 1;
        component.set("v.totalPage", totalPage);
        component.set("v.currentPageNumbers", 1);
        this.setPageHospitalAsPerPagination(component);
    },
    
    setPageHospitalAsPerPagination: function(component) {
        let data = [];
        let pageNumber = component.get("v.currentPageNumbers");
        let pageSize = component.get("v.pageSizes");
        let filterHopspital = component.get('v.PaginateHospitals');
        let x = (pageNumber - 1) * pageSize;
        for (; x < (pageNumber) * pageSize; x++){
            if (filterHopspital[x]) {
                data.push(filterHopspital[x]);
            }
        }
        component.set("v.careHopspital",data);
    },
    getHospital : function(component, event, helper) {
        var getSelectedDocIds =component.get("v.getDocId");
        var getCareId = component.get('v.careIds');
        helper.showSpinner(component);
        var getDoctorsById = component.get('v.selectedaccId');
        var getHospitalId=component.get('v.AccId');
        var action = component.get("c.fetchHospitalByDoctorId");
        
        action.setParams({
            "doCid":getDoctorsById,
            
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var show = response.getReturnValue(); 
                if(show[0].AccountId != null){
                    helper.hideSpinner(component);
                    component.set("v.filterHopspital",show);
                    component.set("v.showrecords",false );
                    component.set("v.welcomepage",true );
                    component.set("v.providerFound",false);
                    component.set("v.showDoctors",false);
                    component.set("v.showPginationbutton",false);
                    component.set("v.showsub",false);
                    component.set("v.showcount",false);
                    component.set('v.showBookAppointment',false);
                }
                else{
                    component.set("v.welcomepage",false );
                    component.set("v.showBookAppointment",true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title :$A.get("$Label.c.Info"),
                        message:$A.get("$Label.c.The_provider_Is_Not_Found"),
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'info',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    
                    
                }
            }
            
        });
        $A.enqueueAction(action);
        
    },
    fetchcarespeciality :function(component,event,helper){
        
        var action = component.get("c.fetchcarespeciality");
        
        action.setParams({
            
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var show = response.getReturnValue(); 
                component.set('v.CareList',show);
                component.set("v.showrecords",true );
                component.set("v.welcomepage",false );
                component.set("v.providerFound",false);
                component.set("v.showDoctors",false);
                component.set("v.showPginationbutton",false);
                component.set("v.showsub",false);
                component.set("v.showcount",false);
            }
        });
        $A.enqueueAction(action);
    },
    getRequiredSpecialityHospiatals :function(component,event,helper){
        var GetHospIds = component.get("v.AccId");
        var action = component.get("c.getRequiredSpecialityByHospiatals");
        action.setParams({
            "hospId":  GetHospIds 
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var showSpecialty = response.getReturnValue(); 
                component.set('v.CareList',showSpecialty);
                component.set("v.showrecords",true );
                component.set("v.welcomepage",false );
                component.set("v.providerFound",false);
                component.set("v.showDoctors",false);
                component.set("v.showPginationbutton",false);
                component.set("v.showsub",false);
                component.set("v.showcount",false);
                component.set("v.showcareback", true);
                component.set("v.SelectSpecialtyPage",true);
                component.set("v.NoDoctorFound",false);
            }
        });
        $A.enqueueAction(action);     
        
    },
    getspecialityWithDoctors:function(component,event,helper){
        component.set("v.showPginationbutton",true);
        var getDoctorsIds =component.get("v.doctorsIds");
        var getHospitalId=component.get('v.AccId');
        var getcontactId =component.get('v.selectedaccId');
        var action = component.get("c.getSpecialityHospiatalByDoctors");
        action.setParams({
            "doctId":getDoctorsIds,
            "hospId":getHospitalId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var show = response.getReturnValue(); 
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
    
    getHospitalsByCareSpeciality :function(component,event,helper){
        var getCareIds =component.get("v.careIds");
        
        
        var getDoctorsById = component.get('v.selectedaccId');
        
        var action = component.get("c.getHospitalsByCareSpeciality");
        action.setParams({
            'careIds':getCareIds
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var carespecIds = response.getReturnValue();
                if(carespecIds.length <=0 ){
                    component.set("v.showHospitals",false);  
                    component.set("v.showBookAppointment",true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title :$A.get("$Label.c.Info"),
                        message:$A.get("$Label.c.Sorry_There_Is_No_Hospital_Found_For_This_Speciality"),
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'info',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    
                    
                }
                else{
                    
                    component.set('v.careHopspital',carespecIds);
                    component.set('v.PaginateHospitals',carespecIds);
                    component.set("v.showHospitals",true);  
                    component.set("v.showrecords",false );
                    component.set("v.isLoading",false);
                    component.set("v.showBookAppointment",false);
                    component.set("v.careDoctors",true);
                    this.prepareHospital(component,component.get("v.PaginateHospitals"));
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchHospitalByHospitals :function(component,event,helper){
        var getHsopIds = component.get("v.AccId");
        var action = component.get("c.fetchHospitalByHospitals");
        action.setParams({
            'hospitalid':getHsopIds
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var HospIds = response.getReturnValue();
                if(HospIds.length >0){
                    component.set("v.filterHopspital",HospIds);
                    component.set('v.welcomepage',true);
                    component.set("v.showBookAppointment",false);
                    component.set('v.HospitalforHeading',HospIds[0].Account.Name);
                    component.set("v.CheckForSpecilaity",false);
                }
                else{
                    component.set("v.showBookAppointment",true);
                    component.set('v.welcomepage',false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title :$A.get("$Label.c.Info"),
                        message:$A.get("$Label.c.There_Is_No_Provider_Found_In_This_Hospital"),
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'info',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    
                    
                }
            }
        });
        $A.enqueueAction(action);    
    },
    getDoctorsByDoctors : function(component, event, helper,handleAllSearch) {
        var getSelectedDocIds =component.get("v.getDocId");
        var csId =component.get('v.careIds');
        var accId =component.get('v.AccId');
        var action = component.get("c.fetchDoctor");
        action.setParams({
            csId :csId,
            accId:accId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var vertical = response.getReturnValue();
                component.set('v.CheckForSpecilaity',true);
                component.set("v.CareSpecilityforHeading",vertical.practitioners[0].Specialty.Name);
                component.set("v.HospitalforHeading",vertical.practitioners[0].Account.Name);
                component.set('v.countdoctor',vertical.practitioners.length);
                component.set("v.showcount",true);
                // if(vertical.practitioners.length >0){
                if(handleAllSearch == "handleAllSearch"){
                    var practitioners=[];
                    for(var i=0;i<vertical.practitioners.length;i++){
                        if(getSelectedDocIds ==vertical.practitioners[i].PractitionerId ){
                            practitioners.push(vertical.practitioners[i]);
                        }
                    }
                    component.set("v.CareList","");
                    component.set("v.CareList",practitioners);
                    console.log(JSON.stringify(component.get("v.CareList"))+'all process');
                    component.set('v.filteredData', practitioners);
                    component.set("v.welcomepage",false);
                    component.set('v.showrecords',true);
                    component.set("v.showHome",true);
                    
                }
                else if(handleAllSearch =="Hospital"){
                    const getCare = new Map();
                    var getspeciality=[];
                    for(var i=0;i<vertical.practitioners.length;i++){
                        if( getCare.length ==0 ||(!getCare.get(vertical.practitioners[i].Specialty.Name))){
                            getspeciality.push(vertical.practitioners[i]);
                            getCare.set(vertical.practitioners[i].Specialty.Name ,vertical.practitioners[i].Specialty.Name);
                        }
                    }
                    component.set("v.careIds",getspeciality);
                    console.log(JSON.stringify(component.get("v.CareList"))+'acc And care');
                    component.set('v.filteredData',vertical.practitioners);
                    component.set("v.showPginationbutton",true);
                    component.set("v.showHospitalssforCare",false);
                    component.set("v.showHome",false );
                    component.set("v.showHospitalss",true );
                    
                }
                    else if(handleAllSearch =="Acc&care"){
                        const getCare = new Map();
                        var getspeciality=[];
                        if(vertical.practitioners.length >0){
                            for(var i=0;i<vertical.practitioners.length;i++){
                                if( getCare.length ==0 ||(!getCare.get(vertical.practitioners[i].Specialty.Name))){
                                    getspeciality.push(vertical.practitioners[i]);
                                    getCare.set(vertical.practitioners[i].Specialty.Name ,vertical.practitioners[i].Specialty.Name);
                                }
                            }
                            component.set("v.CareList",getspeciality);
                            console.log(JSON.stringify(component.get("v.CareList"))+'acc And care');
                            component.set('v.filteredData',vertical.practitioners);
                            component.set("v.showPginationbutton",true);
                            component.set("v.showHospitalssforCare",true);
                            component.set("v.showHome",false );
                            component.set("v.showHospitalss",false );
                            component.set("v.showcareback", false);
                            // component.set("v.SelectSpecialtyPage",false);
                            // component.set("v.NoDoctorFound",true);
                            component.set("v.careDoctors",false);
                            component.set('v.showrecords',true);
                            this.preparePagination(component,component.get("v.filteredData"));
                            component.set("v.showSubspeciality",true );
                            component.set("v.showDoctors",true );
                            component.set("v.showsubcount",false); 
                            component.set("v.SubCareList",vertical.subSpeciality);
                            component.set("v.providerFound",true);
                            component.set("v.showPginationbutton",true);   
                        }  
                        else{
                            component.set("v.providerFound",false);
                            component.set("v.showPginationbutton",false);
                            component.set('v.showrecords',false);
                            component.set("v.careDoctors",true) ;
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title :$A.get("$Label.c.Info"),
                                message:$A.get("$Label.c.Sorry_No_Doctor_Found_In_This_Hospital"),
                                duration:' 5000',
                                key: 'info_alt',
                                type: 'info',
                                mode: 'dismissible'
                            });
                            toastEvent.fire();  
                        }
                    }
                //component.set("v.getDocId","");
                this.preparePagination(component,component.get("v.filteredData"));
                component.set("v.showSubspeciality",true );
                component.set("v.showDoctors",true );
                component.set("v.showsubcount",false); 
                component.set("v.SubCareList",vertical.subSpeciality);
                component.set("v.providerFound",true);
                component.set("v.showPginationbutton",true);
                // }
                // else{
                //     component.set("v.providerFound",false);
                //     component.set("v.showPginationbutton",false);
                // }
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
    
    getHospitalsByCareSpecialiyAndDoctor : function(component, event, helper) {
        var getSelectedDocIds =component.get("v.getDocId");
        var getCareId = component.get('v.careIds');
        helper.showSpinner(component);
        var getDoctorsById = component.get('v.selectedaccId');
        var getHospitalId=component.get('v.AccId');
        var action = component.get("c.getHospitalsByCareSpecialiyAndDoctor");
        action.setParams({
            "doCid":getSelectedDocIds,
            'careIds':getCareId
            
            
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var show = response.getReturnValue(); 
                if(show.length >0){
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
                        component.set("v.filterHopspital",show);
                        component.set("v.showrecords",false );
                        component.set("v.welcomepage",true );
                        component.set("v.providerFound",false);
                        component.set("v.showDoctors",false);
                        component.set("v.showPginationbutton",false); 
                        component.set("v.showsub",false);
                        component.set("v.showcount",false);
                        component.set('v.showBookAppointment',false);
                    }
                    //  helper.hideSpinner(component);
                    
                    
                    
                }
                
                else{
                    
                    
                    //component.set("v.welcomepage",false );
                    //component.set('v.showBookAppointment',true);
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title :$A.get("$Label.c.Info"),
                        message:$A.get("$Label.c.We_couldnt_find_anything_that_matches_your_search_criteria_Refine_your_search_a"),
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'info',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    // $A.get('e.force:refreshView').fire();
                    
                }
                
            }
            
            
        });
        $A.enqueueAction(action);
    },
    setupDataTable: function (component,event,helper) {
        component.set('v.columns', [
            {label: 'Appointment Number',fieldName: "AppointmentNumber" ,hideDefaultActions: true },
            { label: 'Appointment Date and Time', fieldName: 'SchedStartTime',type:'DateTime',hideDefaultActions: true},
            { label: 'Status', fieldName: 'Status',hideDefaultActions: true},
        ]);
            component.set('v.isShowModal',false);
            component.set("v.showBookAppointment",false);
            component.set("v.showrecords",false );
            component.set("v.showPeronAccountAppointment",true);
            },
            selectedRecords :function(component,event,helper){
            var tab = event.getSource();
            switch (tab.get('v.id')) {
            case 'select' :
            var time=component.get("v.DateTime");
            if(time==null){
            component.set("v.AppStatus",'Scheduled');
            this.onloadPatientapptdata(component, event, helper);
            
            }
            else{
            this.onPageDateChanges(component, event, helper);
            }
            break;
            
            case 'completedcancelled' :
            var time=component.get("v.DateTime");
            if(time==null){
            var status='Completed & Cancelled';
            //var paststate='Cancelled';
            component.set("v.AppStatus",status);
            //component.set("v.paststatus",paststate);
            this.onloadPatientapptdata(component, event, helper);
            //this.getTableDatas(component, event, helper);
            }
            else{
            var status='Completed';
            component.set("v.AppStatus",status);
            this.onPageDateChangess(component, event, helper);
            }
            break;
            }
            },
            onloadPatientapptdata:function(component,event,helper){
            var getLeadId =component.get("v.setUserId");//'0014x00001SkvDNAAZ';//component.get("v.getLeadId");
            var PatientId = component.get("v.setUserId");; //'0014x00001SkvDNAAZ'
            //component.set("v.PatientId",getLeadId);
            if(PatientId != null){
            var selectedTableTab = component.get("v.AppStatus");
            if(selectedTableTab == null){
            selectedTableTab = "Scheduled";
            }
            // var PatientId =component.get("v.PatientId");
            this.setupDataTable(component,event,helper);
            var action = component.get("c.fetchPersonAccountAppointments");
            action.setParams({
            'patientId':PatientId,
            'status' : selectedTableTab, 
           // 'leadId' :getLeadId
            });
            action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
            var showAppointments = response.getReturnValue();
            if(showAppointments.patientDetails != null){
            component.set("v.patientdata",showAppointments.patientDetails);
            }
            var patientApptDetails = showAppointments.patientApptDetails;
            console.log('appointmentlist>>'+JSON.stringify(patientApptDetails));
            if(patientApptDetails.length > 0){
            for (var i = 0; i < patientApptDetails.length; i++) { 
            var row = patientApptDetails[i];
                      row.Status = row.Status;
                      row.SchedStartTime =$A.localizationService.formatDate(row.SchedStartTime, "MM/dd/yyyy, hh:mm a");
        row.AppointmentNumber =row.AppointmentNumber;
    }
    component.set("v.tableData",patientApptDetails);
    component.set('v.getPatientRecordsInPagination', patientApptDetails);
    component.set("v.serviceappointments",true);
    component.set('v.checkValue','false');
    
    this.preparePaginationPateintRecords(component, patientApptDetails);
    
}
 else {
 component.set("v.serviceappointments",false);
}
}
});
$A.enqueueAction(action);
// }
/* else if(getLeadId != null && PatientId == null){
            if(getLeadId != null){
                var selectedTableTab = component.get("v.AppStatus");
                if(selectedTableTab == null){
                selectedTableTab = "Scheduled";
                }
                var PatientId =component.get("v.PatientId");
                this.setupDataTable(component,event,helper);
                var Leadaction = component.get("c.fetchPersonAccountAppointments");
                Leadaction.setParams({
                'patientId':getLeadId,
                'status' : selectedTableTab 
                });
                Leadaction.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                var showAppointments = response.getReturnValue();
                if(showAppointments.patientDetails != null){
                component.set("v.patientdata",showAppointments.patientDetails);
                }
                var patientApptDetails = showAppointments.patientApptDetails;
                console.log('appointmentlist>>'+JSON.stringify(patientApptDetails));
                if(patientApptDetails.length > 0){
                for (var i = 0; i < patientApptDetails.length; i++) { 
                var row = patientApptDetails[i];
                          row.Status = row.Status;
                          row.SchedStartTime =$A.localizationService.formatDate(row.SchedStartTime, "MM/dd/yyyy, hh:mm a");
            row.AppointmentNumber =row.AppointmentNumber;
        }
        component.set("v.tableData",patientApptDetails);
        component.set('v.getPatientRecordsInPagination', patientApptDetails);
        component.set("v.serviceappointments",true);
        component.set('v.checkValue','false');
        this.preparePaginationPateintRecords(component, patientApptDetails);
        
    }
     else {
     component.set("v.serviceappointments",false);
    }
    }
    });
    $A.enqueueAction(Leadaction);
        }
    }*/
}
},
    
    getTableData :function(component,event,helper){
        this.showSpinner(component, event, helper);
        this.setupDataTable(component,event,helper);
        var status='Scheduled';
        component.set("v.AppStatus",status);
        var stat = component.get("v.AppStatus");
        var PatientId =component.get("v.PatientId");
        let baseUrlOfOrg= 'https://'+location.host+'/';
        if(PatientId!=null){
            var action = component.get("c.fetchPersonAccountAppointments");
            action.setParams({
                'PatientId':PatientId,
                status : stat
                
            }); 
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var showAppointments = response.getReturnValue();
                    if(showAppointments.length>0){
                        this.hideSpinner(component, event, helper);
                        component.set('v.getName',showAppointments[0].Account.Name);
                        component.set('v.getAddress',showAppointments[0].Account.PersonMailingAddress.street);
                        component.set('v.Phone',showAppointments[0].Account.Phone);
                        component.set('v.Email',showAppointments[0].Account.PersonEmail);
                        component.set('v.Gender',showAppointments[0].Account.HealthCloudGA__Gender__pc);
                        component.set('v.Maritalstatus',showAppointments[0].Account.Marital_Status_Code__pc);
                        component.set('v.Birthdate',showAppointments[0].Account.PersonBirthdate);
                        
                        
                        for (var i = 0; i < showAppointments.length; i++) { 
                            var row = showAppointments[i];
                            row.Department = row.Account.Name;
                            row.AppointmentUrl =baseUrlOfOrg+row.Id;
                            row.Status = row.Status;
                            row.DueDate =$A.localizationService.formatDate(row.DueDate, "MM/dd/yyyy, hh:mm a");
                            row.AppointmentNumber =row.AppointmentNumber;
                        }
                        component.set("v.tableData",showAppointments);
                        
                        component.set("v.serviceappointments",true);
                        
                        component.set('v.getPatientRecordsInPagination', showAppointments);
                        if(component.get('v.getPatientRecordsInPagination').length == 0){
                            component.set('v.checkValue','false');
                        }
                        this.preparePaginationPateintRecords(component, showAppointments);
                        
                    }
                    else if(showAppointments.length==0){
                        component.set("v.serviceappointments",false);
                    }
                }
                /* else if (PatientId == null) {
                  component.set("v.showNoAppointment",true);
                  component.set("v.showPeronAccountAppointment",false);
                }*/
        
    });
                
                $A.enqueueAction(action);
            }
        else{
            
            // component.set("v.showNoAppointment",true);
            // component.set("v.showPeronAccountAppointment",false);
            component.set("v.showNoAppointment",true); 
            this.showSpinner(component, event, helper);
            this.setupDataTable(component,event,helper);
            var status='Scheduled';
            component.set("v.AppStatus",status);
            var PatientId =component.get("v.getLeadId");
            let baseUrlOfOrg= 'https://'+location.host+'/';
            if(PatientId!=null){
                var Leadaction = component.get("c.fetchDetailsWithPersonAccountId");
                Leadaction.setParams({
                    'PatientId':PatientId,
                    
                    
                }); 
                Leadaction.setCallback(this, function(responses){
                    var state = responses.getState();
                    if (state === "SUCCESS") {
                        var showAppointments = responses.getReturnValue();
                        this.hideSpinner(component, event, helper);
                        component.set('v.getName',showAppointments[0].Name);
                        component.set('v.getAddress',showAppointments[0].PersonMailingAddress.street);
                        component.set('v.Phone',showAppointments[0].Phone);
                        component.set('v.Email',showAppointments[0].PersonEmail);
                        for (var i = 0; i < showAppointments.length; i++) { 
                            var row = showAppointments[i];
                            row.Department = row.Account.Name;
                            row.AppointmentUrl =baseUrlOfOrg+row.Id;
                            row.Status = row.Status;
                            row.DueDate =$A.localizationService.formatDate(row.DueDate, "MM/dd/yyyy, hh:mm a");
                            row.AppointmentNumber =row.AppointmentNumber;
                        }
                        component.set("v.tableData",showAppointments);
                        component.set('v.getPatientRecordsInPagination', showAppointments);
                        if(component.get('v.getPatientRecordsInPagination').length == 0){
                            component.set('v.checkValue','false');
                        }
                        this.preparePaginationPateintRecords(component, showAppointments);
                        
                        
                        
                    }
                    /* else if (PatientId == null) {
                  component.set("v.showNoAppointment",true);
                  component.set("v.showPeronAccountAppointment",false);
                }*/
                    
                });
                
                $A.enqueueAction(Leadaction);
            }
        }
        
    },
        getTableDatas :function(component,event,helper){
            this.showSpinner(component, event, helper);
            this.setupDataTable(component,event,helper);
            var stat = component.get("v.AppStatus");
            var paststate=component.get("v.paststatus");
            var PatientId =component.get("v.PatientId");
            let baseUrlOfOrg= 'https://'+location.host+'/';
            var action = component.get("c.fetchPersonAccountAppointmentsStatus");
            action.setParams({
                'PatientId':PatientId,
                'status' : stat,
                'paststate':paststate
            }); 
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var showAppointments = response.getReturnValue();
                    if(showAppointments.length>0){ 
                        this.hideSpinner(component, event, helper);
                        for (var i = 0; i < showAppointments.length; i++) { 
                            var row = showAppointments[i];
                            row.Department = row.Account.Name;
                            row.AppointmentUrl =baseUrlOfOrg+row.Id;
                            row.Status = row.Status;
                            row.DueDate =$A.localizationService.formatDate(row.DueDate, "MM/dd/yyyy, hh:mm a");
                            row.AppointmentNumber =row.AppointmentNumber;
                        }
                        component.set("v.tableData",showAppointments);
                        component.set("v.serviceappointments",true);
                        
                        component.set('v.getPatientRecordsInPagination', showAppointments);
                        if(component.get('v.getPatientRecordsInPagination').length == 0){
                            component.set('v.checkValue','false');
                        }
                        this.preparePaginationPateintRecords(component, showAppointments);
                        
                    }
                    else if(showAppointments.length==0){
                        component.set("v.serviceappointments",false);
                        
                        
                    }
                }
                else if (state === "ERROR") {
                    console.log('error'+state);
                }
                return null;  
            });
            
            $A.enqueueAction(action);
        },
            preparePaginationPateintRecords: function (component, imagesRecords) {
                let countTotalPage = Math.ceil(imagesRecords.length/component.get("v.pageSizess"));
                let totalPage = countTotalPage > 0 ? countTotalPage : 1;
                component.set("v.PagesTotal", totalPage);
                component.set("v.PresentPageNumber", 1);
                this.setPageDataAsPerPatientRecord(component);
            },
                setPageDataAsPerPatientRecord: function(component) {
                    let data = [];
                    let pageNumber = component.get("v.PresentPageNumber");
                    let pageSize = component.get("v.pageSizess");
                    let filteredData = component.get('v.getPatientRecordsInPagination');
                    let x = (pageNumber - 1) * pageSize;
                    for (; x < (pageNumber) * pageSize; x++){
                        if (filteredData[x]) {
                            data.push(filteredData[x]);
                        }
                    }
                    component.set("v.tableData", data);
                },
                    onPageDateChanges: function(component, event, helper) {
                        this.showSpinner(component, event, helper);
                        var PatientId =component.get("v.PatientId");
                        var FetchDate=component.find("DateChange").get("v.value");
                        
                        if(FetchDate==null){
                            this.getTableData(component,event, helper);
                        }
                        else{
                            component.set("v.DateTime",FetchDate);
                            var stat = 'Scheduled';
                            component.set("v.AppStatus",stat);
                            var status=component.get("v.AppStatus");
                            let baseUrlOfOrg= 'https://'+location.host+'/';
                            var methodcall=component.get("c.fetchContactByDates");
                            methodcall.setParams({
                                PatientId : PatientId,
                                SelectedDate :FetchDate,
                                status : status
                                
                            });
                            methodcall.setCallback(this, function(response){
                                var state=response.getState();
                                if(state === "SUCCESS"){
                                    var result=response.getReturnValue();
                                    this.hideSpinner(component, event, helper);
                                    for (var i = 0; i < result.length; i++) { 
                                        var row = result[i];
                                        row.Department = row.Account.Name;
                                        row.AppointmentUrl =baseUrlOfOrg+row.Id;
                                        row.Status = row.Status;
                                        row.DueDate =$A.localizationService.formatDate(row.DueDate, "MM/dd/yyyy, hh:mm a");
                                        row.AppointmentNumber =row.AppointmentNumber;
                                    }
                                    component.set('v.tableData', result);
                                    component.set('v.getPatientRecordsInPagination', result);
                                    if(component.get('v.getPatientRecordsInPagination').length == 0){
                                        component.set('v.checkValue','false');
                                    }
                                    this.preparePaginationPateintRecords(component, result);
                                    
                                } 
                                else if (state === "ERROR") {
                                    console.log('error'+state);
                                }
                                return null;  
                            });
                            $A.enqueueAction(methodcall);
                        } 
                    },
                        onPageDateChangess: function(component, event, helper) {
                            this.showSpinner(component, event, helper);
                            var PatientId =component.get("v.PatientId");
                            var FetchDate=component.find("DateChange").get("v.value");
                            
                            if(FetchDate==null){
                                this.getTableDatas(component,event, helper);
                            }
                            else{
                                component.set("v.DateTime",FetchDate);
                                var status=component.get("v.AppStatus");
                                let baseUrlOfOrg= 'https://'+location.host+'/';
                                var methodcall=component.get("c.fetchContactByDates");
                                methodcall.setParams({
                                    PatientId : PatientId,
                                    SelectedDate :FetchDate,
                                    status : status
                                    
                                });
                                methodcall.setCallback(this, function(response){
                                    var state=response.getState();
                                    if(state === "SUCCESS"){
                                        var result=response.getReturnValue();
                                        this.hideSpinner(component, event, helper);
                                        for (var i = 0; i < result.length; i++) { 
                                            var row = result[i];
                                            row.Department = row.Account.Name;
                                            row.AppointmentUrl =baseUrlOfOrg+row.Id;
                                            row.Status = row.Status;
                                            row.DueDate =$A.localizationService.formatDate(row.DueDate, "MM/dd/yyyy, hh:mm a");
                                            row.AppointmentNumber =row.AppointmentNumber;
                                        }
                                        component.set('v.tableData', result);
                                        component.set('v.getPatientRecordsInPagination', result);
                                        if(component.get('v.getPatientRecordsInPagination').length == 0){
                                            component.set('v.checkValue','false');
                                        }
                                        this.preparePaginationPateintRecords(component, result);
                                        
                                    } 
                                    else if (state === "ERROR") {
                                        console.log('error'+state);
                                    }
                                    return null;  
                                });
                                $A.enqueueAction(methodcall);
                            } 
                        },
                            deltingCheckboxAccounts : function(component, event, deltIds, helper) {
                                this.showSpinner(component, event, helper);
                                var time=component.get("v.DateTime");
                                var action = component.get("c.cancelRecord");
                                action.setParams({
                                    cancelIds : deltIds
                                });
                                action.setCallback(this, function(response) {
                                    var state = response.getState();
                                    if (state === "SUCCESS") {
                                        this.hideSpinner(component, event, helper);
                                        var result=response.getReturnValue();
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({        
                                            title:$A.get("$Label.c.Success"),      
                                            message:$A.get("$Label.c.Appointment_has_been_Canceled_successfully"),
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
                                                
                                            }
                                        } 
                                    }
                                });
                                
                                $A.enqueueAction(action);
                            },
                                getFlowsWithOtp :function(component,event,helper){
                                    this.showSpinner(component);
                                    var confirming=component.find('confirmotp').get("v.value");
                                    if(confirming == []){
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            title :$A.get("$Label.c.Error"),
                                            message:$A.get("$Label.c.Please_Enter_OTP"),
                                            duration:' 3000',
                                            key: 'info_alt',
                                            type: 'error',
                                            mode: 'dismissible'
                                        });
                                        toastEvent.fire();
                                        this.hideSpinner(component);
                                    }
                                    else{
                                        var code=component.get("v.otpCode");
                                        if(code!=undefined && code!==null){
                                            if(confirming == code){
                                                var toastEvent = $A.get("e.force:showToast");
                                                toastEvent.setParams({        
                                                    title:$A.get("$Label.c.Success"),      
                                                    message:$A.get("$Label.c.OTP_verification_is_completed"),
                                                    type:"success",
                                                    mode:"pester"      
                                                });
                                                toastEvent.fire();
                                                
                                                //to create a survey invitation for user by raghu dont remove this block of code
                                                component.set("v.isShowModal",false);
                                                var careId = component.get("v.CareList");
                                                var getCareId=component.get("v.careSpcId");
                                                var patientId=component.get("v.PatientId");
                                                if(getCareId != null){
                                                //console.log('careId>>'+JSON.stringify(careId[0].Specialty.Id));
                                                var win;
                                                var action = component.get("c.createInvite");
                                                action.setParams({
                                                    careId :getCareId,
                                                    patientId : patientId
                                                });
                                                action.setCallback(this, function(response){
                                                    var state = response.getState();
                                                    if (state === "SUCCESS") {
                                                        var url=response.getReturnValue();
                                                        component.set("v.iframeUrl",url.invitationFetch.InvitationLink);
                                                        component.set("v.ServeySubjectId",url.subjectFetch.Id);
                                                        component.set('v.iframepopup',true);
                                                        component.set('v.isShowModal',false);
                                                        component.set('v.showrecords',false);
                                                        
                                                        this.hideSpinner(component);
                                                        //window.open(url);
                                                        // win = window.open(url.invitationFetch.InvitationLink,'targetWindow',' width=600px,height=600px ');
                                                    }
                                                 
                }); 
                $A.enqueueAction(action);
            }
            else{
                component.set('v.isShowLogin',false);
                    component.set('v.showrecords',false);
                    component.set('v.MyAppointments',true);
                    component.set('v.isShowModal',false);
                    
                   
            }
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title :$A.get("$Label.c.Error"),
                    message:$A.get("$Label.c.Please_Enter_Valid_OTP"),
                    duration:' 3000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'dismissible'
                });
                toastEvent.fire();
                this.hideSpinner(component);
            }
        }
            }
        },
            getExactHospitalByMissMatchHospitals : function(component, event, helper) {
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title :$A.get("$Label.c.Info"),
                    message:$A.get("$Label.c.Sorry_This_Doctor_Not_Found_In_Selected_Hospital_You_Can_Go_Through_with_This_Ho"),
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'info',
                    mode: 'dismissible'
                });
                toastEvent.fire();
                var getSelectedDocIds =component.get("v.getDocId");
                var getCareId = component.get('v.careIds');
                helper.showSpinner(component);
                var getDoctorsById = component.get('v.selectedaccId');
                var getHospitalId=component.get('v.AccId');
                var action = component.get("c.fetchHospitalByDoctorId");
                
                action.setParams({
                    "doCid":getDoctorsById,
                    
                });
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var show = response.getReturnValue(); 
                        helper.hideSpinner(component);
                        component.set("v.filterHopspital",show);
                        component.set("v.showrecords",false );
                        component.set("v.welcomepage",true );
                        component.set("v.providerFound",false);
                        component.set("v.showDoctors",false);
                        component.set("v.showPginationbutton",false);
                        component.set("v.showsub",false);
                        component.set("v.showcount",false);
                        component.set("v.showBookAppointment",false);
                    }
                    
                });
                $A.enqueueAction(action);
                
            },
                getSpecialityHospiatalByMismatchDoctorsAndHospitals:function(component,event,helper){
                    component.set("v.showPginationbutton",true);
                    var getcontactId =component.get('v.selectedaccId');
                    var action = component.get("c.getSpecialityHospiatalByMismatchDoctorsAndHospitals");
                    action.setParams({
                        "doctId":getcontactId,
                        
                    });
                    action.setCallback(this, function(response){
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            var show = response.getReturnValue(); 
                            component.set('v.filteredData',show);
                            component.set("v.showSubspeciality",true );
                            component.set('v.CareList',show);
                            component.set('v.showrecords',true);
                            component.set('v.welcomepage',false);
                            component.set('v.providerFound',true);
                            component.set("v.showDoctors",true);
                            
                        }
                        this.preparePagination(component,component.get("v.filteredData"));
                    });
                    $A.enqueueAction(action);
                },
     
                    
                    getMyValue:function(component,event,helper){
   //       alert('inside helper');
                          // Inside your Aura component
 //var customLWC = component.find('contractRenewEnglishId');
        
        
      
 //component.set("v.iframepopup",true);
                        
                    },

sendattchid: function(component,event,helper,getattchId){
   // var getattchId = component.get("v.attachmentId");
                 //alert('getattchId>>'+getattchId);
                  var actions = component.get("c.sendPostRequest");
                actions.setParams({
                    attachmentId : getattchId
                });
                actions.setCallback(this, function(response){
                    var state = response.getState();
                    if (state === "SUCCESS") {                        
                        var url=response.getReturnValue();
                        component.set('v.isShowModal',false);
                        component.set('v.showrecords',false);
                        var AppointmentType =component.get("v.AppointmentType");
                   // component.set("v.getSurveyresponceId",getResponce[0].ResponseId);
                    if(AppointmentType=='Virtual And In-Person'){
                        component.set("v.iframepopup",false);
                        component.set("v.showZoompopup",true);
                    }
                    
                    else if(AppointmentType=='Virtual'){
                        var accntId=component.get("v.AccId");
                        var contactId=component.get("v.contactId");
                        var getid = component.get("c.createfacilities");
                        getid.setParams({
                            accntId : accntId,
                            contctId: contactId
                            
                        });
                        getid.setCallback(this, function(response){
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                helper.hideSpinner(component);
                                var result = response.getReturnValue();
                                if(result != null){
                                    component.set("v.WorkTypeId",result.workTypeName.WorkTypeId);
                                    var workTypeId=component.get("v.WorkTypeId");
                                    component.set("v.WorkTypeGroupId",result.workTypeGroupName.WorkTypeGroupId);
                                    var WorkTypeGroupId=component.get("v.WorkTypeGroupId");  
                                    component.set("v.timezonename",result.practitionerfacility.ServiceTerritoryMember.ServiceTerritory.OperatingHours.TimeZone);
                                    var timeZone=component.get("v.timezonename");
                                    component.set("v.territoryId",result.practitionerfacility.ServiceTerritoryMember.ServiceTerritoryId);
                                    var territoryId=component.get("v.territoryId");
                                    component.set("v.resourceId",result.practitionerfacility.ServiceTerritoryMember.ServiceResourceId);
                                    var resourceId=component.get("v.resourceId");
                                }   
                                component.set("v.iframepopup",false);
                                component.set('v.FlowPopup',true);
                                
                                var patientId=component.get("v.PatientId");
                                var ServeySubjectId=component.get("v.ServeySubjectId");
                               // alert(ServeySubjectId);
                                var appTypeName=component.get("v.AppointmentType");
                                const flow = component.find("flowData");
                                var inputVariables = [
                                    {
                                        name:"varLeadId",
                                        type:"String",
                                        value:patientId
                                    },
                                    {
                                        name:"varTerrId",
                                        type:"String",
                                        value:territoryId
                                    },
                                    
                                    {
                                        name:"varResourceId",
                                        type:"String",
                                        value:resourceId
                                    },
                                    {
                                        name:"varAccountId",
                                        type:"String",
                                        value:accntId
                                    },
                                    {
                                        name:"varContactId",
                                        type:"String",
                                        value:contactId
                                    },
                                    
                                    {
                                        name:"WorkTypeGroupId",
                                        type:"String",
                                        value:WorkTypeGroupId
                                    },
                                    
                                    {
                                        name:"varTimeZone",
                                        type:"String",
                                        value:timeZone
                                    },
                                    {
                                        name:"VarSubjectId",
                                        type:"String",
                                        value:attachmentId
                                    },
                                    {
                                        name:"varAppTypeName",
                                        type:"String",
                                        value:appTypeName
                                    }
                                    
                                ];
                                
                                flow.startFlow("Time_Slot_Checking",inputVariables);
                            }
                            else{
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    title :$A.get("$Label.c.Info"),
                                    message:$A.get("$Label.c.Sorry_No_Records_Found"),
                                    duration:' 5000',
                                    key: 'info_alt',
                                    type: 'info',
                                    mode: 'dismissible'
                                });
                                toastEvent.fire();
                            }   
                        });
                        $A.enqueueAction(getid);
                    }
                        else{
                            var accntId=component.get("v.AccId");
                            var contactId=component.get("v.contactId");
                            var getid = component.get("c.createfacilities");
                            getid.setParams({
                                accntId : accntId,
                                contctId: contactId
                                
                            });
                            getid.setCallback(this, function(response){
                                var state = response.getState();
                                if (state === "SUCCESS") {
                                    helper.hideSpinner(component);
                                    var result = response.getReturnValue();
                                    if(result != null){
                                        component.set("v.WorkTypeId",result.workTypeName.WorkTypeId);
                                        var workTypeId=component.get("v.WorkTypeId");
                                        component.set("v.WorkTypeGroupId",result.workTypeGroupName.WorkTypeGroupId);
                                        var WorkTypeGroupId=component.get("v.WorkTypeGroupId");  
                                        component.set("v.timezonename",result.practitionerfacility.ServiceTerritoryMember.ServiceTerritory.OperatingHours.TimeZone);
                                        var timeZone=component.get("v.timezonename");
                                        component.set("v.territoryId",result.practitionerfacility.ServiceTerritoryMember.ServiceTerritoryId);
                                        var territoryId=component.get("v.territoryId");
                                        component.set("v.resourceId",result.practitionerfacility.ServiceTerritoryMember.ServiceResourceId);
                                        var resourceId=component.get("v.resourceId");
                                    }   
                                    component.set("v.iframepopup",false);
                                    component.set('v.FlowPopup',true);
                                    
                                    var patientId=component.get("v.PatientId");
                                    var ServeySubjectId=component.get("v.ServeySubjectId");
                                    var appTypeName=component.get("v.AppointmentType");
                                    const flow = component.find("flowData");
                                    var inputVariables = [
                                        {
                                            name:"varLeadId",
                                            type:"String",
                                            value:patientId
                                        },
                                        {
                                            name:"varTerrId",
                                            type:"String",
                                            value:territoryId
                                        },
                                        
                                        {
                                            name:"varResourceId",
                                            type:"String",
                                            value:resourceId
                                        },
                                        {
                                            name:"varAccountId",
                                            type:"String",
                                            value:accntId
                                        },
                                        {
                                            name:"varContactId",
                                            type:"String",
                                            value:contactId
                                        },
                                        
                                        {
                                            name:"WorkTypeGroupId",
                                            type:"String",
                                            value:WorkTypeGroupId
                                        },
                                        
                                        {
                                            name:"varTimeZone",
                                            type:"String",
                                            value:timeZone
                                        },
                                        {
                                            name:"VarSubjectId",
                                            type:"String",
                                            value:attachmentId
                                        },
                                        {
                                            name:"varAppTypeName",
                                            type:"String",
                                            value:appTypeName
                                        }
                                        
                                    ];
                                    
                                    flow.startFlow("Time_Slot_Checking",inputVariables);
                                }
                                else{
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        title :$A.get("$Label.c.Info"),
                                        message:$A.get("$Label.c.Sorry_No_Records_Found"),
                                        duration:' 5000',
                                        key: 'info_alt',
                                        type: 'info',
                                        mode: 'dismissible'
                                    });
                                    toastEvent.fire();
                                }
                                
                            });
                            $A.enqueueAction(getid);
                        }
              //  }
                
        
        
                        //win = window.open(url.invitationFetch.InvitationLink,'targetWindow',' width=600px,height=600px ');
                    }
                    
                });
                $A.enqueueAction(actions);
         
}
})