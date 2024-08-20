// Load environment variables from .env file
require('dotenv').config();

const AWS = require('aws-sdk');

// Initialize AWS SQS and SES with environment variables
const sqs = new AWS.SQS({ region: process.env.AWS_REGION });
const ses = new AWS.SES({ region: process.env.AWS_REGION });

const queueUrl = process.env.SQS_QUEUE_URL;

// Function to send an email using AWS SES
function sendEmail(message) {
    const params = {
        Destination: {
            ToAddresses: ["thirg01@gmail.com"], // Change to your recipient's email address
        },
        Message: {
            Body: {
                Text: { Data: message },
            },
            Subject: { Data: "Notification" },
        },
        Source: "vidhya.inspire01@gmail.com", // Change to your verified sender email address
    };

    ses.sendEmail(params, (err, data) => {
        if (err) {
            console.error("Error sending email", err);
        } else {
            console.log("Email sent successfully", data);
        }
    });
}

// Function to poll SQS queue for messages and process them
async function pollQueue() {
    const params = {
        QueueUrl: queueUrl,
        MaxNumberOfMessages: 1,
        WaitTimeSeconds: 10,
    };

    try {
        const data = await sqs.receiveMessage(params).promise();
        if (data.Messages) {
            data.Messages.forEach((message) => {
                sendEmail(message.Body);

                // Delete the message after processing
                const deleteParams = {
                    QueueUrl: queueUrl,
                    ReceiptHandle: message.ReceiptHandle,
                };
                sqs.deleteMessage(deleteParams, (err) => {
                    if (err) {
                        console.error("Error deleting message", err);
                    } else {
                        console.log("Message deleted successfully");
                    }
                });
            });
        }
    } catch (err) {
        console.error("Error polling queue", err);
    }

    // Poll the queue continuously
    setTimeout(pollQueue, 1000);
}

// Start polling the SQS queue
pollQueue();
