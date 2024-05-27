import {
  EventBridgeClient,
  PutEventsCommand,
} from '@aws-sdk/client-eventbridge';

export const handler = async (event: any) => {
  console.log("Request data: ", event);

  const response = await putEvent(event);
  return {
    statusCode: 200,
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(response),
  };
};

const putEvent = async (emailRequest: any) => {
  if(!emailRequest.body) {
    return {
      statusCode: 400,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ message: "Bad Request: Invalid or missing body" }),
    };
  }
  const ebClient = new EventBridgeClient([
    {
      region: process.env.REGION,
      credentials: {
        accessKeyId: process.env.ACCESS_KEY,
        secretAccessKey: process.env.SECRET_ACCESS_KEY,
      },
    },
  ]);

  const params = {
    Entries: [
      {
        Detail: emailRequest.body,
        DetailType: 'send-email',
        Source: 'pt.notification',
        EventBusName: 'Notification-Bus-CDK',
      },
    ],
  };

  try {
    const eventData = await ebClient.send(new PutEventsCommand(params));
    console.log('Event data:', eventData);
    return eventData;
  } catch (err) {
    console.log('Error', err);
    return err;
  }
};
