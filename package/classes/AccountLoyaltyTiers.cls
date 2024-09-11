public inherited sharing class AccountLoyaltyTiers {

    public static void handleBeforeSave (List<Account> newList) {
    
        // Retrieve the territory rating formulas
        Map<Id, FormulaEval.FormulaInstance> territoryRatingFormulas = getTerritoryRatingFormulas(newList);

        // Iterate through accounts to evaluate and set the rating
        for (Account acc : newList) {

            // Get the formula instance for the territory
            FormulaEval.FormulaInstance ratingFormulaInstance = territoryRatingFormulas.get(acc.Territory__c);
            if (ratingFormulaInstance != null) {
                // Evaluate the rating formula
                String rating = evaluateRatingFormula(ratingFormulaInstance, acc);
                // Update the account rating
                updateAccountLoyaltyTiers(acc, rating);
            }
        }
    }

    private static Map<Id, FormulaEval.FormulaInstance> getTerritoryRatingFormulas(
        List<Account> accounts
    ) {
        Map<Id, FormulaEval.FormulaInstance> territoryRatingFormulaInstances = new Map<Id, FormulaEval.FormulaInstance>();
        Set<Id> territoryIds = new Set<Id>();

        // Collect territory IDs from the accounts
        for (Account acc : accounts) {
            if (acc.Territory__c != null) {
                territoryIds.add(acc.Territory__c);
            }
        }

        // Query the territories and build formula instances
        for (Territory__c territory : [
            SELECT Id, Inflation_Rate__c, Loyalty_Tier_Formula__c, Loyalty_Inflation_Tier_Formula__c
            FROM Territory__c
            WHERE Id IN :territoryIds
        ]) {
            FormulaEval.FormulaInstance formulaInstance = Formula.builder()
                .withReturnType(FormulaEval.FormulaReturnType.String)
                .withType (Account.SObjectType)
                .withFormula(territory.Loyalty_Tier_Formula__c)
                .build();

            territoryRatingFormulaInstances.put(territory.Id, formulaInstance);
        }

        return territoryRatingFormulaInstances;
    }

    private static String evaluateRatingFormula(
        FormulaEval.FormulaInstance formulaInstance,
        Account acc
    ) {
        // Evaluate the rating formula
        Object result = formulaInstance.evaluate(acc);
        return result != null ? (String)result : 'Default Rating'; // Default value if formula evaluation returns null
    }

    private static void updateAccountLoyaltyTiers(Account acc, String rating) {
        // Update the account's rating field
        acc.Loyalty_Tier__c = rating;
    }
}