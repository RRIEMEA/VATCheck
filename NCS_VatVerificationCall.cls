public with sharing class NCS_VatVerificationCall {
    
    @InvocableMethod(callout=true label='VAT Verification' description='Verifies if Non German VAT Number is valid')
    public static List<Results> execute (List<Requests> requestList) {

        //callout
        HTTP h = new HTTP();
        String httpMethod = 'GET';
        String endpoint = 'https://evatr.bff-online.de/evatrRPC?UstId_1=' + requestList[0].ustId1 + '&UstId_2=' + requestList[0].ustId2;
        httpRequest req = new httpRequest();
        req.setMethod(httpMethod);
        req.setEndpoint(endpoint);
        httpResponse res = h.send(req);

        //parse XML-RPC response   
        Dom.Document doc = res.getBodyDocument();
        Dom.XmlNode methodResponse = doc.getRootElement();
        List<String>returnedResults = new List<String>();
        for(Dom.XmlNode dNode : methodResponse.getChildElements()){
            for(Dom.XmlNode dNodeChild : dnode.getChildElement('value', null).getChildElement('array', null).getChildElement('data', null).getChildElements()) {
                String returnedResult = dNodeChild.getChildElement('string', null).getText();
                returnedResults.add(returnedResult);
            }
        }
        
        //prepare return statement
        List<Results> resultList = new List<Results>();
        Results result = new Results();
        result.callResult = getResultText(returnedResults[3], returnedResults[13], returnedResults[23], returnedResults[25], requestList[0].ustId2);
        result.callResultXml = res.getBody();
        resultList.add(result);
        return resultList;
    }

    public class Requests {
        @InvocableVariable(label='Own UstId' required=true)
        public String ustId1;

        @InvocableVariable(label='UstId to verify' required=true)
        public String ustId2;
    }
      
    public class Results {
        @InvocableVariable(label='Result' required=true)
        public String callResult;

        @InvocableVariable(label='Result XML' required=true)
        public String callResultXml;
    }

    public static String getResultText(String errorCode, String requestedDate, String validFrom, String validTo, String vatNumber) {
        switch on errorCode {
            when '200' {
                return Label.VAT_200.replace('{vatNumber}', vatNumber) + ' - Date: ' + requestedDate;
            }
            when '201' {
                return Label.VAT_201 + ' - Date: ' + requestedDate;
            }
            when '202' {
                return Label.VAT_202 + ' - Date: ' + requestedDate;
            }
            when '203' {
                return Label.VAT_203.replace('{validFrom}', validFrom) + ' - Date: ' + requestedDate;
            }
            when '204' {
                return Label.VAT_204.replace('{validFrom}', validFrom).replace('{validTo}', validTo) + ' - Date: ' + requestedDate;
            }
            when '205' {
                return Label.VAT_205 + ' - Date: ' + requestedDate;
            }
            when '206' {
                return Label.VAT_206 + ' - Date: ' + requestedDate;
            }
            when '208' {
                return Label.VAT_208 + ' - Date: ' + requestedDate;
            }
            when '209' {
                return Label.VAT_209 + ' - Date: ' + requestedDate;
            }
            when '210' {
                return Label.VAT_210 + ' - Date: ' + requestedDate;
            }
            when '211' {
                return Label.VAT_211 + ' - Date: ' + requestedDate;
            }
            when '212' {
                return Label.VAT_212 + ' - Date: ' + requestedDate;
            }
            when '213' {
                return Label.VAT_213 + ' - Date: ' + requestedDate;
            }
            when '214' {
                return Label.VAT_214 + ' - Date: ' + requestedDate;
            }
            when '215' {
                return Label.VAT_215 + ' - Date: ' + requestedDate;
            }
            when '217' {
                return Label.VAT_217 + ' - Date: ' + requestedDate;
            }
            when '221' {
                return Label.VAT_221 + ' - Date: ' + requestedDate;
            }
            when '999' {
                return Label.VAT_999 + ' - Date: ' + requestedDate;
            }
            when else {
                return 'Error code unknown';
            }
        }
    } 
}
