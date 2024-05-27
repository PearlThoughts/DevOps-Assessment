import {
  EventBridgeClient,
  PutEventsCommand,
} from '@aws-sdk/client-eventbridge';

export const handler = async (event: any) => {
  console.log(event);

  const response = await putEvent(event);
  return response;
};

const putEvent = async (emailRequest: any) => {
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
        Detail: JSON.stringify(emailRequest),
        DetailType: 'send-email',
        Source: 'pt.notification',
        EventBusName: 'Notification-Bus-CDK',
      },
    ],
  };

  try {
    const eventData = await ebClient.send(new PutEventsCommand(params));
    console.log('Success, event sent; requestID:', eventData);
    return eventData;
  } catch (err) {
    console.log('Error', err);
    return err;
  }
};
