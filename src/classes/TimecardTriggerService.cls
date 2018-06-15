public class TimecardTriggerService{
	
	public static void processOnInsert(List<Timecard__c> timeCards){
		updateCaseLOE('INSERT', timeCards, null);
	}

	public static void processOnUpdate(List<Timecard__c> timeCards, Map<Id, Timecard__c> oldTimecardMap){
		updateCaseLOE('UPDATE', timeCards, oldTimecardMap);
	}

	public static void processOnDelete(List<Timecard__c> timeCards){
		updateCaseLOE('DELETE', timeCards, null);	
	}

	public static void updateCaseLOE(String action, List<Timecard__c> timeCards, Map<Id, Timecard__c> oldTimecardMap){
		Boolean flag = true;		
		List<Case> caseUpdates = new List<Case>();
		List<String> caseIds = new List<String>();
		List<Timecard__c> timeCardList = new List<Timecard__c>();

		for(Timecard__c timeCard : timeCards){
			if(timeCard.Case__c != null){
				timeCardList.add(timeCard);
				caseIds.add(timeCard.Case__c);				
			}
		}

		if(!caseIds.isEmpty()){
			Map<Id, Case> caseMap = getCases(caseIds);

			for(Timecard__c timeCard : timeCardList){
				if(oldTimecardMap != null && (oldTimecardMap.get(timeCard.Id).Hours__c == timeCard.Hours__c)){
					flag = false;
				}

				if(flag){
					if(timeCard.Case__c != null){
						Case caseObj = caseMap.get(timeCard.Case__c);

						if(action.equals('INSERT')){
							System.debug('In INSERT-------------->>>');
							if(caseObj.Actual_LOE__c == null){
								caseObj.Actual_LOE__c = 0;
							}
							
							caseObj.Actual_LOE__c += timeCard.Hours__c;						
						}else if(action.equals('UPDATE')){
							System.debug('In UPDATE-------------->>>');
							caseObj.Actual_LOE__c -= oldTimecardMap.get(timeCard.Id).Hours__c;
							caseObj.Actual_LOE__c += timeCard.Hours__c;
						}else{
							System.debug('In DELETE-------------->>>');
							caseObj.Actual_LOE__c -= timeCard.Hours__c;
						}
						System.debug('caseObj.Actual_LOE__c-------------->>>'+caseObj.Actual_LOE__c);
						caseUpdates.add(caseObj);
					}
				}
			}
			System.debug('caseUpdates-------------->>>'+caseUpdates);
			update caseUpdates;
		}		
	}

	private static Map<Id, Case> getCases(List<String> caseIds){
		Map<Id, Case> caseMap = new Map<Id, Case>([Select Id, Subject, Actual_LOE__c
							 					   FROM Case
							 					   WHERE Id IN: caseIds]);

		return caseMap;
	}

}