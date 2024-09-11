public class SobjectUtil {


    public static String getStarQueryFromRecordId(Id recordId){
        String sObjectApiName= String.valueOf(recordId.getSobjectType());
        return generateSoqlQuery(sObjectApiName,null)+' WHERE Id=:recordId';
    }


    public static String getStarQueryFromRecordId(Id recordId,String strOptionalFields){
        Set<String> optionalFields=null;
        if(strOptionalFields!=null){
            optionalFields = new Set<String>(strOptionalFields.split(','));
        }
        String sObjectApiName= String.valueOf(recordId.getSobjectType());
        return generateSoqlQuery(sObjectApiName,optionalFields)+' WHERE Id=:recordId';
    }



    private static String generateSoqlQuery(String sObjectApiName,Set<String> optionalFields){
        List<String> soqlColumns =new List<String>();
        for(FieldDefinition fieldDef : [SELECT QualifiedApiName   FROM FieldDefinition WHERE EntityDefinition.QualifiedApiName =:sObjectApiName AND IsCalculated = false]){
            soqlColumns.add(fieldDef.QualifiedApiName);
        }
        if(optionalFields!=null){
            soqlColumns.addAll(new List<String>(optionalFields));
        }

        system.debug(String.join(soqlColumns,','));

        return 'SELECT '+String.join(soqlColumns,',')+' FROM '+sObjectApiName ;
    }
    

}