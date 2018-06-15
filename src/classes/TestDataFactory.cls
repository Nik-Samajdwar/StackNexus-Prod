/****************************************************************************************************************************************** 
* Class Name   : TestDataFactory
* Description  : test data factory class for creating data for testing  method. 
* Created By   : Stack Nexus
*****************************************************************************************************************************************/
@isTest(SeeAllData=true)
public class TestDataFactory {
    
    /*
    * Method name : createUser.
    * Description :  This methods is used to create user.
    * Returns :  User
    */
    public static user createUser() {
        // Setup test data
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        system.debug('profile'+p);
        User usr = new User(Alias = 'tuser', Email='usertest@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='test_user@test123.com');
        system.debug('username'+usr.username);
        insert usr;
        return usr;
    }
    
     /*
    * Method name : insertTimeCard.
    * Description :  This methods is used to insert Timecard.
    * Returns :  User
    */
    public static Timecard__c insertTimeCard() {
        // Setup test data
        Case caseRec = new Case(Subject ='Test Case');
        insert caseRec;
        Timecard__c timeCard = new Timecard__c(RecordTypeId = '0122F0000008vEzQAI', Case__c = caseRec.Id, Hours__c = 10); 
        insert timeCard;
        return timeCard;
    }

}