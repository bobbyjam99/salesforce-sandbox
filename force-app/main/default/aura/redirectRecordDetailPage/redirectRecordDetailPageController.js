({
    invoke: function (component, event, helper) {
        var redirect = $A.get("e.force:navigateToSObject");
        redirect.setParams({
            "recordId": component.get("v.reqRecordId")
        });
        redirect.fire();
    }
})
