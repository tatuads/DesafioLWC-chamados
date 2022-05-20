public with sharing class AccountController {
    
    @AuraEnabled(cacheable=true)
    public static string getAccounts(){
        List<InputWrapper> enterlist = new List<InputWrapper>();
        
        try {
            
            List<Account> accountList = [SELECT Id, Name FROM Account];
            for(Account cTemp : accountList){
                enterlist.add(new InputWrapper(cTemp.Id, cTemp.Name));
            }

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return JSON.serialize(enterlist);
    }

    @AuraEnabled(cacheable=true)
    public static PageResultWrapper searchClients(String filter, Integer pageNumber){

        Integer pagecounter = 9;
        String whereClausule = '';
        Integer offSet = (pageNumber-1)*pagecounter;

        if(String.IsNotBlank(filter)){
            whereClausule += ' WHERE Name LIKE \'%'+filter+'%\'';
        }
    
        PageResultWrapper result = new PageResultWrapper();
        result.tamanhoDaPagina  = pagecounter;
        result.totalItems       = Database.countQuery('SELECT count() FROM Account '+whereClausule);
        result.allDatas         = Database.query('SELECT Id, Name FROM Account '+whereClausule+' LIMIT :pagecounter OFFSET :offset ');

        return result;
    }
}
