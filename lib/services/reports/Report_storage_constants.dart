import 'package:cloud_firestore/cloud_firestore.dart';

const ownerUserIdFieldName = 'userId';
const textFieldName = 'case_narrative';
const timeStampField = 'timestamp';

// Assuming timeStampField is a string representation of a timestamp
String timestampString = timeStampField;
Timestamp timeStamp = Timestamp.fromDate(DateTime.parse(timestampString));
