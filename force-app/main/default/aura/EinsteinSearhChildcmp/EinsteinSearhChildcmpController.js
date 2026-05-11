({
    
    //Backclickbutton : function (component, event, helper) {
        //  var message = event.getParam("message");
        //component.set("v.callingdoctorappointment",true);
       // component.set("v.booleanvar",false);
        
        
   // },
    searchClickbutton : function(component, event, helper) {
        var holdpushvalue=[];
        console.log(holdpushvalue);
        
        var values=component.get('v.Knowledgearticle');
        
        var action = component.get('c.einstinSearch');
        console.log('action'+ JSON.stringify(action));
        
        action.setParams({
            dataForSearch : values
        });
        action.setCallback(this,function(result){
            var state=result.getState();
           // alert('state '+JSON.stringify(state))
            // console.log(state.length + ' '+ JSON.stringify(state));
            
            if(state==='SUCCESS'){
                var result=result.getReturnValue();
                //alert('result '+JSON.stringify(result));
                // console.log('result' +result);
                for(const key in result){
                    if(Object.hasOwnProperty.call(result,key)){
                        const element = result[key];
                        //console.log('element'+element);
                        holdpushvalue.push({headingPart:key,content:element});
                    }
                }
                component.set("v.fetchArticlevalues",true);
                component.set("v.Articlevalues",holdpushvalue);
                component.set("v.Displayimage",false);
                
            }  
            
            else if(state==='ERROR'){
                var res=result.getError();
               // alert(res);
            }
            
            
        });
 
    $A.enqueueAction(action);         
              

      //  $A.enqueueAction(component.get('c.getAccessToken'));

        
    }
    
})