List<HealthcareProviderSpecialty> providerMappings = [
    SELECT PractitionerId, Practitioner.Name, Account.Name, Specialty.Name
    FROM HealthcareProviderSpecialty
    WHERE PractitionerId != null
    AND (Account.Parent.Name = 'Apollo Hospital' OR Account.Name LIKE '%Apollo%')
    ORDER BY Practitioner.Name
    LIMIT 25
];

Set<Id> practitionerIds = new Set<Id>();
for (HealthcareProviderSpecialty mapping : providerMappings) {
    practitionerIds.add(mapping.PractitionerId);
}

List<Contact> doctorsToUpdate = [
    SELECT Id, Name, Doctor_Rating__c, Years_of_Experience__c, Review_Count__c, Priority_Doctor__c
    FROM Contact
    WHERE Id IN :practitionerIds
    ORDER BY Name
];

Decimal baseRating = 4.2;
Decimal baseExperience = 6;
Integer baseReviews = 48;
Integer indexCounter = 0;

for (Contact doctorRecord : doctorsToUpdate) {
    doctorRecord.Doctor_Rating__c = baseRating + Math.mod(indexCounter, 7) * 0.1;
    doctorRecord.Years_of_Experience__c = baseExperience + Math.mod(indexCounter * 3, 18);
    doctorRecord.Review_Count__c = baseReviews + (indexCounter * 17);
    doctorRecord.Priority_Doctor__c = Math.mod(indexCounter, 4) == 0;
    indexCounter++;
}

if (!doctorsToUpdate.isEmpty()) {
    update doctorsToUpdate;
}

System.debug('Seeded demo doctor ranking data for ' + doctorsToUpdate.size() + ' Apollo practitioners.');
