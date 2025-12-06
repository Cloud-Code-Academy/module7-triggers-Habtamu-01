public with sharing class AccountTriggerHandler {
   public static void beforeInsert(List<Account> accList){
    //1. Set the account type to prospect.
    for(Account acc : accList){
        if(String.isBlank(acc.Type)){
            acc.Type = 'Prospect';
        }
        //2. Copy the shipping address to the billing address.
        if(!String.isBlank(acc.ShippingStreet)){
            acc.BillingCity = acc.ShippingCity;
            acc.BillingCountry = acc.ShippingCountry;
            acc.BillingPostalCode = acc.ShippingPostalCode;
            acc.BillingState = acc.ShippingState;
            acc.BillingStreet = acc.ShippingStreet;
        }
       //3. Set the account rating to hot.
        if(!String.isBlank(acc.Phone) && !String.isBlank(acc.Fax) && !String.isBlank(acc.Website)){
            acc.Rating = 'Hot';
        }
    }
}
// 4. Create a contact for each account inserted.
   public static void afterInsert(List<Account> accList) {
        List<Contact> contacts = new List<Contact>();
        for (Account acc : accList) {
            contacts.add(new Contact(
                LastName = 'DefaultContact',
                Email = 'default@email.com',
                AccountId = acc.Id
            ));
        }
        insert contacts;
    }
}

