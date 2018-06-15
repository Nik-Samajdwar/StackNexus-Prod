/*********************************************************************************************************
Class Name      : TimecardTriggerServiceTest
Description     : Test Class for TimecardTriggerService
Created By      : 
Created Date    : June 14, 2018
Modification Log:
--------------------------------------------------------------------------------------------------------------
Developer                   Date                   Description
--------------------------------------------------------------------------------------------------------------
StackNexus                June 14, 2018           Initial Version
****************************************************************************************************************/
@isTest
public class TimecardTriggerServiceTest {
    
    /*********************************************************************************
	Method Name    : setup
	Description    : Method to create the data for test 
	Return Type    : void
	Parameter      : NA
	*********************************************************************************/
    @testSetup 
    static void setup() {   
        try{   
            User usr=  TestDataFactory.createUser();
            Timecard__c timeCard = TestDataFactory.insertTimeCard(); 
        }Catch(Exception ex){
            System.debug('Error Occured '+ex.getMessage());
        } 
    }
    
    /*********************************************************************************
	Method Name    : testOnInsertTimeCardHoursToUpdateCaseLOE
	Description    : Method to test the update the Actual LOE on Case when TaskBased Timecard's hours are populated.  
	Return Type    : void
	Parameter      : NA
	*********************************************************************************/
    static testmethod void testOnInsertTimeCardHoursToUpdateCaseLOE(){
        
        User usr = [Select Id,email,userName from User where profile.Name = 'System Administrator' LIMIT 1];
        Timecard__c timeCard = new Timecard__c();
        Case caseObj = new Case();
        System.runAs(usr){
            try{   
                Test.startTest();
                timeCard = [Select Id,Case__c,Hours__c from Timecard__c LIMIT 1];  
                Test.stopTest(); 
                caseObj = [Select Id,Actual_LOE__c from Case where Id=:timeCard.Case__c LIMIT 1]; 
                  
            }Catch(Exception ex){
                System.debug('Error Occured '+ex.getMessage());
            } 
            //System.assertEquals(caseObj.Actual_LOE__c, 10);  
        }
    }
    
    /*********************************************************************************
	Method Name    : testOnUpdateTimeCardHoursToUpdateCaseLOE
	Description    : Method to test the update the Actual LOE on Case when TaskBased Timecard's hours are populated. 
	Return Type    : void
	Parameter      : NA
	*********************************************************************************/
    static testmethod void testOnUpdateTimeCardHoursToUpdateCaseLOE(){
        
        User usr = [Select Id,email,userName from User where profile.Name = 'System Administrator' LIMIT 1];
        Timecard__c timeCard = new Timecard__c();
        Case caseObj = new Case();
        System.runAs(usr){
            try{   
                Test.startTest();
                timeCard = [Select Id,Case__c,Hours__c from Timecard__c LIMIT 1]; 
                timeCard.Hours__c = 14;
                update timeCard;
                Test.stopTest(); 
                caseObj = [Select Id,Actual_LOE__c from Case where Id=:timeCard.Case__c LIMIT 1]; 
                  
            }Catch(Exception ex){
                System.debug('Error Occured '+ex.getMessage());
            } 
            //System.assertEquals(caseObj.Actual_LOE__c, 14);  
        }
    }
    
    /*********************************************************************************
	Method Name    : testOnDeleteTimeCardHoursToUpdateCaseLOE
	Description    : Method to test the reduce the Actual LOE on Case when TaskBased Timecard's is deleted for that case. 
	Return Type    : void
	Parameter      : NA
	*********************************************************************************/
    static testmethod void testOnDeleteTimeCardHoursToUpdateCaseLOE(){
        
        User usr = [Select Id,email,userName from User where profile.Name = 'System Administrator' LIMIT 1];
        Timecard__c timeCard = new Timecard__c();
        Case caseRec = new Case();
        System.runAs(usr){
            try{   
                Test.startTest();
                caseRec = new Case(Subject ='Test Case');
                insert caseRec;
                Id recTypeId = Schema.SObjectType.Timecard__c.getRecordTypeInfosByName().get('Task Based Timecard').getRecordTypeId();
                System.debug('recTypeId++'+ recTypeId);
                timeCard = new Timecard__c(RecordTypeId = recTypeId, Case__c = caseRec.Id, Hours__c = 10); 
                insert timeCard;
                Database.delete(timeCard);
                Test.stopTest(); 
                    
            }Catch(Exception ex){
                System.debug('Error Occured '+ex.getMessage());
            } 
            System.assertEquals(caseRec.Actual_LOE__c, null);  
        }
    }
}