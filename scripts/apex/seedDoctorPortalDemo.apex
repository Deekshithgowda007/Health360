String portalHospitalName = 'Apollo Hospital';

Account portalHospital;
List<Account> existingHospitals = [
    SELECT Id, Name, Phone, Website, ShippingCity, ShippingState, ShippingCountry
    FROM Account
    WHERE Name = :portalHospitalName
    LIMIT 1
];

if (existingHospitals.isEmpty()) {
    portalHospital = new Account(
        Name = portalHospitalName,
        Phone = '+91 80 4000 1000',
        Website = 'https://www.apollohospitals.com',
        ShippingCity = 'Bangalore',
        ShippingState = 'Karnataka',
        ShippingCountry = 'India'
    );
    insert portalHospital;
} else {
    portalHospital = existingHospitals[0];
}

Map<String, Account> branchesByName = new Map<String, Account>();
for (Account branchRecord : [
    SELECT Id, Name, ParentId
    FROM Account
    WHERE ParentId = :portalHospital.Id
]) {
    branchesByName.put(branchRecord.Name, branchRecord);
}

List<Account> branchesToInsert = new List<Account>();
List<Account> demoBranches = new List<Account>{
    new Account(
        Name = 'Apollo Bangalore Dental Center',
        ParentId = portalHospital.Id,
        Phone = '+91 80 4100 1001',
        Website = 'https://www.apollohospitals.com/bangalore-dental',
        BillingStreet = '12 Residency Road',
        BillingCity = 'Bangalore',
        BillingState = 'Karnataka',
        BillingPostalCode = '560025',
        BillingCountry = 'India',
        ShippingCity = 'Bangalore',
        ShippingState = 'Karnataka',
        ShippingCountry = 'India'
    ),
    new Account(
        Name = 'Apollo Bangalore North',
        ParentId = portalHospital.Id,
        Phone = '+91 80 4100 1002',
        Website = 'https://www.apollohospitals.com/bangalore-north',
        BillingStreet = '44 Hebbal Ring Road',
        BillingCity = 'Bangalore',
        BillingState = 'Karnataka',
        BillingPostalCode = '560024',
        BillingCountry = 'India',
        ShippingCity = 'Bangalore',
        ShippingState = 'Karnataka',
        ShippingCountry = 'India'
    ),
    new Account(
        Name = 'Apollo Delhi Dental Center',
        ParentId = portalHospital.Id,
        Phone = '+91 11 4200 2001',
        Website = 'https://www.apollohospitals.com/delhi-dental',
        BillingStreet = '7 Saket Road',
        BillingCity = 'Delhi',
        BillingState = 'Delhi',
        BillingPostalCode = '110017',
        BillingCountry = 'India',
        ShippingCity = 'Delhi',
        ShippingState = 'Delhi',
        ShippingCountry = 'India'
    ),
    new Account(
        Name = 'Apollo Delhi Central',
        ParentId = portalHospital.Id,
        Phone = '+91 11 4200 2002',
        Website = 'https://www.apollohospitals.com/delhi-central',
        BillingStreet = '28 Connaught Place',
        BillingCity = 'Delhi',
        BillingState = 'Delhi',
        BillingPostalCode = '110001',
        BillingCountry = 'India',
        ShippingCity = 'Delhi',
        ShippingState = 'Delhi',
        ShippingCountry = 'India'
    )
};

for (Account branchSeed : demoBranches) {
    if (!branchesByName.containsKey(branchSeed.Name)) {
        branchesToInsert.add(branchSeed);
    }
}

if (!branchesToInsert.isEmpty()) {
    insert branchesToInsert;
}

for (Account branchRecord : [
    SELECT Id, Name, ParentId
    FROM Account
    WHERE ParentId = :portalHospital.Id
]) {
    branchesByName.put(branchRecord.Name, branchRecord);
}

Map<String, CareSpecialty> specialtiesByName = new Map<String, CareSpecialty>();
for (CareSpecialty specialtyRecord : [
    SELECT Id, Name
    FROM CareSpecialty
    WHERE Name IN ('Dental Care', 'Cardiology', 'Orthopedics', 'Pediatrics')
]) {
    specialtiesByName.put(specialtyRecord.Name, specialtyRecord);
}

List<CareSpecialty> specialtiesToInsert = new List<CareSpecialty>();
for (String specialtyName : new List<String>{ 'Dental Care', 'Cardiology', 'Orthopedics', 'Pediatrics' }) {
    if (!specialtiesByName.containsKey(specialtyName)) {
        specialtiesToInsert.add(new CareSpecialty(Name = specialtyName));
    }
}

if (!specialtiesToInsert.isEmpty()) {
    insert specialtiesToInsert;
    for (CareSpecialty specialtyRecord : specialtiesToInsert) {
        specialtiesByName.put(specialtyRecord.Name, specialtyRecord);
    }
}

List<Map<String, Object>> doctorSeeds = new List<Map<String, Object>>{
    new Map<String, Object>{
        'firstName' => 'Asha',
        'lastName' => 'Nair',
        'branchName' => 'Apollo Bangalore Dental Center',
        'specialtyName' => 'Dental Care',
        'overview' => 'Restorative dentistry specialist focused on family dental care.',
        'expertise' => 'Root Canal, Smile Design, Cosmetic Dentistry',
        'awards' => 'Karnataka Dental Excellence Award',
        'appointmentType' => 'In Person',
        'rating' => 4.8,
        'experience' => 11,
        'reviews' => 186,
        'priority' => true
    },
    new Map<String, Object>{
        'firstName' => 'Rohit',
        'lastName' => 'Kapoor',
        'branchName' => 'Apollo Bangalore Dental Center',
        'specialtyName' => 'Dental Care',
        'overview' => 'Preventive and pediatric dentist with strong patient education focus.',
        'expertise' => 'Pediatric Dentistry, Teeth Cleaning, Braces Consultation',
        'awards' => 'Patient Choice Recognition 2025',
        'appointmentType' => 'In Person',
        'rating' => 4.6,
        'experience' => 8,
        'reviews' => 132,
        'priority' => false
    },
    new Map<String, Object>{
        'firstName' => 'Meera',
        'lastName' => 'Iyer',
        'branchName' => 'Apollo Bangalore North',
        'specialtyName' => 'Cardiology',
        'overview' => 'Senior cardiologist managing preventive and interventional care.',
        'expertise' => 'Heart Checkup, Hypertension, Preventive Cardiology',
        'awards' => 'Best Cardiac Physician 2024',
        'appointmentType' => 'Virtual',
        'rating' => 4.9,
        'experience' => 16,
        'reviews' => 241,
        'priority' => true
    },
    new Map<String, Object>{
        'firstName' => 'Arjun',
        'lastName' => 'Shetty',
        'branchName' => 'Apollo Bangalore North',
        'specialtyName' => 'Orthopedics',
        'overview' => 'Orthopedic consultant for sports injuries and joint recovery.',
        'expertise' => 'Knee Pain, Sports Injury, Fracture Follow-up',
        'awards' => 'South India Sports Medicine Award',
        'appointmentType' => 'In Person',
        'rating' => 4.7,
        'experience' => 13,
        'reviews' => 167,
        'priority' => false
    },
    new Map<String, Object>{
        'firstName' => 'Neha',
        'lastName' => 'Bansal',
        'branchName' => 'Apollo Delhi Dental Center',
        'specialtyName' => 'Dental Care',
        'overview' => 'Dental surgeon known for gentle treatment planning and follow-up care.',
        'expertise' => 'Dental Implants, Cavity Filling, Oral Screening',
        'awards' => 'Delhi Clinical Care Distinction',
        'appointmentType' => 'In Person',
        'rating' => 4.8,
        'experience' => 12,
        'reviews' => 209,
        'priority' => true
    },
    new Map<String, Object>{
        'firstName' => 'Karan',
        'lastName' => 'Malhotra',
        'branchName' => 'Apollo Delhi Dental Center',
        'specialtyName' => 'Dental Care',
        'overview' => 'General dentist offering same-day consultation for common dental needs.',
        'expertise' => 'Tooth Pain, Preventive Care, Dental Consultation',
        'awards' => 'Community Oral Health Recognition',
        'appointmentType' => 'Virtual',
        'rating' => 4.5,
        'experience' => 7,
        'reviews' => 118,
        'priority' => false
    },
    new Map<String, Object>{
        'firstName' => 'Sonal',
        'lastName' => 'Gupta',
        'branchName' => 'Apollo Delhi Central',
        'specialtyName' => 'Pediatrics',
        'overview' => 'Pediatric consultant for newborn to adolescent outpatient care.',
        'expertise' => 'Child Fever, Growth Monitoring, Vaccination Advice',
        'awards' => 'Child Wellness Service Award',
        'appointmentType' => 'In Person',
        'rating' => 4.9,
        'experience' => 14,
        'reviews' => 224,
        'priority' => true
    },
    new Map<String, Object>{
        'firstName' => 'Vikram',
        'lastName' => 'Suri',
        'branchName' => 'Apollo Delhi Central',
        'specialtyName' => 'Cardiology',
        'overview' => 'Cardiac consultant for preventive screening and long-term heart care.',
        'expertise' => 'Chest Pain Evaluation, ECG Review, Preventive Screening',
        'awards' => 'National Preventive Cardiology Honor',
        'appointmentType' => 'Virtual',
        'rating' => 4.7,
        'experience' => 15,
        'reviews' => 193,
        'priority' => false
    }
};

Set<String> doctorLastNames = new Set<String>();
for (Map<String, Object> doctorSeed : doctorSeeds) {
    doctorLastNames.add((String) doctorSeed.get('lastName'));
}

Map<String, Contact> doctorsByKey = new Map<String, Contact>();
for (Contact doctorRecord : [
    SELECT Id, FirstName, LastName, AccountId
    FROM Contact
    WHERE LastName IN :doctorLastNames
]) {
    doctorsByKey.put(
        String.valueOf(doctorRecord.AccountId) + '|' +
        String.valueOf(doctorRecord.FirstName) + '|' +
        String.valueOf(doctorRecord.LastName),
        doctorRecord
    );
}

List<Contact> doctorsToInsert = new List<Contact>();
List<Contact> doctorsToUpdate = new List<Contact>();

for (Map<String, Object> doctorSeed : doctorSeeds) {
    Account branchRecord = branchesByName.get((String) doctorSeed.get('branchName'));
    if (branchRecord == null) {
        continue;
    }

    String doctorKey =
        String.valueOf(branchRecord.Id) + '|' +
        String.valueOf(doctorSeed.get('firstName')) + '|' +
        String.valueOf(doctorSeed.get('lastName'));

    Contact existingDoctor = doctorsByKey.get(doctorKey);
    if (existingDoctor == null) {
        Contact newDoctor = new Contact(
            FirstName = (String) doctorSeed.get('firstName'),
            LastName = (String) doctorSeed.get('lastName'),
            AccountId = branchRecord.Id,
            Overview__c = (String) doctorSeed.get('overview'),
            Area_of_Expertise__c = (String) doctorSeed.get('expertise'),
            Awards_and_Regonitions__c = (String) doctorSeed.get('awards'),
            Available_Appointment_Type__c = (String) doctorSeed.get('appointmentType'),
            Doctor_Rating__c = Decimal.valueOf(String.valueOf(doctorSeed.get('rating'))),
            Years_of_Experience__c = Decimal.valueOf(String.valueOf(doctorSeed.get('experience'))),
            Review_Count__c = Integer.valueOf(String.valueOf(doctorSeed.get('reviews'))),
            Priority_Doctor__c = (Boolean) doctorSeed.get('priority')
        );
        doctorsToInsert.add(newDoctor);
    } else {
        existingDoctor.Overview__c = (String) doctorSeed.get('overview');
        existingDoctor.Area_of_Expertise__c = (String) doctorSeed.get('expertise');
        existingDoctor.Awards_and_Regonitions__c = (String) doctorSeed.get('awards');
        existingDoctor.Available_Appointment_Type__c = (String) doctorSeed.get('appointmentType');
        existingDoctor.Doctor_Rating__c = Decimal.valueOf(String.valueOf(doctorSeed.get('rating')));
        existingDoctor.Years_of_Experience__c = Decimal.valueOf(String.valueOf(doctorSeed.get('experience')));
        existingDoctor.Review_Count__c = Integer.valueOf(String.valueOf(doctorSeed.get('reviews')));
        existingDoctor.Priority_Doctor__c = (Boolean) doctorSeed.get('priority');
        doctorsToUpdate.add(existingDoctor);
    }
}

if (!doctorsToInsert.isEmpty()) {
    insert doctorsToInsert;
}

if (!doctorsToUpdate.isEmpty()) {
    update doctorsToUpdate;
}

doctorsByKey.clear();
for (Contact doctorRecord : [
    SELECT Id, FirstName, LastName, AccountId
    FROM Contact
    WHERE LastName IN :doctorLastNames
]) {
    doctorsByKey.put(
        String.valueOf(doctorRecord.AccountId) + '|' +
        String.valueOf(doctorRecord.FirstName) + '|' +
        String.valueOf(doctorRecord.LastName),
        doctorRecord
    );
}

Set<Id> branchIds = new Set<Id>();
for (Account branchRecord : branchesByName.values()) {
    branchIds.add(branchRecord.Id);
}

Map<String, HealthcareProviderSpecialty> mappingsByKey = new Map<String, HealthcareProviderSpecialty>();
for (HealthcareProviderSpecialty mappingRecord : [
    SELECT Id, AccountId, PractitionerId, SpecialtyId
    FROM HealthcareProviderSpecialty
    WHERE AccountId IN :branchIds
    AND PractitionerId != null
    AND SpecialtyId != null
]) {
    mappingsByKey.put(
        String.valueOf(mappingRecord.AccountId) + '|' +
        String.valueOf(mappingRecord.PractitionerId) + '|' +
        String.valueOf(mappingRecord.SpecialtyId),
        mappingRecord
    );
}

List<HealthcareProviderSpecialty> mappingsToInsert = new List<HealthcareProviderSpecialty>();
for (Map<String, Object> doctorSeed : doctorSeeds) {
    Account branchRecord = branchesByName.get((String) doctorSeed.get('branchName'));
    CareSpecialty specialtyRecord = specialtiesByName.get((String) doctorSeed.get('specialtyName'));
    String doctorKey =
        String.valueOf(branchRecord.Id) + '|' +
        String.valueOf(doctorSeed.get('firstName')) + '|' +
        String.valueOf(doctorSeed.get('lastName'));
    Contact doctorRecord = doctorsByKey.get(doctorKey);

    if (branchRecord == null || specialtyRecord == null || doctorRecord == null) {
        continue;
    }

    String mappingKey =
        String.valueOf(branchRecord.Id) + '|' +
        String.valueOf(doctorRecord.Id) + '|' +
        String.valueOf(specialtyRecord.Id);

    if (!mappingsByKey.containsKey(mappingKey)) {
        mappingsToInsert.add(new HealthcareProviderSpecialty(
            Name = branchRecord.Name + ' - ' + doctorRecord.LastName + ' - ' + specialtyRecord.Name,
            AccountId = branchRecord.Id,
            PractitionerId = doctorRecord.Id,
            SpecialtyId = specialtyRecord.Id
        ));
    }
}

if (!mappingsToInsert.isEmpty()) {
    insert mappingsToInsert;
}

List<HealthcareProviderSpecialty> apolloDoctorMappings = [
    SELECT
        PractitionerId,
        Practitioner.Name,
        Practitioner.AccountId,
        AccountId,
        Account.Name,
        Account.Parent.Name
    FROM HealthcareProviderSpecialty
    WHERE PractitionerId != null
    AND (
        Account.Parent.Name = :portalHospitalName
        OR Account.Parent.Name LIKE :('%Apollo%')
        OR Account.Name LIKE :('%Apollo%')
    )
];

Set<Id> apolloPractitionerIds = new Set<Id>();
for (HealthcareProviderSpecialty mappingRecord : apolloDoctorMappings) {
    apolloPractitionerIds.add(mappingRecord.PractitionerId);
}

List<Contact> apolloDoctors = new List<Contact>();
if (!apolloPractitionerIds.isEmpty()) {
    apolloDoctors = [
        SELECT
            Id,
            FirstName,
            LastName,
            Name,
            Doctor_Rating__c,
            Years_of_Experience__c,
            Review_Count__c,
            Priority_Doctor__c
        FROM Contact
        WHERE Id IN :apolloPractitionerIds
        ORDER BY Name
    ];
}

Integer rankingIndex = 0;
for (Contact doctorRecord : apolloDoctors) {
    Boolean isGayathriSatish =
        String.valueOf(doctorRecord.FirstName).toLowerCase().contains('gaya') &&
        String.valueOf(doctorRecord.LastName).toLowerCase().contains('satish');

    if (isGayathriSatish) {
        doctorRecord.Doctor_Rating__c = 5.0;
        doctorRecord.Years_of_Experience__c = 18;
        doctorRecord.Review_Count__c = 325;
        doctorRecord.Priority_Doctor__c = true;
        rankingIndex++;
        continue;
    }

    if (doctorRecord.Doctor_Rating__c == null) {
        doctorRecord.Doctor_Rating__c = Decimal.valueOf(String.valueOf(4.2 + (Math.mod(rankingIndex, 8) * 0.1)));
    }
    if (doctorRecord.Years_of_Experience__c == null) {
        doctorRecord.Years_of_Experience__c = Decimal.valueOf(String.valueOf(6 + Math.mod(rankingIndex * 3, 17)));
    }
    if (doctorRecord.Review_Count__c == null) {
        doctorRecord.Review_Count__c = 80 + (rankingIndex * 19);
    }
    rankingIndex++;
}

for (Contact doctorRecord : apolloDoctors) {
    Decimal doctorRating = doctorRecord.Doctor_Rating__c == null ? 0 : doctorRecord.Doctor_Rating__c;
    Decimal doctorExperience = doctorRecord.Years_of_Experience__c == null ? 0 : doctorRecord.Years_of_Experience__c;
    Integer doctorReviews = doctorRecord.Review_Count__c == null ? 0 : doctorRecord.Review_Count__c;
    Boolean isGayathriSatish =
        String.valueOf(doctorRecord.FirstName).toLowerCase().contains('gaya') &&
        String.valueOf(doctorRecord.LastName).toLowerCase().contains('satish');

    doctorRecord.Priority_Doctor__c =
        isGayathriSatish ||
        doctorRating >= 4.8 ||
        (doctorRating >= 4.7 && doctorExperience >= 12) ||
        (doctorRating >= 4.6 && doctorExperience >= 15) ||
        doctorReviews >= 220;
}

if (!apolloDoctors.isEmpty()) {
    update apolloDoctors;
}

System.debug(
    'Portal demo data ready for ' +
    portalHospitalName +
    ': branches=' + branchesByName.size() +
    ', doctors=' + doctorSeeds.size() +
    ', insertedMappings=' + mappingsToInsert.size() +
    ', rankedApolloDoctors=' + apolloDoctors.size()
);
