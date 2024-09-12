public inherited sharing class AccountLoyaltyTiers {

    public static void handleBeforeSave(List<Account> newList) {
    
        // Retrieve the territory Loyalty Tiers formulas
        Map<Id, FormulaEval.FormulaInstance> TerritoryLoyaltyTierFormulas = getTerritoryLoyaltyTierFormulas(newList);

        // Iterate through accounts to evaluate and set Loyalty Tier
        for(Account acc : newList) {

            // Get the formula instance for the territory
            FormulaEval.FormulaInstance loyaltytierFormulaInstance = TerritoryLoyaltyTierFormulas.get(acc.Territory__c);
            if(loyaltytierFormulaInstance != null) {
                // Evaluate the Loyalty Tier formula
                String loyaltytier = evaluateLoyaltyTierFormula(loyaltytierFormulaInstance, acc);
                // Update the account Loyalty Tier
                updateAccountLoyaltyTiers(acc, loyaltytier);
            }
        }
    }

    private static Map<Id, FormulaEval.FormulaInstance> getTerritoryLoyaltyTierFormulas(List<Account> accounts) {
        Map<Id, FormulaEval.FormulaInstance> TerritoryLoyaltyTierFormulaInstances = new Map<Id, FormulaEval.FormulaInstance>();
        Set<Id> territoryIds = new Set<Id>();

        // Collect territory IDs from the accounts
        for(Account acc : accounts) {
            if(acc.Territory__c != null) {
                territoryIds.add(acc.Territory__c);
            }
        }

        // Query the territories and build formula instances
        for(Territory__c territory : [
            SELECT Id, Loyalty_Tier_Formula__c
            FROM Territory__c
            WHERE Id IN :territoryIds
        ]) {
            FormulaEval.FormulaInstance formulaInstance = Formula.builder()
                .withReturnType(FormulaEval.FormulaReturnType.String)
                .withType(Account.class)
                .withFormula(territory.Loyalty_Tier_Formula__c)
                .build();

            TerritoryLoyaltyTierFormulaInstances.put(territory.Id, formulaInstance);
        }

        return TerritoryLoyaltyTierFormulaInstances;
    }

    private static String evaluateLoyaltyTierFormula(
        FormulaEval.FormulaInstance formulaInstance,
        Account acc
    ) {
        // Evaluate the loyalty tier formula
        Object result = formulaInstance.evaluate(acc);
        return result != null ? (String)result : 'Default loyaltytier'; // Default value if formula evaluation returns null
    }

    private static void updateAccountLoyaltyTiers(Account acc, String loyaltytier) {
        // Update the account's Loyalty Tier field
        acc.Loyalty_Tier__c = loyaltytier;
    }
}
