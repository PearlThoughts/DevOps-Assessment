// Load environment variables from .env file
require('dotenv').config();

const express = require('express');
const AWS = require('aws-sdk');

// Initialize the app and AWS SQS with environment variables
const app = express();
app.use(express.json());

const sqs = new AWS.SQS({ region: process.env.AWS_REGION });
const queueUrl = process.env.SQS_QUEUE_URL;
// Health check endpoint
app.get('/health', (req, res) => {
    res.status(200).send('OK');
});

// API to receive notification requests
app.post('/send-notification', (req, res) => {
    const { message } = req.body;

    const params = {
        MessageBody: JSON.stringify({ message }),
        QueueUrl: queueUrl
    };

    sqs.sendMessage(params, (err, data) => {
        if (err) {
            console.error("Error sending message", err);
            return res.status(500).send("Failed to send message");
        }
        res.status(200).send("Notification queued successfully");
    });
});

app.listen(3000, () => {
    console.log(`Notification API listening on port 3000`);
});
