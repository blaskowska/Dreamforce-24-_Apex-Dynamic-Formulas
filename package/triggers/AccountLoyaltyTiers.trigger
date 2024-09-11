trigger AccountLoyaltyTiers on Account (before insert, before update) {
    if (Trigger.isBefore) {
        // Call the handler method for before save operations
        AccountLoyaltyTiers.handleBeforeSave(Trigger.new);
    }
}