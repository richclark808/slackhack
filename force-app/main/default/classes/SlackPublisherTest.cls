@IsTest(seeAllData=false)
private class SlackPublisherTest {

    @TestSetup
    static void makeData(){
        // You'll want to change this depending on the SObjects you're looking to 
        // process. Just so you know it's all working

        // Create a dummy account
        Account a = new Account(Name='Provar Testing');
        insert a;
        // Create a dummy contact
        Contact c = new Contact(Firstname='Richard', Lastname='Clark', AccountId=a.Id);
        insert c;
        // Create an opportunity
        Opportunity o = new Opportunity(Name='Slack Hack', StageName='Prospecting', 
                                        CloseDate=System.today(), Amount=100.00);
        insert o;

        // Note that Custom Metadata and Named Credentials are visible to your test
    }

    @isTest
    static void testPublish() {
        Opportunity opp = [SELECT Name, StageName, CloseDate, Amount
                           FROM   Opportunity
                           WHERE  Name = 'Slack Hack'];

        Test.setMock(HttpCalloutMock.class, new SlackPubllisherMock());   
        Test.startTest();
        // Set the Opportunity Amount to $1m
        opp.Amount = 1000000;
        update opp;

        // Set the Stage to Closed Won
        opp.StageName = 'Closed Won';
        update opp;
        
        // Unfortunately we can't assert anything meaninful, we'd need Provar to check
        // our messages are being sent and displayed, that's a different talk!

        Test.stopTest();

    }

}