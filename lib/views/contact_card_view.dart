import 'package:flutter/material.dart';

class EmergencyResponsePage extends StatelessWidget {
  final List<EmergencyContact> emergencyContacts = [
    EmergencyContact(
      name: 'Kenya Red Cross Society',
      telephone: '+254-20-3950000',
      email: 'info@kenyaredcross.org',
    ),
    EmergencyContact(
      name: 'St. John Ambulance',
      telephone: '+254-20-2222181',
      email: 'info@stjohnkenya.org',
    ),
    EmergencyContact(
      name: 'National Police Service',
      telephone: '999',
      email: 'nps@nationalpolice.go.ke',
    ),
    // Add more emergency contacts here
  ];

  final List<HumanRightsGroup> humanRightsGroups = [
    HumanRightsGroup(
      name: 'Kenya Human Rights Commission',
      telephone: '+254-20-2714673',
      email: 'info@khrc.or.ke',
    ),
    HumanRightsGroup(
      name: 'Haki Africa',
      telephone: '+254-41-2319172',
      email: 'info@hakiafrica.or.ke',
    ),
    HumanRightsGroup(
      name: 'Amnesty International Kenya',
      telephone: '+254-20-2725333',
      email: 'info@amnestykenya.org',
    ),
    // Add more human rights groups here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Response'),
        backgroundColor: const Color.fromARGB(255, 191, 166, 233),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          const Text(
            'Emergency Response Teams',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          for (EmergencyContact contact in emergencyContacts)
            _contactCard(contact: contact),
          SizedBox(height: 16.0),
          const Text(
            'Human Rights Activist Groups',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          for (HumanRightsGroup group in humanRightsGroups)
            _contactCard(contact: group),
        ],
      ),
    );
  }
}

class _contactCard extends StatelessWidget {
  final dynamic contact;

  const _contactCard({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(contact.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Telephone: ${contact.telephone}'),
            Text('Email: ${contact.email}'),
          ],
        ),
      ),
    );
  }
}

class EmergencyContact {
  final String name;
  final String telephone;
  final String email;

  EmergencyContact({
    required this.name,
    required this.telephone,
    required this.email,
  });
}

class HumanRightsGroup {
  final String name;
  final String telephone;
  final String email;

  HumanRightsGroup({
    required this.name,
    required this.telephone,
    required this.email,
  });
}
