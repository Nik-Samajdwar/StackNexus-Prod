trigger TimecardTrigger on Timecard__c (after insert, after update, after delete) {

	if(Trigger.isAfter && Trigger.isInsert){
		TimecardTriggerService.processOnInsert(Trigger.new);
	}

	if(Trigger.isAfter && Trigger.isUpdate){
		TimecardTriggerService.processOnUpdate(Trigger.new, Trigger.oldMap);	
	}

	if(Trigger.isAfter && Trigger.isDelete){
		TimecardTriggerService.processOnDelete(Trigger.old);	
	}
}