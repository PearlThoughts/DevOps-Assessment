import {
  EventBridgeClient,
  PutEventsCommand,
} from '@aws-sdk/client-eventbridge';

import { SQSEvent, SQSBatchResponse, SQSBatchItemFailure, SQSRecord } from 'aws-lambda';


export const handler = async (event: SQSEvent): Promise<SQSBatchResponse> => {
  console.log("SQS Events", event);
  const batchItemFailures: SQSBatchItemFailure[] = [];

    for (const record of event.Records) {
        try {
            await processMessageAsync(record);
        } catch (error) {
            batchItemFailures.push({ itemIdentifier: record.messageId });
        }
    }

    return {batchItemFailures: batchItemFailures};
};

async function processMessageAsync(record: SQSRecord): Promise<void> {
  console.log(`Record ${record.messageId}`, record);  
  if (record.body && record.body.includes("error")) {
      throw new Error('There is an error in the SQS Message.');
  }
  console.log(`Processed message ${record.body}`);
}