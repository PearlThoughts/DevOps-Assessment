const AWS = require('aws-sdk');
const nodemailer = require('nodemailer');

const sqs = new AWS.SQS({ region: 'ap-south-1' });

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.USER,
        pass: process.env.PASSWORD
    }
});

async function sendEmail(emailDetails) {
    try {
        await transporter.sendMail({
            from: emailDetails.from,
            to: emailDetails.to,
            subject: emailDetails.subject,
            html: emailDetails.html
        });
        console.log('Email sent successfully');
    } catch (error) {
        console.error('Error sending email:', error);
    }
}

async function processQueueMessages() {
    const params = {
        QueueUrl: process.env.QUEUE_URL,
        MaxNumberOfMessages: 1,
        WaitTimeSeconds: 10
    };

    try {
        const data = await sqs.receiveMessage(params).promise();

        if (data.Messages) {
            const message = data.Messages[0];
            const emailDetails = JSON.parse(message.Body);

            await sendEmail(emailDetails);

            // Delete message from the queue after processing
            await sqs.deleteMessage({
                QueueUrl: process.env.QUEUE_URL,
                ReceiptHandle: message.ReceiptHandle
            }).promise();

            console.log('Message processed and deleted from the queue');
        } else {
            console.log('No messages to process');
        }
    } catch (error) {
        console.error('Error processing messages from SQS:', error);
    }
}

// Continuously poll the SQS queue for new messages
setInterval(processQueueMessages, 5000);

