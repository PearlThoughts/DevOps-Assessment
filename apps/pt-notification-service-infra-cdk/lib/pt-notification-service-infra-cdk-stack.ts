import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';

import * as sqs from 'aws-cdk-lib/aws-sqs';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as apigateway from 'aws-cdk-lib/aws-apigateway';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as events from 'aws-cdk-lib/aws-events';
import * as targets from 'aws-cdk-lib/aws-events-targets';
import * as event_sources from 'aws-cdk-lib/aws-lambda-event-sources';

export class PtNotificationServiceInfraCdkStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const emailTransportationFunction = new lambda.Function(this, 'emailTransportationFunction', {
      runtime: lambda.Runtime.NODEJS_20_X,
      code: lambda.Code.fromAsset('lambda/emailTransportation'),
      handler: 'emailTransportation.handler',
    });

    emailTransportationFunction.addToRolePolicy(new iam.PolicyStatement({
      actions: [
        'events:PutEvents',
        'events:DescribeRule',
        'events:EnableRule',
        'events:DisableRule',
        'events:ListRuleNamesByTarget',
        'events:ListRules',
        'events:ListTargetsByRule',
        'events:PutRule',
        'events:PutTargets',
        'events:RemoveTargets',
        'events:TagResource',
        'events:UntagResource',
        'events:DeleteRule',
        'events:RemoveTargets'
      ],
      resources: ['*'],
    }));

    const api = new apigateway.LambdaRestApi(this, 'NotificationApi', {
      handler: emailTransportationFunction,
      proxy: false,
    });
        
    const apiResource = api.root.addResource('notification');
    apiResource.addMethod('POST');


    // Create an SQS queue
    const notificationQueue = new sqs.Queue(this, 'Notification-Queue-CDK', {
      visibilityTimeout: cdk.Duration.seconds(300)
    });

    // Create a custom event bus
    const eventBus = new events.EventBus(this, 'Notification-Bus-CDK', {
      eventBusName: 'Notification-Bus-CDK'
    });

    // Create an EventBridge rule
    const rule = new events.Rule(this, 'Notfication-Request-To-SQS', {
      eventBus: eventBus,
      eventPattern: {
        source: ['pt.notification'],
        detailType: ['send-email']
      },
    });

    // Add the SQS queue as the target for the rule
    rule.addTarget(new targets.SqsQueue(notificationQueue));

    const notificationProcessingFunction = new lambda.Function(this, 'Notification-Processing-Function', {
      runtime: lambda.Runtime.NODEJS_20_X,
      code: lambda.Code.fromAsset('lambda/notification-processing'),   // change for the processing function
      handler: 'notification-processing-dummy.handler',  // change for the processing function
    });

    notificationProcessingFunction.addToRolePolicy(new iam.PolicyStatement({
      actions: [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      resources: ['*'],
    }));

    notificationProcessingFunction.addEventSource(new event_sources.SqsEventSource(notificationQueue, {
      batchSize: 5, // Adjust as needed
    }));
  }  
}
