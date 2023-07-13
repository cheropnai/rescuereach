const express = require('express');
const router = express.Router();
const twilio = require('twilio');
const admin = require('firebase-admin');
const serviceAccount = require('../rescuereach-firebase-adminsdk-key.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// Access your Firestore database
const db = admin.firestore();
const client = twilio('AC69585eb5729df78e0fb1211508a72668', '17097094953c94918c3140a01a5a4094');

router.post('/', (req, res) => {
  const userData = req.body;
  const { id, email, latitude, longitude, phoneNumber } = userData;

  // Construct the message to be spoken in the call
  const message = `RescueReach: User's phone number - ${phoneNumber}, Location - Latitude: ${latitude}, Longitude: ${longitude}`;

  // Make a call using Twilio
  client.calls
    .create({
      twiml: `<Response><Say>${message}</Say></Response>`,
      from: '+15416314286',  // Your Twilio phone number
      to: '+254708432460'  // Your own phone number
    })
    .then((call) => {
      console.log('Call initiated:', call.sid);

      // Save the call details to Firestore
      const callData = {
        victimid: id,
        victimemail: email,
        sid: call.sid,
        from: call.from,
        to: call.to,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        message: message, // Add the message to the call data
      };

      // Add the call to the "calls" collection in Firestore
      return db.collection('calls').add(callData);
    })
    .then((callDoc) => {
      console.log('Call saved to Firestore');

      // Create the report collection
      const reportData = {
        userId: id,
        case_narrative:'',
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        callId: callDoc.id,
      };

      // Add the report to the "reports" collection in Firestore
      return db.collection('reports').add(reportData);
    })
    .then(() => {
      console.log('Report created and saved to Firestore');
      res.send('User created, call initiated, and report saved');
    })
    .catch((err) => {
      console.error('Error initiating call:', err);
      res.status(500).send('Failed to create user, initiate call, and save report');
    });
});

module.exports = router;
