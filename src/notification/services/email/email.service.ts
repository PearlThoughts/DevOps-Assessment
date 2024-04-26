// import { SESv2, SendEmailCommandInput } from '@aws-sdk/client-sesv2';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import NotifmeSdk from 'notifme-sdk';
// import * as template from '../../../layout/index.html';

@Injectable()
export class EmailService {
  // AWS_SES: SESv2;
  notifmeSES: NotifmeSdk;

  constructor(private configService: ConfigService) {
    // this.AWS_SES = new SESv2({
    //   credentials: {
    //     accessKeyId: this.configService.get('aws.access_key'),
    //     secretAccessKey: this.configService.get('aws.secret_access_key'),
    //   },
    //   region: this.configService.get('aws.region'),
    // });

    this.notifmeSES = new NotifmeSdk({
      channels: {
        email: {
          providers: [
            {
              type: 'ses',
              region: this.configService.get('aws.region'),
              accessKeyId: this.configService.get('aws.access_key'),
              secretAccessKey: this.configService.get('aws.secret_access_key'),
              // sessionToken: 'xxxxx', // optional
            },
          ],
        },
      },
    });
  }

  async sendEmail(senderEmail: string, recipientEmail: string, body: string) {
    // params.Destination.ToAddresses = [recipientEmail];
    // params.FromEmailAddress = senderEmail;
    // params.Content.Simple.Body.Text.Data = body;
    // params.Content.Simple.Subject.Data = body;

    // params.Destination.BccAddresses = [];
    // params.Destination.CcAddresses = [];

    // try {
    //   const res = await this.AWS_SES.sendEmail(params);
    //   console.log(res, res.MessageId);
    //   return res;
    // } catch (error) {
    //   console.error(error);
    //   throw new Error(`Unable to send mail: ${error.message}`);
    // }
  }

  async sendNotification(
    senderEmail: string,
    recipientEmail: string,
    body: string,
  ) {
    return await this.notifmeSES
      .send({
        email: {
          from: senderEmail,
          to: recipientEmail,
          // text: body,
          subject: body,
          html: '<h1>Hello from notifmeSDK</h1>'
        },
      })
      // .then(console.log);
  }
}

// const params: SendEmailCommandInput = {
//   Destination: {
//     /* required */
//     CcAddresses: [
//       'EMAIL_ADDRESS',
//       /* more items */
//     ],
//     ToAddresses: [
//       'EMAIL_ADDRESS',
//       /* more items */
//     ],
//   },
//   Content: {
//     Simple: {
//       Subject: {
//         Charset: 'UTF-8',
//         Data: 'Test email',
//       },
//       Body: {
//         Text: {
//           Charset: 'UTF-8',
//           Data: '',
//         },
//       },
//     },
//   },
//   FromEmailAddress: '',
// };
