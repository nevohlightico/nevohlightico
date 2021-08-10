@isTest 
private class Run_A_Batch_Ctrl_Test {

	@isTest
	private static void getBatchList_Test() {
		Run_A_Batch_Ctrl.getBatchList();
	}

	@isTest
	private static void runBatchWithSize_Test() {
		List<Run_A_Batch_Ctrl.BatchOption> BatchOptions = Run_A_Batch_Ctrl.getBatchList();
		Run_A_Batch_Ctrl.RunBatchWithSize(BatchOptions[0].label,200);
	}

	@isTest
	private static void fail_Test() {
		Run_A_Batch_Ctrl.RunBatchWithSize('Run_A_Batch_Ctrl_Test',200);
	}
}