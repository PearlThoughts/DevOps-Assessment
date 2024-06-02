// index.js
const express = require('express');
const AWS = require('aws-sdk');
const app = express();
app.use(express.json());

AWS.config.update({ region: 'us-east-1' });
const sqs = new AWS.SQS();

const QUEUE_URL = 'https://sqs.us-east-1.amazonaws.com/your-account-id/your-queue-name';

app.post('/send', (req, res) => {
    const { email, subject, message } = req.body;

    const params = {
        MessageBody: JSON.stringify({ email, subject, message }),
        QueueUrl: QUEUE_URL
    };

    sqs.sendMessage(params, (err, data) => {
        if (err) {
            console.error('Error sending message to SQS:', err);
            res.status(500).send('Error sending message.');
        } else {
            res.status(200).send('Message queued successfully!');
        }
    });
});

app.listen(3000, () => {
    console.log('Notification API running on port 3000');
});
