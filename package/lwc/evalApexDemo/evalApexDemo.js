import { LightningElement } from 'lwc';
import testFormula from '@salesforce/apex/EvalApexDemo.testFormula';

export default class EvalApexDemo extends LightningElement {

    formulaType;
    recordId;
    recordId2;
    formula1;
    formula2;
    result1;
    result2;
    result21;
    result22;
    userMode=false;

    get options() {
        return [
            { label: 'Checkbox', value: 'Checkbox' },
            { label: 'Date', value: 'Date' },
            { label: 'DateTime', value: 'DateTime' },
            { label: 'Number', value: 'Numnber' },
            { label: 'Percent', value: 'Percent' },
            { label: 'Text', value: 'Text' },
            { label: 'Time', value: 'Time' },
        ];
    }

    handleChange(event) {
        this.formulaType = event.detail.value;
    }

    setValue1(event){
        this.formula1 = event.detail.value;
    }

    setValue2(event){
        this.formula2 = event.detail.value;
    }

    setRecordId(){
        this.recordId = event.detail.value;
    }
    setRecordId2(){
        this.recordId2 = event.detail.value;
    }

    setOptionalFields(event){
        this.userMode=event.target.checked;
    }

    calculate(){
        console.log('this.userMode>'+this.userMode);
        if(!this.optionalFields)this.optionalFields=null;
        if(this.formula1){
            testFormula({recordId: this.recordId , formulaType : this.formulaType,formulaValue : this.formula1,userMode : this.userMode}).then(data => {
                this.result1=data;
            });
        }
        if(this.formula2){
            testFormula({recordId: this.recordId , formulaType : this.formulaType,formulaValue : this.formula2,userMode : this.userMode}).then(data => {
                this.result2=data;
            });
        }
        if(this.formula1&&this.recordId2){
            testFormula({recordId: this.recordId2 , formulaType : this.formulaType,formulaValue : this.formula1,userMode : this.userMode}).then(data => {
                this.result21=data;
            });
        }
        if(this.formula2&&this.recordId2){
            testFormula({recordId: this.recordId2 , formulaType : this.formulaType,formulaValue : this.formula2,userMode : this.userMode}).then(data => {
                this.result22=data;
            });
        }

    }

}