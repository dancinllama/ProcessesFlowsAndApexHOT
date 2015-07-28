/**
 * @description Class used for logging messages to the Loggly service (http://www.loggly.com)
 * @author James Loghry
 * @date 7/29/2015
 */
public class FlowLogglyUtil{
 
    /**
     * Takes a list of strings (will only be a single string from a Flow) and POSTs the messages to Loggly.
     */   
    @InvocableMethod(label='Log message with Loggly' description='Logs a message by making a callout and posting to Loggly\'s service.  Requires a Loggly account.')
    public static void log(List<String> messages){
        doCallout(messages);
    }
    
    //Even Flows are subject to the Uncommitted Data Pending exceptions.
    //Hence, we need to call a future method that does the actual callout.
    //Boo!
    @future (callout=true)
    private static void doCallout(List<String> messages) {
        Loggly_Settings__c logglySettings = Loggly_Settings__c.getInstance();
        
        List<String> arguments = new List<String>{logglySettings.Loggly_Token__c,'flow'};
        String requestUrl = String.format(logglySettings.Loggly_URL__c,arguments);
        
        HttpRequest request = new HttpRequest();
        request.setHeader('Accept','application/json');
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(requestURL);
        request.setMethod('POST');
        request.setTimeout(60000);
        request.setBody(JSON.serialize(messages));
        
        Http httpRequest = new Http();
        HttpResponse response = httpRequest.send(request);
    }
}