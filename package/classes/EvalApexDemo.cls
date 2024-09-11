public with sharing class EvalApexDemo {

    /*
    simple formula example :

    'auto fields mapping with parent fields  : ' & Account.Name &' AND ' & FirstName
    */

    public static Map<String,FormulaEval.FormulaReturnType> types = new Map<String,FormulaEval.FormulaReturnType>();

    static {
        types.put('Checkbox',FormulaEval.FormulaReturnType.BOOLEAN);   
        types.put('Date',FormulaEval.FormulaReturnType.Date);   
        types.put('DateTime',FormulaEval.FormulaReturnType.DATETIME);   
        types.put('Number',FormulaEval.FormulaReturnType.LONG);   
        types.put('Percent',FormulaEval.FormulaReturnType.DECIMAL);   
        types.put('Text',FormulaEval.FormulaReturnType.STRING);   
        types.put('Time',FormulaEval.FormulaReturnType.TIME);   
    }


    @AuraEnabled
    public static Object testFormula(Id recordId,String formulaType,String formulaValue,boolean userMode){

        FormulaEval.FormulaInstance formulaInstance = null;

        try {
            formulaInstance=Formula.builder()
            .withReturnType (types.get(formulaType))
            .withType (recordId.getSobjectType())
            .withFormula (formulaValue)
            .build();
        } catch (FormulaValidationException fve) {
            return ' error in formula or type : '+  fve.getMessage();
        } catch (Exception e){
            return ' untype error : '+  e.getMessage();
        }
        
        String queryStr = 'select ' + String.join(new List<String>(formulaInstance.getReferencedFields()),',') + ' FROM '+recordId.getSobjectType()+' WHERE Id=:recordId';
        SObject obj=null;
        if(userMode){
        	obj = Database.query(queryStr,AccessLevel.USER_MODE);
        }else{
			obj = Database.query(queryStr);            
        }

        Object result=null;

        try {
            result = formulaInstance.evaluate(obj);
        } catch (Exception e) {
            return ' unexpected error during eval : '+  e.getMessage();
        }
        return formulaInstance.evaluate(obj);

    }
    
}