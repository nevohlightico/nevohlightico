import {LightningElement, api, wire, track} from 'lwc';
import getBatchList from '@salesforce/apex/Run_A_Batch_Ctrl.getBatchList';
import executeBatch from '@salesforce/apex/Run_A_Batch_Ctrl.RunBatchWithSize';
export default class Run_a_Batch extends LightningElement {
    value;
	@track  message ;
	batchSize = 200;


	myOptions = [];
	@wire(getBatchList)
	wiredBatchOptions({ error, data }) {
		if (data) {
			this.myOptions =  data;
			
		} else if (error) {
			console.log(error);
			this.error = error;
		}
	}
    
    get options() {
	 return this.myOptions;
    }

    handleChange(event) {
        this.value = event.detail.value;
    }

	handleClick(event) {
		debugger;
		executeBatch({batchName : this.value,  batchSize : this.batchSize })
			.then(result => {
                this.message = JSON.parse(result);
            })
            .catch(error => {
                this.message = error;
            });
		
    }

	get showButton(){
		 return !this.value;
     }
}