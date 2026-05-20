({
    init :function(component, event,helper) {
        var sURL = window.location.href;
        
        var userId = sURL.split('source=')[1];
        
        var action = component.get("c.getDefaultLanguage");
        action.setCallback(this,function(response){   
            var state = response.getState();  
            if(state === "SUCCESS"){ 
                var defaultLan = response.getReturnValue();
                if(defaultLan == 'en_US'){
                    component.set("v.defaultLanguage", 'English');
                }
                else if(defaultLan == 'zh_CN'){
                    component.set("v.defaultLanguage", '中国人');
                }
                
            }
            else if(state === 'ERROR'){
                alert('ERROR OCCURED.'+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
       var action = component.get("c.getUserId");
            action.setParams({
            });
     action.setCallback(this, function(response){
         var state = response.getState();
         if(state === 'SUCCESS')
             var getuserId = response.getReturnValue(); 
         component.set("v.setUserId",getuserId.AccountId);//getuserId.AccountId'0014x00001SkvDNAAZ'
     });
    $A.enqueueAction(action);  
    helper.loadPortalLocations(component, null);
        
    },

    handleCmpEvent: function(component, event) {
        var message = event.getParam("message");
        component.set("v.showBookAppointment",true);
        if(message == 'back to home'){
            component.set("v.showBookAppointment",true);
        }
        //cmp.set("v.messageTemp", message);
    },

    openApolloLogin : function(component, event, helper) {
        component.set("v.isShowLogin", false);
        component.set("v.showBookAppointment", true);
        component.set("v.isNextModalsForLogin", true);
        component.set("v.isNextModalForSignUp", false);
        component.set("v.showconfirmbotton", true);
        component.set("v.showverifybotton", false);
        component.set("v.hideNumberButtonLogin", true);
        component.set("v.hideOtpButtonLogin", false);
        component.set("v.guestUserForLoginOrSignUp", false);
        component.set("v.portalEntryIdentifier", "");
        component.set("v.portalOtpInput", "");
        component.set("v.newLead", {
            'sobjectType': 'Lead',
            'Title': '',
            'FirstName': '',
            'LastName': '',
            'Email': '',
            'Address': '',
            'Company': '',
            'Phone': '',
            'Street': '',
            'City': '',
            'Country': '',
            'State': '',
            'PostalCode': ''
        });
    },

    portalSignOut : function(component, event, helper) {
        component.set("v.portalAuthenticated", false);
        component.set("v.portalPatientLabel", '');
        component.set("v.PatientId", null);
        component.set("v.MyAppointments", false);
        component.set("v.showPeronAccountAppointment", false);
        component.set("v.serviceappointments", false);
        component.set("v.showBookAppointment", true);
        component.set("v.portalEntryIdentifier", "");
        component.set("v.portalOtpInput", "");
        component.set("v.portalPassword", "");
        component.set("v.portalConfirmPassword", "");
        component.set("v.guestUserForLoginOrSignUp", false);
        component.set("v.isNextModalForSignUp", false);
        component.set("v.isNextModalsForLogin", true);
    },

    openPortalProfile : function(component, event, helper) {
        component.set("v.showBookAppointment", false);
        component.set("v.showrecords", false);
        helper.onloadPatientapptdata(component, event, helper);
    },

// handleCancel:function(component, event, helper) {
//     component.set("v.isShowLogin",false);
//     component.set("v.showrecords",true);

// },
  
    
    handleCancelFirstLead:function(component, event, helper){
        component.set("v.isShowLogin",false);
        component.set("v.isNextModalsForLogin",true);
        component.set("v.isNextModalForSignUp",false);
        component.set("v.showconfirmbotton",true);
        component.set("v.hideNumberButtonLogin",true);
        component.set("v.guestUserForLoginOrSignUp",false);
        component.set("v.showBookAppointment",true);
        component.set("v.portalOtpInput", "");
        component.set("v.portalPassword", "");
        component.set("v.portalConfirmPassword", "");
    },
    
    handleCancelforSecondLeadPage:function(component, event, helper){
        component.set("v.isconfirm",true);
        component.set("v.hideNumberButton",true);
        component.set("v.isNextModals",true);
        component.set("v.isShowModal",true);
        component.set("v.guestUser",false);
        component.set("v.showrecords",true);
        
    },
    handleCancelforloginsignup:function(component, event, helper){
        component.set("v,isShowLogin",true);
        component.set("v.guestUserForLoginOrSignUp",false);
        $A.enqueueAction(action);
    },
    
    afterLoad:function(component, event, helper) {
        var secret='12345';
        var code= new jsOTP.totp().getOtp(secret);
        component.set("v.otpCode",code);
    },
    
    OpenModalBox : function(component,event,helper){
        helper.showSpinner(component);
        var code=component.get("v.otpCode");
        if(code!=null){
            var getEmail=component.find('inputValue').get("v.value");
            if(getEmail==[]){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title:$A.get("$Label.c.Error"),
                    mode:"dismissible",
                    message:$A.get("$Label.c.Please_Enter_Your_Email_Or_Phone_Number"),
                    type:"error"
                });
                toastEvent.fire();
                helper.hideSpinner(component);
            }
            else{
                var callMethod=component.get("c.getPatient");
                callMethod.setParams({
                    getEmail : getEmail
                });
                callMethod.setCallback(this,function(responce){
                    var state=responce.getState(); 
                    if(state=='SUCCESS'){
                        var result=responce.getReturnValue();
                        if(result.confirming==null){
                            if (/^[0-9]*$/g.test(getEmail)) {
                                if(getEmail.length >10 || getEmail.length <10){
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        title:$A.get("$Label.c.Error"),
                                        mode:"dismissible",
                                        message:$A.get("$Label.c.Phone_Number_Must_Contain_Min_Or_Max_10_digits"),
                                        type:"error"
                                    });
                                    toastEvent.fire();
                                    helper.hideSpinner(component);
                                }
                                else{
                                    var showhomepage =component.get("v.showBookAppointment");
                                    var showrecordpage =component.get("v.showrecords");
                                    if(showhomepage == true){
                                        var getpage ='ShowBookpage';
                                        component.set("v.callcomponentmessage",getpage);
                                    component.set("v.showBookAppointment",false);
                                       component.set("v.showLeadForminChildComponet",true);
                                    component.set("v.isNextModals",false);
                                      component.set("v.isShowModal",false);
                                      component.set("v.showrecords",false);
                                    var LeadForm = component.find("leadform");
                                    LeadForm.getScoreMethod('aa','bb','cc');
                                 
                                    }
                                    else if(showrecordpage == true){
                                        var getpage ='DoctorRecordPage';
                                        component.set("v.callcomponentmessage",getpage);
                                        component.set("v.showBookAppointment",false);
                                        component.set("v.showLeadForminChildComponet",true);
                                     component.set("v.isNextModals",false);
                                       component.set("v.isShowModal",false);
                                       component.set("v.showrecords",false);
                                     var LeadForm = component.find("leadform");
                                     LeadForm.getScoreMethod('aa','bb','cc');
                                    }
                                 
                                }
                            }
                            else{
                                if(!/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(getEmail)){
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        title:$A.get("$Label.c.Error"),
                                        mode:"dismissible",
                                        message:$A.get("$Label.c.Please_Type_Valid_Email_Address_Or_WhatsApp_Number"),
                                        type:"error"
                                    });
                                    toastEvent.fire();
                                    helper.hideSpinner(component);
                                }
                                else{
                                    component.set("v.guestUser",true);
                                    component.set("v.showrecords",false);
                                    component.set("v.isShowModal",false);
                                    component.set("v.isverify",false);
                                    component.set("v.isNextModal",false);
                                    helper.hideSpinner(component);
                                }
                            }
                        }
                        if(result.confirming==true){
                            var recordIds=result.patientOtp.Id;
                            component.set("v.PatientId",recordIds);
                            alert(PatientId);
                            var action=component.get("c.sendOTP");
                            action.setParams({
                                recordId : recordIds,
                                otp : code                   
                            });
                            action.setCallback(this,function(responces){
                                var states=responces.getState();
                                if(states=='SUCCESS'){
                                    helper.hideSpinner(component);
                                    var returnvalue=responces.getReturnValue();
                                    component.set("v.isNextModal",true);
                                    component.set("v.isverify",true);
                                    component.set("v.hideNumberButton",false);
                                    component.set("v.hideOtpButton",true);
                                    component.set("v.isconfirm",false);
                                    component.set("v.isNextModals",false);
                                    // component.set("v.buttondisable",true);
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({        
                                        title:$A.get("$Label.c.Success"),      
                                        message:$A.get("$Label.c.OTP_Sent_To_Your_Email"),
                                        type:"success",
                                        mode:"pester"      
                                    });
                                    toastEvent.fire();
                                }
                            });
                            $A.enqueueAction(action);       
                        }
                        else{
                            
                            var recordId=result.patientOtp.Id;
                            component.set("v.PatientId",recordId);
                            var actions=component.get("c.sendOTPs");
                            actions.setParams({
                                recordId : recordId,
                                otp : code                   
                            });
                            actions.setCallback(this,function(responcess){
                                var statess=responcess.getState();
                                if(statess=='SUCCESS'){
                                    helper.hideSpinner(component);
                                    var returnvalue=responcess.getReturnValue();
                                    component.set("v.isNextModal",true);
                                    component.set("v.isverify",true);
                                    component.set("v.hideNumberButton",false);
                                    component.set("v.hideOtpButton",true);
                                    component.set("v.isconfirm",false);
                                    component.set("v.isNextModals",false);
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({        
                                        title:$A.get("$Label.c.Success"),      
                                        message:$A.get("$Label.c.OTP_Sent_To_Your_WhatsApp_Number"),
                                        type:"success",
                                        mode:"pester"      
                                    });
                                    toastEvent.fire();
                                }
                            });
                            $A.enqueueAction(actions);       
                        }
                        
                        
                    }
                    
                });
                $A.enqueueAction(callMethod);
                
            }  
            
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title:$A.get("$Label.c.Error"),
                mode:"dismissible",
                message:$A.get("$Label.c.Failed_to_Generate_Otp"),
                type:"error"
            });
            toastEvent.fire();
            helper.hideSpinner(component);
            
        }
    },
    OpenModalBoxForLogin : function(component,event,helper){
        helper.showSpinner(component);
        var code=component.get("v.otpCode");
        if(code!=null){
            var getEmail = (component.get("v.portalEntryIdentifier") || '').trim();
            if(!getEmail && component.find('inputValue')){
                getEmail = component.find('inputValue').get("v.value");
            }
            
            if(!getEmail){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title:$A.get("$Label.c.Error"),
                    mode:"dismissible",
                    message:"Please enter your registered email address.",
                    type:"error"
                });
                toastEvent.fire();
                helper.hideSpinner(component);
            }
            else{
                if(!/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(getEmail)){
                    var emailToast = $A.get("e.force:showToast");
                    emailToast.setParams({
                        title:$A.get("$Label.c.Error"),
                        mode:"dismissible",
                        message:"Please enter a valid email address to continue.",
                        type:"error"
                    });
                    emailToast.fire();
                    helper.hideSpinner(component);
                    return;
                }
                var callMethod=component.get("c.getPatient");
                callMethod.setParams({
                    getEmail : getEmail
                });
                callMethod.setCallback(this,function(responce){
                    var state=responce.getState(); 
                    if(state=='SUCCESS'){
                        var result=responce.getReturnValue();
                        if(result.confirming==null){
                            component.set("v.guestUserForLoginOrSignUp",true);
                            component.set("v.showrecords",false);
                            component.set("v.isShowLogin",false);
                            component.set("v.isNextModalsForLogin",false);
                            component.set("v.showBookAppointment",true);
                            component.set("v.portalPatientLabel", "");
                            component.set("v.newLead.Email", getEmail);
                            helper.hideSpinner(component);
                        }
                        else if(result.confirming==true){
                            var recordIds=result.patientOtp.Id;
                            component.set("v.PatientId",recordIds);
                            component.set("v.portalPatientLabel", result.patientOtp.Name);
                            component.set("v.portalEntryIdentifier", getEmail);
                            var action=component.get("c.sendOTP");
                            action.setParams({
                                recordId : recordIds,
                                otp : code                   
                            });
                            action.setCallback(this,function(responces){
                                var states=responces.getState();
                                if(states=='SUCCESS'){
                                    helper.hideSpinner(component);
                                    var returnvalue=responces.getReturnValue();
                                    component.set("v.isNextModalForSignUp",true);
                                    component.set("v.isNextModalsForLogin",false);
                                    component.set("v.showverifybotton",true);
                                    component.set("v.showconfirmbotton",false);
                                    component.set("v.hideNumberButtonLogin",false);
                                    component.set("v.hideOtpButtonLogin",true);
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({        
                                        title:$A.get("$Label.c.Success"),      
                                        message:"OTP sent to your email address.",
                                        type:"success",
                                        mode:"pester"      
                                    });
                                    toastEvent.fire();
                                }
                            });
                            $A.enqueueAction(action);       
                        }
                        else{
                            component.set("v.guestUserForLoginOrSignUp",true);
                            component.set("v.showBookAppointment",true);
                            component.set("v.newLead.Email", getEmail);
                            component.set("v.portalPatientLabel", "");
                            helper.hideSpinner(component);
                        }
                    }
                    
                });
                $A.enqueueAction(callMethod);
                
            }  
            
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title:$A.get("$Label.c.Error"),
                mode:"dismissible",
                message:$A.get("$Label.c.Failed_to_Generate_Otp"),
                type:"error"
            });
            toastEvent.fire();
            helper.hideSpinner(component);
            
        }
    },
    verifyOTP : function(component,event,helper){
        helper.getFlowsWithOtp(component,event,helper);
        
    },
    verifyOTPForLogin: function(component,event,helper){
        helper.showSpinner(component);
        var patientId=component.get("v.PatientId");
        var confirming = (component.get("v.portalOtpInput") || '').trim();
        if(!confirming && component.find('confirmotp')){
            confirming = component.find('confirmotp').get("v.value");
        }
        if(!confirming){
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
            helper.hideSpinner(component);
            
        }
        else{
            var code=component.get("v.otpCode");
            if(code!=undefined && code!==null){
                if(confirming == code){
                    component.set('v.isShowLogin',false);
                    component.set('v.showrecords',false);
                    component.set('v.MyAppointments',true);
                    component.set('v.portalAuthenticated', true);
                    component.set('v.guestUserForLoginOrSignUp', false);
                    component.set('v.isNextModalForSignUp', false);
                    component.set('v.isNextModalsForLogin', true);
                    component.set('v.portalOtpInput', '');
                    if(!component.get('v.portalPatientLabel')){
                        component.set('v.portalPatientLabel', component.get("v.portalEntryIdentifier"));
                    }
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({        
                        title:$A.get("$Label.c.Success"),      
                        message:$A.get("$Label.c.OTP_verification_is_completed"),
                        type:"success",
                        mode:"pester"      
                    });
                    toastEvent.fire();
                    helper.hideSpinner(component);
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
                    helper.hideSpinner(component);
                }
                
            }
            else{
                helper.hideSpinner(component);
            }
        }
    },
    hideModalBox : function(component,event,helper){
        var getDocid = component.get("v.doctorsIds");
        if(getDocid != null){
        component.set("v.isShowModal",false);
        component.set('v.showrecords',true);
        }
        else{
            component.set('v.showBookAppointment',true);
            component.set("v.hideNumberButton",false);
            component.set("v.hideOtpButton",false);
            component.set("v.isNextModal",false);
            component.set("v.isNextModals",false);
            component.set("v.isShowModal",false);    
        }
    },
    hideModalBoxForLogin: function(component,event,helper){
        component.set("v.isShowLogin",false);
        component.set("v.isNextModalsForLogin",false);
        component.set("v.isNextModalForSignUp",false);
        component.set("v.showverifybotton",false);
        component.set("v.showBookAppointment",true);
        component.set('v.LoginButton',true);
        
    },
    hideOtpModelLogin: function(component,event,helper){
        component.set("v.isShowLogin",false);
        component.set("v.isNextModalsForLogin",true);
        component.set("v.isNextModalForSignUp",false);
        component.set("v.showverifybotton",false);
        component.set("v.hideOtpButtonLogin",false);
        component.set("v.showconfirmbotton",true);
        component.set("v.showBookAppointment",true);
        component.set("v.hideNumberButtonLogin",true);
        component.set('v.LoginButton',true);
        component.set("v.portalOtpInput", "");
        
    },
    hideModalBoxForFlow: function(component,event,helper){
        component.set("v.iframepopup",false);
        component.set('v.showrecords',true);
    },
    hideModalBoxForFlows: function(component,event,helper){
        component.set("v.FlowPopup",false);
        component.set("v.showrecords",true);
    },
    // hideModalBoxForBack: function(component,event,helper){
    //     component.set("v.iframepopup",false);
    //     component.set('v.showrecords',true);
    // },
    hideModalBoxForservey: function(component,event,helper){
    
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
                                if(!result || !result.practitionerfacility || !result.workTypeName || !result.workTypeGroupName){
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        title :$A.get("$Label.c.Info"),
                                        message:'No appointment schedule is configured yet for this doctor at the selected location.',
                                        duration:' 5000',
                                        key: 'info_alt',
                                        type: 'info',
                                        mode: 'dismissible'
                                    });
                                    toastEvent.fire();
                                    return;
                                }
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
                                    if(!result || !result.practitionerfacility || !result.workTypeName || !result.workTypeGroupName){
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            title :$A.get("$Label.c.Info"),
                                            message:'No appointment schedule is configured yet for this doctor at the selected location.',
                                            duration:' 5000',
                                            key: 'info_alt',
                                            type: 'info',
                                            mode: 'dismissible'
                                        });
                                        toastEvent.fire();
                                        return;
                                    }
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
                
        
        
    },
    
    PreviousActiontoFlow: function(component,event,helper){
         var splitInvatationId= component.get("v.setsplitInvatationId");
        //alert("splitInvatationId"+splitInvatationId);
        var surveyaction = component.get("c.deleteSurveyResponce");
       // alert(surveyaction);
        surveyaction.setParams({
            'invtId':splitInvatationId
        });
        surveyaction.setCallback(this, function(response){
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                var getResponce = response.getReturnValue();
               // alert(JSON.stringify(getResponce));
                component.set("v.iframeUrl",null);
               // alert(component.get("v,iframeUrl"));
                 component.set("v.showrecords",true);
        component.set("v.showZoompopup",false);
        component.set("v.RadioSelector",[]);
            }
        });
        $A.enqueueAction(surveyaction);
       
    },
    
    hideExampleModalForFlow: function(component,event,helper){
        component.set("v.iframepopup",false);
        component.set('v.showrecords',true);
    },
    hideExampleModalForZoom:function(component,event,helper){
        var splitInvatationId= component.get("v.setsplitInvatationId");
       // alert("splitInvatationId"+splitInvatationId);
        var surveyaction = component.get("c.deleteSurveyResponce");
       // alert(surveyaction);
        surveyaction.setParams({
            'invtId':splitInvatationId
        });
        surveyaction.setCallback(this, function(response){
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                var getResponce = response.getReturnValue();
               // alert(JSON.stringify(getResponce));
                component.set("v.iframeUrl",null);
               // alert(component.get("v,iframeUrl"));
            }
        });
        $A.enqueueAction(surveyaction);
        component.set('v.showrecords',true);
        component.set("v.showZoompopup",false);
    },
    hideExampleModalForFlows: function(component,event,helper){
        var splitInvatationId= component.get("v.setsplitInvatationId");
       // alert(splitInvatationId);
        var surveyaction = component.get("c.deleteSurveyResponce");
        surveyaction.setParams({
            'invtId':splitInvatationId
        });
        surveyaction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var getResponce = response.getReturnValue();
            }
        });
        $A.enqueueAction(surveyaction);
        
        component.set("v.getSurveyresponceId",null);
        component.set("v.FlowPopup",false);
        component.set('v.showrecords',true);
        // component.set("v.showZoompopup",true);
        component.set("v.RadioSelector",[]);
    },
    hideExampleModal : function(component,event,helper){
        var getDocid = component.get("v.doctorsIds");
        if(getDocid !=null){
        component.set("v.PatientId",null);
        component.set("v.isShowModal",false);
        component.set('v.showrecords',true);
        }
        else{
            component.set('v.showBookAppointment',true);
            component.set("v.hideNumberButton",false);
            component.set("v.hideOtpButton",false);
            component.set("v.isNextModal",false);
            component.set("v.isNextModals",false);
            component.set("v.isShowModal",false);    
        }
    },
    hideExampleModalForLogin:function(component,event,helper){
        
        component.set("v.isShowLogin",false);
        component.set("v.isNextModalsForLogin",false);
        component.set("v.isNextModalForSignUp",false);
        component.set("v.showverifybotton",false);
        component.set('v.LoginButton',true);
    },
    
    handleCreateContact: function(component, event,helper) {
        var getLeadValue=component.get("v.newLead");
        if (!/^[a-zA-Z ]*$/g.test(getLeadValue.FirstName)) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title :$A.get("$Label.c.Error"),
                message:$A.get("$Label.c.FirstName_Must_Contain_Only_Letters"),
                duration:' 3000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
        }
        else if(!/^[a-zA-Z ]*$/g.test(getLeadValue.LastName)) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title :$A.get("$Label.c.Error"),
                message:$A.get("$Label.c.LastName_Must_Contain_Only_Letters"),
                duration:' 3000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
        }
            else if(!/^[a-zA-Z ]*$/g.test(getLeadValue.City)) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title :$A.get("$Label.c.Error"),
                    message:$A.get("$Label.c.City_Must_Contain_Only_Letters"),
                    duration:' 3000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
                else if(!/^[a-zA-Z ]*$/g.test(getLeadValue.Country)) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title :$A.get("$Label.c.Error"),
                        message:$A.get("$Label.c.Country_Must_Contain_Only_Letters"),
                        duration:' 3000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }
                    else if(!/^[a-zA-Z ]*$/g.test(getLeadValue.State)) {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title :$A.get("$Label.c.Error"),
                            message:$A.get("$Label.c.State_Must_Contain_Only_Letters"),
                            duration:' 3000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                    }
                        else if(!/^[0-9]*$/g.test(getLeadValue.PostalCode)) {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title :$A.get("$Label.c.Error"),
                                message:$A.get("$Label.c.PostalCode_Must_Contain_Only_Numbers"),
                                duration:' 3000',
                                key: 'info_alt',
                                type: 'error',
                                mode: 'pester'
                            });
                            toastEvent.fire();
                        }
                            else{
                                var leadInputs = component.find('Lead');
                                if (!Array.isArray(leadInputs)) {
                                    leadInputs = leadInputs ? [leadInputs] : [];
                                }
                                var allValid = true;
                                leadInputs.forEach(function(inputCmp) {
                                    if (inputCmp && typeof inputCmp.reportValidity === 'function') {
                                        inputCmp.reportValidity();
                                    }
                                    if (inputCmp && typeof inputCmp.checkValidity === 'function') {
                                        allValid = allValid && inputCmp.checkValidity();
                                    }
                                });
                                if(allValid){
                                    var saveContactAction = component.get("c.createLead");
                                    saveContactAction.setParams({
                                        "lead": component.get("v.newLead")
                                    });
                                    saveContactAction.setCallback(this, function(response) {
                                        var state = response.getState();
                                        if(state === "SUCCESS") {
                                            var getUserType = response.getReturnValue();
                                        
                                             if(getUserType =='emailexits'){
                                                var toastEvent = $A.get("e.force:showToast");
                                                toastEvent.setParams({
                                                    title:$A.get("$Label.c.Error"),
                                                    mode:"dismissible",
                                                    message:$A.get("$Label.c.Account_Is_Already_Exists_With_This_Email_Address"),
                                                    type:"error"
                                                });
                                                toastEvent.fire();
                                                
                                            }
                                            else if(getUserType =='phoneexixts'){
                                                var toastEvent = $A.get("e.force:showToast");
                                                toastEvent.setParams({
                                                    title:$A.get("$Label.c.Error"),
                                                    mode:"dismissible",
                                                    message:$A.get("$Label.c.Account_Is_Already_Exists_With_This_Phone_Number"),
                                                    type:"error"
                                                });
                                                toastEvent.fire();
                                                
                                            }
                                            else  if(getUserType !=null){
                                                var methodCall=component.get("c.convertLeadToPersonAccount");
                                                methodCall.setParams({
                                                    "leadId":getUserType
                                                });
                                                methodCall.setCallback(this, function(responses) {
                                                    var getConvert = responses.getState();
                                                    if(getConvert === "SUCCESS") {
                                                        var convertToAccount = responses.getReturnValue();
                                                        component.set('v.getLeadId',convertToAccount);         
                                                      
                                                        if(convertToAccount != null){
                                                          
                                                       // component.set("v.PatientId",getUserType);
                                                        var careId =component.get("v.careSpcId"); 
                                                      //  var careId = component.get("v.CareList");
                                                        var patientId=component.get("v.getLeadId");
                                                        if(careId != null){
                                                        console.log('careId>>'+JSON.stringify(careId[0].Specialty.Id));
                                                        var win;
                                                        var action = component.get("c.createInvite");
                                                        action.setParams({
                                                            careId : careId,
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
                                                                
                                                            }
                                                            
                                                        });
                                                        $A.enqueueAction(action);
                                                        component.set("v.guestUser",false);
                                                        //component.set("v.showBookAppointment",true);
                                                        var toastEvent = $A.get("e.force:showToast");
                                                        toastEvent.setParams({
                                                            title:$A.get("$Label.c.Success"),
                                                            message:$A.get("$Label.c.Your_Account_has_been_Created_Successfully"),
                                                            type:"success",
                                                            mode:"pester"
                                                        });
                                                        toastEvent.fire();
                                                    }
                                                    else {
                                                        component.set('v.isShowModal',false);
                                                        component.set("v.guestUser",false);
                                                        component.set("v.showBookAppointment",true);
                                                        component.set('v.MyAppointments',true);
                                                        var toastEvent = $A.get("e.force:showToast");
                                                        toastEvent.setParams({
                                                            title:$A.get("$Label.c.Success"),
                                                            message:$A.get("$Label.c.Your_Account_has_been_Created_Successfully"),
                                                            type:"success",
                                                            mode:"pester"
                                                        });
                                                        toastEvent.fire();
                                                    }
                                                    }       

                                                        
                                                
                                                        
                                                        
                                                    }
                                                });
                                                $A.enqueueAction(methodCall);
                                            }
                                        //    else if(getUserType=='emailexits'){
                                                
                                        //         var toastEvent = $A.get("e.force:showToast");
                                        //         toastEvent.setParams({
                                        //             title:$A.get("$Label.c.Error"),
                                        //             mode:"dismissible",
                                        //             message:$A.get("$Label.c.Account_Is_Already_Exists_With_This_Email_Address"),
                                        //             type:"error"
                                        //         });
                                        //         toastEvent.fire();
                                                
                                        //     }
                                        //     else if(getUserType=='phoneexixts'){
                                        //         var toastEvent = $A.get("e.force:showToast");
                                        //         toastEvent.setParams({
                                        //             title:$A.get("$Label.c.Error"),
                                        //             mode:"dismissible",
                                        //             message:$A.get("$Label.c.Account_Is_Already_Exists_With_This_Phone_Number"),
                                        //             type:"error"
                                        //         });
                                        //         toastEvent.fire();
                                                
                                        //     }
                                                // else{
                                                //     component.set("v.PatientId",getUserType);
                                                //     var careId = component.get("v.CareList");
                                                //     var patientId=component.get("v.PatientId");
                                                //     console.log('careId>>'+JSON.stringify(careId[0].Specialty.Id));
                                                //     var win;
                                                //     var action = component.get("c.createInvite");
                                                //     action.setParams({
                                                //         careId : careId[0].Specialty.Id,
                                                //         patientId : patientId
                                                //     });
                                                //     action.setCallback(this, function(response){
                                                //         var state = response.getState();
                                                //         if (state === "SUCCESS") {
                                                //             var url=response.getReturnValue();
                                                //             component.set("v.iframeUrl",url.invitationFetch.InvitationLink);
                                                //             component.set("v.ServeySubjectId",url.subjectFetch.Id);
                                                //             component.set('v.iframepopup',true);
                                                //             component.set('v.isShowModal',false);
                                                //             component.set('v.showrecords',false);
                                                            
                                                //         }
                                                        
                                                //     });
                                                //     $A.enqueueAction(action);
                                                //     component.set("v.guestUser",false);
                                                //     //component.set("v.showBookAppointment",true);
                                                //     var toastEvent = $A.get("e.force:showToast");
                                                //     toastEvent.setParams({
                                                //         title:$A.get("$Label.c.Success"),
                                                //         message:$A.get("$Label.c.Your_Account_has_been_Created_Successfully"),
                                                //         type:"success",
                                                //         mode:"pester"
                                                //     });
                                                //     toastEvent.fire();
                                                // }
                                        }
                                        
                                    });
                                    
                                    // Send the request to create the new contact
                                    $A.enqueueAction(saveContactAction);
                                    
                                }
                                
                                else {
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        title :$A.get("$Label.c.Error"),
                                        message:$A.get("$Label.c.Please_Fill_All_Reaquired_Filelds"),
                                        duration:' 3000',
                                        key: 'info_alt',
                                        type: 'error',
                                        mode: 'pester'
                                    });
                                    toastEvent.fire();
                                }
                            }
    },
    
    showSpinner: function(component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },    
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    handleOnSelect:function(component, event, helper) {
        var selectedSpecialtyId = event.getParam ? event.getParam("name") : null;
        var isPortalSearchFlow =
            component.get("v.selectedCareSpecialtyLookUpRecord") != null ||
            component.get("v.selectedContactLookUpRecord") != null ||
            !!component.get("v.selectedLocationId");

        if (selectedSpecialtyId && component.get("v.showrecords") && isPortalSearchFlow) {
            component.set("v.careIds", selectedSpecialtyId);
            component.set("v.viewdoctordetails", false);
            helper.loadPortalLocations(component, selectedSpecialtyId);
            helper.refreshPortalDoctorResults(component, event, helper);
            return;
        }

        var getcareId =component.get('v.selectedCareSpecialtyLookUpRecord');
        var getcontactId =component.get('v.selectedContactLookUpRecord');
        var getAccountId =component.get('v.selectedAccountLookUpRecord');
        
        if(getcareId ==null && getcontactId == null && getAccountId != null){
            helper.getDoctorsByDoctors(component, event, helper,"Hospital");
        }
        else if(getcareId ==null && getcontactId != null && getAccountId != null){
            var getSelectedDocIds =component.get("v.selectedContactLookUpRecord");
            component.set("v.getDocId",getSelectedDocIds.Id);
            
            helper.getDoctors(component, event, helper,"handleAllSearch");
        }
            else if(getcareId !=null && getcontactId == null && getAccountId != null){
                helper.getDoctors(component, event, helper,"Acc");
            }
                else{
                    event.getSource().set("v.handleOnSelect", false);
                }
        
    },
    
    handleOnSubSelect:function(component, event, helper) {
        component.set('v.selectedaccId',"");
        
        helper.getsubspecialityDoctors(component);
        
    },
    
    BookAppointment:function(component, event, helper) {
        if (!component.get("v.portalAuthenticated")) {
            component.set("v.isShowLogin",true);
            component.set("v.isNextModalsForLogin",true);
            component.set("v.isNextModalForSignUp",false);
            component.set("v.showconfirmbotton",true);
            component.set("v.showverifybotton",false);
            component.set("v.hideNumberButtonLogin",true);
            component.set("v.hideOtpButtonLogin",false);
            component.set("v.guestUserForLoginOrSignUp",false);
            var authToast = $A.get("e.force:showToast");
            authToast.setParams({
                title :$A.get("$Label.c.Info"),
                message:'Please sign in with OTP verification before booking an Apollo appointment.',
                duration:' 5000',
                key: 'info_alt',
                type: 'info',
                mode: 'dismissible'
            });
            authToast.fire();
            return;
        }

       
        var getleadId= component.get("v.getLeadId");
        var patientIds = component.get("v.PatientId");
        var patientId = component.get("v.PatientId") || component.get("v.setUserId");
      // alert(loggedUserId);
       // alert(patientId);
        
        
     
        var getResponceid=component.get("v.getSurveyresponceId");
        var rawValue = event.getSource().get("v.value");
        var valueParts = rawValue ? rawValue.split('|') : [];
        var selectedAccountId = valueParts.length > 1 ? valueParts[0] : component.get("v.AccId");
        let contactId   =  valueParts.length > 1 ? valueParts[1] : rawValue;
        component.set("v.AccId", selectedAccountId);
        component.set("v.contactId",contactId);
        var SpecialityId;
        var AppointmentType;
        var docList = component.get("v.selectedaccId");
        for(var i=0;i<docList.length;i++){
            if(docList[i].PractitionerId === contactId){
                SpecialityId=docList[i].SpecialtyId;
                AppointmentType=docList[i].Practitioner.Available_Appointment_Type__c;
            }
            
        }
        component.set("v.careSpcId",SpecialityId);
        component.set("v.AppointmentType",AppointmentType);
        var subId= component.get("v.iframeUrl");
      //  alert("subId :"+subId);
       
           /* if(patientId == null && getleadId ==null){
                component.set("v.hideNumberButton",true);
                component.set("v.hideOtpButton",false);
                component.set('v.isShowModal',true);
                component.set('v.isNextModals',true);
                component.set("v.isconfirm",true);
                component.set("v.isverify",false);
                component.set('v.isNextModal',false);
                let contactId   =  event.getSource().get("v.value");
                component.set("v.contactId",contactId);
            }*/
            
             if(patientIds != null){
             // alert('loggedUserId');
                component.set("v.contactId",contactId);
                component.set("v.isShowModal",false);
                var careId =component.get("v.careSpcId"); 
               // alert("careId"+careId);
                var patientId=component.get("v.PatientId") || component.get("v.setUserId");
               //  alert('patientId'+patientId);
                 helper.getMyValue(component,helper,event);
                var win;
               // alert('inside');
                var action = component.get("c.insertDummyAttachment");
                action.setParams({
                    PatientId : patientId
                });
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if (state === "SUCCESS") {                        
                        var url=response.getReturnValue();
                       // alert('url>>'+url);
                        component.set('v.attachmentId', url);
                        
                       // component.set('v.iframepopup',true);
                        component.set('v.isShowModal',false);
                        component.set('v.showrecords',false);
                       // component.set('v.FlowPopup',true);
                        
                        //win = window.open(url.invitationFetch.InvitationLink,'targetWindow',' width=600px,height=600px ');
                    }
                     helper.sendattchid(component, event, helper, url);
                });
                $A.enqueueAction(action);
         
                
            }
           
            
               /* else if(getleadId ==null && patientId !=null){
                    component.set("v.PatientId",getleadId);
                    var careId = component.get("v.careSpcId");
                    var patientId=component.get("v.PatientId");
                    var action = component.get("c.createInvite");
                    action.setParams({
                        'careId' : careId,
                        'patientId' : patientId
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
                        }
                        
                    });
                    $A.enqueueAction(action);
                    //  component.set("v.guestUser",false);
                }
        }
      else if(getleadId != null && patientId == null){
        component.set("v.isShowModal",false);
        var careId = component.get("v.careSpcId");
        var patientId=component.get("v.PatientId");
        var win;
        var action = component.get("c.createInvite");
        action.setParams({
            careId : careId,
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
                
            }
            
        }); 
        $A.enqueueAction(action);
      }*/
    
        else {
              var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:'Your Account Is Not Found To Book A Appointment',
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
           /* alert('inside else');
            component.set("v.isShowModal",false);
            var careId = component.get("v.careSpcId");
            var patientId=component.get("v.PatientId");
            var action = component.get("c.createInvite");
            action.setParams({
                careId : careId,
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
                    
                }
                
            }); 
            $A.enqueueAction(action);*/
            // component.set('v.iframepopup',true);
            // component.set('v.isShowModal',false);
            // component.set('v.showrecords',false);
        }
        
    },
    
    
    onPrev: function(component, event, helper) {        
        let pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber - 1);
        helper.setPageDataAsPerPagination(component);
        component.set("v.showHospitalssforCare",true);
        component.set("v.hideprvsbtn",false);
        
        
        
    },
    onNext: function(component, event, helper) {        
        let pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber + 1);
        helper.setPageDataAsPerPagination(component);
        component.set("v.hideprvsbtn",true);
        component.set("v.showHospitalssforCare",false);
        
        
        
        
    },
    
   /* 
    handleCmpEvent :function(component,event,helper){
        var message = event.getParam("message"); 
        component.set("v.welcomepage",true);
        component.set("v.MyAppointment",false);
        
    },
    */
    onPrevious: function(component, event, helper) {  
        let pageNumber = component.get("v.currentPageNumbers");
        component.set("v.currentPageNumbers", pageNumber - 1);
        helper.setPageHospitalAsPerPagination(component);
        component.set("v.hidepreviousbtn", false);
        component.set("v.homebuttonhide", true);
        
    },
    onNextpage: function(component, event, helper) {        
        let pageNumber = component.get("v.currentPageNumbers");
        component.set("v.currentPageNumbers", pageNumber + 1);
        component.set("v.hidepreviousbtn", true);
        component.set("v.homebuttonhide", false);
        
        
        helper.setPageHospitalAsPerPagination(component);
        
    },
    getLeadFormRecords:function(component, event, helper) {
        var LeadId =event.getParam("LeadId");
        component.set("v.PatientId",LeadId);
        var getMessage =event.getParam("message");
        var calledComponent =event.getParam("calledComponent");
        var ServeySubjectId =event.getParam("ServeySubjectId");
        var iframeUrl =event.getParam('iframeUrl');
        if(calledComponent == 'DoctorPage'){
            helper.hideSpinner(component);
            component.set("v.iframepopup",true);
             component.set("v.showBookAppointment",false);
             component.set("v.iframeUrl",iframeUrl);
             component.set("v.ServeySubjectId",ServeySubjectId);
             component.set("v.showLeadForminChildComponet",false);

        }
        else  if(calledComponent == 'LoginPage'){
            helper.hideSpinner(component);
            component.set("v.showBookAppointment",true);
            component.set('v.MyAppointments',true);
            component.set("v.showLeadForminChildComponet",false);


        }
        else  if(getMessage == 'DoctorsRecordPage'){
            helper.hideSpinner(component);
            component.set("v.isNextModals",true);
            component.set('v.isShowModal',true);
            component.set("v.showrecords",true);
            component.set("v.showBookAppointment",false);
            component.set("v.showLeadForminChildComponet",false);
            


        }
        else  if(getMessage == 'otppage'){
            helper.hideSpinner(component);
            component.set("v.isNextModals",true);
            component.set('v.isShowModal',true);
            component.set("v.showrecords",false);
            component.set("v.showBookAppointment",true);
            component.set("v.showLeadForminChildComponet",false);
            


        }
        

        
    },
    
    handleComponentEventPass:function(component, event, helper) {
       
        var objectAPIName = event.getParam("objectAPIName");
        var selectedAccountGetFromEvent = event.getParam("selelectedrecordByEvent");
        var doNull = component.set("v.doNull",selectedAccountGetFromEvent);
        if(selectedAccountGetFromEvent != null){
            if(objectAPIName == 'CareSpecialty'){
                var getcareId =component.get('v.selectedCareSpecialtyLookUpRecord');
                component.set('v.careIds',getcareId.Id);
                component.set('v.selectedLocationId','');
                component.set('v.AccId',null);
                component.set('v.getDocId',null);
                helper.loadPortalLocations(component, getcareId.Id);
                
            }
            else if(objectAPIName =='contact'){
                var getcontactId =component.get('v.selectedContactLookUpRecord');
                component.set('v.doctorsIds',getcontactId.Id);
                component.set('v.getDocId',getcontactId.Id);
                component.set('v.selectedaccId',getcontactId.Id); 
            }
                else if(objectAPIName == 'Account'){
                }
            
            component.set('v.selectedRecIds',selectedAccountGetFromEvent.Id);
        }
        else {
            
            
            
            var selectednullrecord = event.getParam("selectednullrecord");
            $A.get('e.force:refreshView').fire();
            component.set("v.doNull",null);
            
            
            
            
        }
      
       
    
        
        
    },
    getDataForAppointment:function(component, event, helper){
        var getcareId =component.get('v.selectedCareSpecialtyLookUpRecord');
        var getcontactId =component.get('v.selectedContactLookUpRecord');
        var selectedLocationId =component.get('v.selectedLocationId');
        
        component.set("v.careIds", getcareId ? getcareId.Id : null);
        component.set("v.getDocId", getcontactId ? getcontactId.Id : null);
        component.set("v.AccId", null);

        if(getcareId == null && getcontactId == null && !selectedLocationId){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title :$A.get("$Label.c.Info"),
                message:'Please choose a care specialty, doctor, or location to continue.',
                duration:'5000',
                key: 'info_alt',
                type: 'info',
                mode: 'pester'
            });
            toastEvent.fire();
            return;
        }

        helper.getPortalDoctors(component, event, helper, getcontactId != null);
        
    },
    handleLocationChange : function(component, event, helper) {
        component.set("v.selectedLocationId", event.getSource().get("v.value"));
        component.set("v.AccId", null);
        helper.refreshPortalDoctorResults(component, event, helper);
    },
    
    onDetail :function(component, event, helper) {
        var btnValue = event.getSource().get("v.value");
        var valueParts = btnValue ? btnValue.split('|') : [];
        var accountId = valueParts.length > 1 ? valueParts[0] : null;
        var doctorId = valueParts.length > 1 ? valueParts[1] : btnValue;
        if(accountId){
            component.set("v.AccId", accountId);
        }
        var showHideVar = component.get("v.viewdoctordetails");
        if(showHideVar == false) {
            component.set("v.viewdoctordetails", true);
            component.set("v.indexVar",doctorId);
        }
        else {
            component.set("v.viewdoctordetails", false);
        }
        
        
        
    },
    getDoctrsByHospitals :function(component,event,helper){
        component.set("v.AccId", event.getSource().get("v.value"));
        helper.getPortalDoctors(component,event,helper,component.get("v.getDocId") != null);
        
    },
    
    getDoctrsByCareIdAndHospitals : function(component,event,helper) {
        component.set("v.AccId", event.getSource().get("v.value"));
        helper.getPortalDoctors(component, event, helper, component.get("v.getDocId") != null);
    },
    home:  function(component,event,helper) {  
        component.set("v.showBookAppointment",true);

        component.set("v.showrecords",false);
        component.set("v.portalResultsTitle",'Available Doctors');
        component.set('v.selectedContactLookUpRecord',null);
        component.set('v.selectedAccountLookUpRecord',null);
        component.set('v.selectedCareSpecialtyLookUpRecord',null);
        component.set('v.selectedLocationId','');
        $A.get('e.force:refreshView').fire();
        
    },
    BackToWelcomePage:function(component, event, helper) {
        component.set('v.showPeronAccountAppointment',false);
        component.set('v.MyAppointments',true);
        component.set('v.showBookAppointment',true);
        component.set('v.welcomepage',false);
        component.set('v.showrecords',false);
        component.set("v.portalResultsTitle",'Available Doctors');
        component.set('v.careDoctors',false);
        component.set('v.selectedaccId',[]);
        component.set('v.selectedContactLookUpRecord',null);
        component.set('v.selectedAccountLookUpRecord',null);
        component.set('v.selectedCareSpecialtyLookUpRecord',null);
        component.set('v.selectedLocationId','');
        
        component.set("v.showcount",true);
    },
    BackToHospital:  function(component,event,helper) { 
        component.set("v.welcomepage",true);
        component.set("v.showBookAppointment",false);
        component.set("v.showrecords",false);
        component.set('v.careIds',null);
        component.set("v.viewdoctordetails",false);
    },
    showHospitalssforCare:  function(component,event,helper) { 
        component.set("v.careDoctors",true);
        component.set("v.showHospitalssforCare",true);
        component.set("v.welcomepage",false);
        component.set("v.showBookAppointment",false);
        component.set("v.showrecords",false);
       
        
    },
    handleShowPopover : function(component, event, helper) {
        component.set("v.showPopUp",true);
        var rawValue = event.getSource().get("v.value");
        var valueParts = rawValue ? rawValue.split('|') : [];
        var accId = valueParts.length > 1 ? valueParts[0] : component.get('v.AccId');
        var contactId = valueParts.length > 1 ? valueParts[1] : rawValue;
        component.set("v.AccId", accId);
        var action =component.get("c.getTimeSlots");
        action.setParams({
            'accntId':accId,
            'contctId':contactId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var allValues = response.getReturnValue();
                
                var hours=[];
                for(var i =0;i<allValues.length;i++){
                    var diffMins = Math.round(((allValues[i].StartTime % 86400000) % 3600000) / 60000);
                    var diffMinst = Math.round(((allValues[i].EndTime % 86400000) % 3600000) / 60000);
                    var singleObj = {};
                    singleObj['DayOfWeek'] = allValues[i].DayOfWeek;
                    if(allValues[i].StartTime >=0){
                        allValues[i].StartTime = (Number(allValues[i].StartTime))/3600000
                        var AmOrPm = allValues[i].StartTime >= 12 ? 'pm' : 'am';
                        singleObj['StartTime'] = ((allValues[i].StartTime % 12) || 12);
                        var strngcnvrt=singleObj['StartTime'].toString();
                        var spltmethod=strngcnvrt.split(".")[0];
                        if(diffMins !=0){
                            singleObj['StartTime'] =spltmethod+':'+diffMins+' '+AmOrPm;
                        }
                        else{
                            singleObj['StartTime'] =spltmethod+':'+'00'+' '+AmOrPm;
                        }
                    }
                    if(allValues[i].EndTime >=0){
                        allValues[i].EndTime = (Number(allValues[i].EndTime))/3600000
                        var AmOrPm = allValues[i].EndTime >= 12 ? 'pm' : 'am';
                        singleObj['EndTime'] = ((allValues[i].EndTime % 12) || 12);
                        var strngcnvrt=singleObj['EndTime'].toString();
                        var spltmethod=strngcnvrt.split(".")[0];
                        if(diffMinst !=0){
                            singleObj['EndTime'] =spltmethod+':'+diffMinst+' '+AmOrPm;
                        }
                        else{
                            singleObj['EndTime'] =spltmethod+':'+'00'+' '+AmOrPm;
                        }
                    }
                    hours.push(singleObj);
                }
                component.set('v.mydata', hours);
            }
            else if(state === "ERROR") {
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error Message: " + errors[0].message);
                    }
                }
                else{
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    
    showPopup : function(component, event, helper){
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        
        
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        //$A.util.addClass(cmpBack, 'slds-backdrop--open'); 
        
        var idx = event.target.getAttribute('data-index');
        console.log('idx---->>> ' + idx);
        var rowRecord = component.get("v.mydata")[idx];
        console.log('rowRecord--->>> ' + JSON.stringify(rowRecord));        
        component.set('v.accdata',rowRecord);
    },
    
    hideTimeModal: function(component, event, helper){
        component.set('v.showPopUp',false);
    },
    handlClose : function(component, event, helper){
        component.set('v.showPopUp',false);
    },
    
    
    handleSelected : function(component, event, helper) {  
        
        helper.selectedRecords(component, event, helper);
    },
    
    handlCompleted : function(component, event, helper) {    
        helper.selectedRecords(component, event, helper);
    },
    onPreviousParent: function(component, event, helper) {        
        let pageNumber = component.get("v.PresentPageNumber");
        component.set("v.PresentPageNumber", pageNumber - 1);
        helper.setPageDataAsPerPatientRecord(component);
    },
    onNextParent: function(component, event, helper) {        
        let pageNumber = component.get("v.PresentPageNumber");
        component.set("v.PresentPageNumber", pageNumber + 1);
        helper.setPageDataAsPerPatientRecord(component);
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

    handleAction : function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');

        if (!action || action.name !== 'remind') {
            return;
        }

        if (!row || !row.Id) {
            var missingRowToast = $A.get("e.force:showToast");
            missingRowToast.setParams({
                title: "Error!",
                mode:"dismissible",
                message: "Appointment details are not available for reminder.",
                type:"error"
            });
            missingRowToast.fire();
            return;
        }

        if (row.Status !== 'Scheduled') {
            var infoToast = $A.get("e.force:showToast");
            infoToast.setParams({
                title: "Info",
                mode:"dismissible",
                message: "Reminders can be sent only for scheduled appointments.",
                type:"info"
            });
            infoToast.fire();
            return;
        }

        var remindAction = component.get("c.sendAppointmentReminder");
        remindAction.setParams({
            serviceAppointmentId: row.Id
        });
        remindAction.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var result = response.getReturnValue();
                var reminderMessage = "Reminder sent";
                if (result && result.patientReminderSent && result.doctorReminderSent) {
                    reminderMessage = "Reminder sent to both patient and doctor.";
                } else if (result && result.patientReminderSent) {
                    reminderMessage = "Reminder sent to patient.";
                } else if (result && result.doctorReminderSent) {
                    reminderMessage = "Reminder sent to doctor.";
                }
                var successToast = $A.get("e.force:showToast");
                successToast.setParams({
                    title: "Success!",
                    mode:"pester",
                    message: reminderMessage,
                    type:"success"
                });
                successToast.fire();
            } else {
                var errors = response.getError();
                var errorMessage = 'Could not send appointment reminder.';
                if (errors && errors[0] && errors[0].message) {
                    errorMessage = errors[0].message;
                }
                var errorToast = $A.get("e.force:showToast");
                errorToast.setParams({
                    title: "Error!",
                    mode:"dismissible",
                    message: errorMessage,
                    type:"error"
                });
                errorToast.fire();
            }
        });
        $A.enqueueAction(remindAction);
    },
    
    handleConfirmDialogCancel : function(component, event, helper) {
        component.set('v.showCancelBox', false);
    },
    
    handleRadioClick : function (component, event, helper) {
        var evt=event.target.value;
        component.set("v.RadioSelector",evt);
    },
    
    NextActiontoFlow : function(component, event, helper) {
        var values=component.get("v.RadioSelector");
        var attachmentId = component.get("v.attachmentId");
       // alert('attachmentId>>'+attachmentId);
        if(values == null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title :$A.get("$Label.c.Error"),
                message:$A.get("$Label.c.Please_Select_Appointment_Type"),
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
        }
        else{
            component.set("v.EmailZoom",values);
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
                    if(!result || !result.practitionerfacility || !result.workTypeName || !result.workTypeGroupName){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title :$A.get("$Label.c.Info"),
                            message:'No appointment schedule is configured yet for this doctor at the selected location.',
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'info',
                            mode: 'dismissible'
                        });
                        toastEvent.fire();
                        return;
                    }
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
                    component.set("v.showZoompopup",false);
                    component.set('v.FlowPopup',true);
                      var patientId=component.get("v.PatientId") || component.get("v.setUserId");
                    var patientIds = patientId;
                    var ServeySubjectId=component.get("v.ServeySubjectId");
                    var appTypeName=component.get("v.RadioSelector");
                    const flow = component.find("flowData");
                    var inputVariables = [
                        {
                            name:"varLeadId",
                            type:"String",
                            value:patientIds
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
        
    },
    
    hideOtpModel :function(component,event,helper){
        var getDocid = component.get("v.doctorsIds");
        if(getDocid != null){
        component.set("v.PatientId",null);
        component.set("v.showrecords",true);
        component.set("v.hideOtpModel",false);
        component.set("v.hideNumberButton",false);
        component.set("v.hideOtpButton",false);
        component.set("v.isNextModal",false);
        component.set("v.isNextModals",false);
        component.set("v.isShowModal",false);
        }
        else{
            component.set('v.showBookAppointment',true);
            component.set("v.hideNumberButton",false);
            component.set("v.hideOtpButton",false);
            component.set("v.isNextModal",false);
            component.set("v.isNextModals",false);
            component.set("v.isShowModal",false);    
        }
        
    } ,
    
    
    
    handleClick : function(component, event, helper) {
        var PatientId =component.get("v.PatientId");
        
        var menuValue = event.detail.menuItem.get("v.value");
        var label = '23';
        
        if(menuValue =='Login/SignUp'  )
        {
            
            component.set('v.isShowModal',true);
            component.set('v.isconfirm',true);
            component.set('v.hideNumberButton',true);
            component.set('v.isNextModal',false);
            component.set('v.isNextModals',true);
            component.set("v.isverify",false);
            component.set("v.hideOtpButton",false);
        }    
        
        if(menuValue =='ChangeLanguage')
        {
            component.set('v.showLanguageSection', true);
        }
        if(menuValue =='MyProfile'  ){
            
            helper.onloadPatientapptdata(component, event, helper);
        }

        if(menuValue =='Einsteinsearch'  ){
            // var evt = $A.get("e.force:navigateToComponent");
    //evt.setParams({
      //  componentDef : "c:EinsteinSearhChildcmp",
    //});
    //evt.fire();
    
        
          component.set("v.callEinsteenChild",true);
           component.set("v.showBookAppointment",false);
        }
                  
    },
 
     // component.set("v.callEinsteenChild",true);
          // component.set("v.showBookAppointment",false);
                                           
            
    
    changeLanguage: function(component, event, helper) {
        var selectedLang = component.find('Language').get('v.value');
        component.set("v.selectedLanguage",selectedLang);
    },
    
    
    CloseLanguageData : function(component, event, helper) 
    {
        component.set('v.showLanguageSection', false); 
    },
    
    //
    UpdateLanguageData : function(component, event, helper){
        
        var selectedLang = component.get('v.selectedLanguage');
        var lang;
        if(selectedLang == 'English'){
            lang='en_US';
        }
        else{
            lang='zh_CN';
        }
        var action = component.get("c.changeLanguageData");
        
        action.setParams({
            lang: lang
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var changedOK = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title :$A.get("$Label.c.Success"),
                    message:$A.get("$Label.c.Successfully_Updated"),
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": 'https://tech-kasetti-healthcloud.my.site.com/ltng/s/?language='+lang
                });
                urlEvent.fire();
                
                component.set('v.showLanguageSection', false);
                component.set("v.selectedLanguage",[]);
                location.reload()               
            }
            
        });
        $A.enqueueAction(action);
        
    },
    
    toggleSection : function(component, event, helper) {
       // alert("hiii");
       
    
    
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var PatientId = component.get("v.PatientId") || component.get("v.setUserId");
       
        if(sectionAuraId=='lunchSection'){
             
            component.set('v.healthcondition', [
                {label: "Category",fieldName: "Category",type:'text',hideDefaultActions:true},
                { label: 'Status', fieldName: 'Status',type:'text',hideDefaultActions: true},
                { label: 'Reaction', fieldName: 'Severity',type:'text',hideDefaultActions: true},
                
            ]);
                
                var cloud=component.get("c.fetchallergy");
                cloud.setParams({
                patientId: PatientId
                });
                cloud.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                var changedOK = response.getReturnValue();
                if(changedOK.length>0){
                for(var i=0;i<changedOK.length;i++){
                var row=changedOK[i];
                          row.Category=row.Category;
                          row.Status=row.Status;
                          row.Severity=row.Severity;
                          }
                          component.set("v.allergy",changedOK);
            component.set("v.allergiesdropdown",true);
           // var getspinner=component.get("v.showspinnerontoggeletouch");
          //  alert(getspinner);
           // if(getspinner == false){
            component.set("v.showspinnerontoggeletouch", true); 
            setTimeout(function(){
               component.set("v.showspinnerontoggeletouch", false); 
            }, 1000);
        // }else{
        //     component.set("v.showspinnerontoggeletouch", false); 
        // }
            
        }
        else if(changedOK.length==0){
            component.set("v.allergiesdropdown",false);
        }
    }
    
});
$A.enqueueAction(cloud);

}
else if(sectionAuraId=='DinnerSection'){
    component.set('v.treatment', [
        {label: "Condition",fieldName: "Name",type:'text',hideDefaultActions:true
        },
        { label: 'Severity', fieldName: 'Severity',type:'text',hideDefaultActions: true},
        { label: 'Status', fieldName: 'ConditionStatus',type:'text',hideDefaultActions: true},
        
    ]);
        var cloud=component.get("c.healthcondition");
        cloud.setParams({
        patientId: PatientId
        });
        cloud.setCallback(this, function(response){
        var state = response.getState();
        if (state === "SUCCESS") {
        var changedOK = response.getReturnValue();
        if(changedOK.length>0){
        for(var i=0;i<changedOK.length;i++){
        var row=changedOK[i];
        //alert(' row'+JSON.stringify(row.ConditionCode)+'index>>'+i);

                  var cl=row.ConditionCode;
            //console.log(cl.length + ' '+ JSON.stringify(cl.Name));
                 row.Name=cl.Name;

                      // alert(' row'+JSON.stringify(row.ConditionCode.Name)+'index>>'+i);

                  }
                         // alert(' outsidefor');

                  //console.log('change'+ JSON.stringify(changedOK));
                 component.set("v.treatments",changedOK);
    component.set("v.healthconditiondropdown",true);
    component.set("v.showspinnerontoggeletouch", true); 
    setTimeout(function(){
       component.set("v.showspinnerontoggeletouch", false); 
    }, 1000);
}
    else if(changedOK.length==0){
        component.set("v.healthconditiondropdown",false);
    }
}

});
$A.enqueueAction(cloud);
}
else if(sectionAuraId=='medicationSection'){
    component.set('v.medication', [
        {label: "Name",fieldName: "Name",type:'text',hideDefaultActions:true
         
        },
        {label: "Status",fieldName: "Status",type:'text',hideDefaultActions:true
        },
        
    ]);
        var medicat=component.get("c.medicationmethod");
        
        
        medicat.setParams({
        patientId: PatientId
        });
        medicat.setCallback(this, function(response){
        var state = response.getState();
     
        if (state === "SUCCESS") {
        var changedOK = response.getReturnValue();
console.log('changedOK' +response.getReturnValue());      
  if(changedOK.length>0){
    console.log('insideif' +JSON.stringify(changedOK));      

        for(var i=0;i<changedOK.length;i++){   
            var row=changedOK[i];
           
            var jrows=row.Medication;
           // console.log(jrows.length + ' '+ JSON.stringify(jrows.Name));
            row.Name=jrows.Name;
            row.Status=row.Status;
            // console.log('row>>'+ JSON.stringify(row) +'index>>'+i);
            

                  
                  }
                //   console.log('changedok>>'+JSON.stringify(changedOK));
                 component.set("v.medications",changedOK);
    component.set("v.medicationdropdown",true);
    
}
    else if(changedOK.length==0){
        component.set("v.medicationdropdown",false);
        
    }

}

});
$A.enqueueAction(medicat);
}
else if(sectionAuraId=='latestencountersSection'){
    component.set('v.latestencounterss', [
        {label: "Date",fieldName: "StartDate",type:'text',hideDefaultActions:true
        },
        { label: 'Category', fieldName: 'Category',type:'text',hideDefaultActions: true},
        { label: 'Type', fieldName: 'TypeId',type:'text',hideDefaultActions: true},
        
    ]);
        var latestencount=component.get("c.latestencounter");
        
        latestencount.setParams({
        patientId: PatientId
        });
        latestencount.setCallback(this, function(response){
        var state = response.getState();
        
        if (state === "SUCCESS") {
        var changedOK = response.getReturnValue();
        if(changedOK.length>0){
        for(var i=0;i<changedOK.length;i++){
        var row=changedOK[i];
                  row.StartDate=$A.localizationService.formatDate(row.StartDate,"MM/dd/yyyy, hh:mm a");
    row.Category =row.Category;
    row.TypeId=row.Type.Name;
    
}
component.set("v.latestencounterssdata",changedOK);
component.set("v.latestencounterdropdown",true);

}
else if(changedOK.length==0){
    component.set("v.latestencounterdropdown",false);
    
}

}

});
$A.enqueueAction(latestencount);
}
else if(sectionAuraId=='Immunization'){
    component.set('v.immunization', [
        {label: "Immunization",fieldName: "VaccineCodeId",type:'text',hideDefaultActions:true
        },
        {label: "Date",fieldName: "VaccinationDate",type:'text',hideDefaultActions:true},
        
        { label: 'Status', fieldName: 'Status',type:'text',hideDefaultActions: true},
        
    ]);
        var medicat=component.get("c.immunizationmethod");
        
        medicat.setParams({
        patientId: PatientId
        });
        medicat.setCallback(this, function(response){
        var state = response.getState();
        if (state === "SUCCESS") {
        var changedOK = response.getReturnValue();
        if(changedOK.length>0){
        
        for(var i=0;i<changedOK.length;i++){
        var row=changedOK[i];
                  row.VaccineCodeId=row.VaccineCode.Name;
                  row.VaccinationDate=$A.localizationService.formatDate(row.VaccinationDate,"MM/dd/yyyy, hh:mm a");
    row.Status =row.Status 	;
    
}
component.set("v.immunizations",changedOK);
component.set("v.immunizationdropdown",true);

}
else if(changedOK.length==0){
    component.set("v.immunizationdropdown",false);
    
    
}
}

});
$A.enqueueAction(medicat);
}
else if(sectionAuraId=='medicalproceduresection'){
    component.set('v.medicalprocedure', [
        {label: "Procedure",fieldName: "CodeId",type:'text',hideDefaultActions:true
        },
        
        { label: 'Status', fieldName: 'Status',type:'text',hideDefaultActions: true},
        
    ]);
        var medicat=component.get("c.medicalproceduremethod");
        
        medicat.setParams({
        patientId: PatientId
        });
        medicat.setCallback(this, function(response){
        var state = response.getState();
        
        if (state === "SUCCESS") {
        var changedOK = response.getReturnValue();
        if(changedOK.length>0){
        for(var i=0;i<changedOK.length;i++){
        var row=changedOK[i];
                  row.CodeId=row.Code.Name;
                  row.Status =row.Status 	;
                  
                  }
                  component.set("v.medicalprocedures",changedOK);
    component.set("v.medicalproceduredropdown",true);
    
}
    else if(changedOK.length==0){
        component.set("v.medicalproceduredropdown",false);
        
    }
}

});
$A.enqueueAction(medicat);
}
else if(sectionAuraId=='careplanSection'){
    component.set('v.carepans', [
        {label: "Case Number",fieldName: "CaseNumber",type:'text',hideDefaultActions:true
        },
        {label: "Subject",fieldName: "Subject",type:'text',hideDefaultActions:true},
        
        { label: 'Status', fieldName: 'Status',type:'text',hideDefaultActions: true},
        
    ]);
        var medicat=component.get("c.careplanmethod");
        
        medicat.setParams({
        patientId: PatientId
        });
        
        
        medicat.setCallback(this, function(response){
        var state = response.getState();
        if (state === "SUCCESS") {
        var changedOK = response.getReturnValue();
        if(changedOK.length>0){
        for(var i=0;i<changedOK.length;i++){
        var row=changedOK[i];
                  row.CaseNumber=row.CaseNumber;
                  row.Subject=row.Subject;
                  row.Status =row.Status 	;
                  }
                  component.set("v.careplans",changedOK);
    component.set("v.careplandropdown",true);
}
    else if(changedOK.length==0){
        component.set("v.careplandropdown",false);
    }
}
});
$A.enqueueAction(medicat);
}
var sectionDiv = component.find(sectionAuraId).getElement();
var sectionState = sectionDiv.getAttribute('class').search('slds-is-open'); 

if(sectionState == -1){
    sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
}else{
    sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
}
}
,
    handleCreateContactForLoginOrSignUp : function(component, event,helper) {
        try {
            var getLeadValue = component.get("v.newLead") || {};
            var portalPassword = component.get("v.portalPassword");
            var portalConfirmPassword = component.get("v.portalConfirmPassword");

            if (!/^[a-zA-Z ]*$/.test(getLeadValue.FirstName || '')) {
                var firstNameToast = $A.get("e.force:showToast");
                firstNameToast.setParams({
                    title :$A.get("$Label.c.Error"),
                    message:$A.get("$Label.c.FirstName_Must_Contain_Only_Letters"),
                    duration:' 3000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                firstNameToast.fire();
                return;
            }

            if (!/^[a-zA-Z ]*$/.test(getLeadValue.LastName || '')) {
                var lastNameToast = $A.get("e.force:showToast");
                lastNameToast.setParams({
                    title :$A.get("$Label.c.Error"),
                    message:$A.get("$Label.c.LastName_Must_Contain_Only_Letters"),
                    duration:' 3000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                lastNameToast.fire();
                return;
            }

            if (!/^[a-zA-Z ]*$/.test(getLeadValue.City || '')) {
                var cityToast = $A.get("e.force:showToast");
                cityToast.setParams({
                    title :$A.get("$Label.c.Error"),
                    message:$A.get("$Label.c.City_Must_Contain_Only_Letters"),
                    duration:' 3000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                cityToast.fire();
                return;
            }

            if (!/^[a-zA-Z ]*$/.test(getLeadValue.Country || '')) {
                var countryToast = $A.get("e.force:showToast");
                countryToast.setParams({
                    title :$A.get("$Label.c.Error"),
                    message:$A.get("$Label.c.Country_Must_Contain_Only_Letters"),
                    duration:' 3000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                countryToast.fire();
                return;
            }

            if (!/^[a-zA-Z ]*$/.test(getLeadValue.State || '')) {
                var stateToast = $A.get("e.force:showToast");
                stateToast.setParams({
                    title :$A.get("$Label.c.Error"),
                    message:$A.get("$Label.c.State_Must_Contain_Only_Letters"),
                    duration:' 3000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                stateToast.fire();
                return;
            }

            if (!/^[0-9]*$/.test(getLeadValue.PostalCode || '')) {
                var postalToast = $A.get("e.force:showToast");
                postalToast.setParams({
                    title :$A.get("$Label.c.Error"),
                    message:$A.get("$Label.c.PostalCode_Must_Contain_Only_Numbers"),
                    duration:' 3000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                postalToast.fire();
                return;
            }

            if (!portalPassword) {
                var passwordToast = $A.get("e.force:showToast");
                passwordToast.setParams({
                    title :$A.get("$Label.c.Error"),
                    message:'Please enter a password.',
                    duration:' 3000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                passwordToast.fire();
                return;
            }

            if (portalPassword.length < 8) {
                var passwordLengthToast = $A.get("e.force:showToast");
                passwordLengthToast.setParams({
                    title :$A.get("$Label.c.Error"),
                    message:'Password must contain at least 8 characters.',
                    duration:' 3000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                passwordLengthToast.fire();
                return;
            }

            if (portalPassword !== portalConfirmPassword) {
                var passwordMatchToast = $A.get("e.force:showToast");
                passwordMatchToast.setParams({
                    title :$A.get("$Label.c.Error"),
                    message:'Password and confirm password must match.',
                    duration:' 3000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                passwordMatchToast.fire();
                return;
            }

            var leadInputs = component.find('Lead');
            if (!Array.isArray(leadInputs)) {
                leadInputs = leadInputs ? [leadInputs] : [];
            }

            var allValid = true;
            leadInputs.forEach(function(inputCmp) {
                if (inputCmp && typeof inputCmp.reportValidity === 'function') {
                    inputCmp.reportValidity();
                }
                if (inputCmp && typeof inputCmp.checkValidity === 'function') {
                    allValid = allValid && inputCmp.checkValidity();
                }
            });

            if(!allValid){
                var requiredToast = $A.get("e.force:showToast");
                requiredToast.setParams({
                    title :$A.get("$Label.c.Error"),
                    message:$A.get("$Label.c.Please_Fill_All_Reaquired_Filelds"),
                    duration:' 3000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                requiredToast.fire();
                return;
            }

            helper.showSpinner(component);
            var saveContactAction = component.get("c.registerPortalPatient");
            saveContactAction.setParams({
                firstName: getLeadValue.FirstName,
                lastName: getLeadValue.LastName,
                email: getLeadValue.Email,
                phone: getLeadValue.Phone,
                street: getLeadValue.Street,
                city: getLeadValue.City,
                state: getLeadValue.State,
                country: getLeadValue.Country,
                postalCode: getLeadValue.PostalCode
            });
            saveContactAction.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    var registrationResult = response.getReturnValue();
                    component.set('v.PatientId', registrationResult.patientId);
                    component.set('v.portalEntryIdentifier', registrationResult.patientEmail);
                    component.set('v.portalPatientLabel', registrationResult.patientName);
                    var otpAction = component.get("c.sendOTP");
                    otpAction.setParams({
                        recordId : registrationResult.patientId,
                        otp : component.get("v.otpCode")
                    });
                    otpAction.setCallback(this, function(otpResponse) {
                        helper.hideSpinner(component);
                        if(otpResponse.getState() === "SUCCESS") {
                            component.set('v.showBookAppointment',true);
                            component.set('v.guestUserForLoginOrSignUp',false);
                            component.set('v.isNextModalForSignUp',true);
                            component.set('v.isNextModalsForLogin',false);
                            component.set('v.showverifybotton',true);
                            component.set('v.showconfirmbotton',false);
                            component.set('v.portalOtpInput', '');
                            component.set('v.portalPassword', '');
                            component.set('v.portalConfirmPassword', '');
                            var successToast = $A.get("e.force:showToast");
                            successToast.setParams({
                                title :$A.get("$Label.c.Success"),
                                message:"Person account created successfully. We sent an OTP to your email to verify your Apollo patient access.",
                                duration:' 5000',
                                key: 'info_alt',
                                type: 'success',
                                mode: 'pester'
                            });
                            successToast.fire();
                        } else {
                            var otpErrorToast = $A.get("e.force:showToast");
                            otpErrorToast.setParams({
                                title:$A.get("$Label.c.Error"),
                                mode:"dismissible",
                                message:'Person account was created, but OTP could not be sent. Please try login again.',
                                type:"error"
                            });
                            otpErrorToast.fire();
                        }
                    });
                    $A.enqueueAction(otpAction);
                }
                else if(state === "ERROR") {
                    helper.hideSpinner(component);
                    var errors = response.getError();
                    var errorMessage = 'We could not create the patient profile. Please try again.';
                    if (errors && errors[0] && errors[0].message) {
                        errorMessage = errors[0].message;
                    }
                    var errorToast = $A.get("e.force:showToast");
                    errorToast.setParams({
                        title:$A.get("$Label.c.Error"),
                        mode:"dismissible",
                        message:errorMessage,
                        type:"error"
                    });
                    errorToast.fire();
                }
                else {
                    helper.hideSpinner(component);
                    var incompleteToast = $A.get("e.force:showToast");
                    incompleteToast.setParams({
                        title:$A.get("$Label.c.Error"),
                        mode:"dismissible",
                        message:'Registration could not be completed. Please refresh and try again.',
                        type:"error"
                    });
                    incompleteToast.fire();
                }
            });
            $A.enqueueAction(saveContactAction);
        } catch (error) {
            helper.hideSpinner(component);
            var clientErrorToast = $A.get("e.force:showToast");
            clientErrorToast.setParams({
                title:$A.get("$Label.c.Error"),
                mode:"dismissible",
                message:(error && error.message) ? error.message : 'Registration could not start due to a page error.',
                type:"error"
            });
            clientErrorToast.fire();
        }
    },
       
        
  
})
