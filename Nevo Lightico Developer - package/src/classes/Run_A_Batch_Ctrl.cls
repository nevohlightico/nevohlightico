public class Run_A_Batch_Ctrl  {

	@AuraEnabled(cacheable=true)
	public static List<BatchOption> getBatchList(){
		list<BatchOption> batchOptions = new list<BatchOption>();
        string batchString = 'Database.batchable' ;
        for (ApexClass batchClass : [SELECT id, Name, Body FROM ApexClass WHERE Name != 'Run_A_Batch_Ctrl']) {
            if (batchClass.Body.containsIgnoreCase('Database.batchable')) {
                batchOptions.add(new batchOption(batchClass.Name));
            }
        }
		System.debug('hi');
		return batchOptions;
	
	}

	// wrapper class with @AuraEnabled and {get;set;} properties 
    public class BatchOption{
        @AuraEnabled
        public string label{get;set;}
		@AuraEnabled
        public string value{get;set;}
	    
		public BatchOption(string batchName){
			this.label = batchName;
			this.value = batchName;
		}
        
    }

	@AuraEnabled
	public static String RunBatchWithSize(string batchName, integer batchSize){
		if(batchName == null || batchName == '' ) return 'Please select a Batch class';
		if(batchSize < 0 || batchSize >200) return 'Please select Batch Size Between 1-200 ';
		string jobid;
		try{
		    System.debug('batchName===' +batchName);
		    System.Type myClass =  Type.forName(batchName);
			jobid = Database.executeBatch((Database.Batchable<SObject>)myClass.newInstance(), batchSize);			
			insert new BachRunner__Batch_Log__c(Status__c = 'Success',Batch_Name__c = batchName, Batch_Execution_Message__c = 'Batch class: "'+batchName+'" with Job Id:'+jobid+' Ran Successfully');
			return JSON.serialize('The Batch Is Runnning, view Bach Log for Details');
		}catch(Exception e){
		  System.debug('e===' +e);
		  System.debug('e===' +e.getLineNumber());
		  insert new BachRunner__Batch_Log__c(Status__c = 'Fail',Batch_Name__c = batchName, Batch_Execution_Message__c = 'Batch class "'+batchName+'" Failed to Run due to:'+e.getMessage());
		  return JSON.serialize(e.getMessage());
		}
	
	}


}