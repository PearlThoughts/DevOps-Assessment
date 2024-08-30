const express = require('express');
const bodyParser = require('body-parser');
const AWS = require('aws-sdk');

const app = express();
app.use(bodyParser.json());

const sqs = new AWS.SQS({ region: 'ap-south-1' });

app.post('/send-notification', async (req, res) => {
    const emailDetails = req.body;

    const params = {
        MessageBody: JSON.stringify(emailDetails),
        QueueUrl: process.env.QUEUE_URL,
        MessageGroupId: 'emailGroup'
    };

    try {
        const result = await sqs.sendMessage(params).promise();
        console.log('Notification queued, MessageId:', result.MessageId);
        res.status(200).send({ messageId: result.MessageId });
    } catch (error) {
        console.error('Failed to queue notification:', error);
        res.status(500).send({ error: 'Failed to queue notification' });
    }
});

const PORT = process.env.PORT;
app.listen(PORT, () => {
    console.log(`Notification API is listening on port ${PORT}`);
});

