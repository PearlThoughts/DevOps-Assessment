// worker.js
const AWS = require('aws-sdk');
const nodemailer = require('nodemailer');

AWS.config.update({ region: 'us-east-1' });
const sqs = new AWS.SQS();
const QUEUE_URL = 'https://sqs.us-east-1.amazonaws.com/your-account-id/your-queue-name';

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'your-email@gmail.com',
        pass: 'your-email-password'
    }
});

function processMessages() {
    const params = {
        QueueUrl: QUEUE_URL,
        MaxNumberOfMessages: 10,
        VisibilityTimeout: 20,
        WaitTimeSeconds: 0
    };

    sqs.receiveMessage(params, (err, data) => {
        if (err) {
            console.error('Error receiving message from SQS:', err);
        } else if (data.Messages) {
            data.Messages.forEach((message) => {
                const { email, subject, text } = JSON.parse(message.Body);

                const mailOptions = {
                    from: 'your-email@gmail.com',
                    to: email,
                    subject: subject,
                    text: text
                };

                transporter.sendMail(mailOptions, (err, info) => {
                    if (err) {
                        console.error('Error sending email:', err);
                    } else {
                        console.log('Email sent:', info.response);
                        const deleteParams = {
                            QueueUrl: QUEUE_URL,
                            ReceiptHandle: message.ReceiptHandle
                        };
                        sqs.deleteMessage(deleteParams, (err) => {
                            if (err) {
                                console.error('Error deleting message:', err);
                            } else {
                                console.log('Message deleted');
                            }
                        });
                    }
                });
            });
        }
    });
}

setInterval(processMessages, 10000);
