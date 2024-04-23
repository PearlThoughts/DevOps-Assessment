import { SESv2, SendEmailCommandInput } from '@aws-sdk/client-sesv2';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class EmailService {
  AWS_SES: SESv2;

  constructor(private configService: ConfigService) {
    this.AWS_SES = new SESv2({
      credentials: {
        accessKeyId: this.configService.get('aws.access_key'),
        secretAccessKey: this.configService.get('aws.secret_access_key'),
      },
      region: this.configService.get('aws.region'),
    });
  }

  async sendEmail(senderEmail: string, recipientEmail: string, body: string) {
    params.Destination.ToAddresses = [recipientEmail];
    params.FromEmailAddress = senderEmail;
    params.Content.Simple.Body.Text.Data = body;
    params.Content.Simple.Subject.Data = body;

    params.Destination.BccAddresses = [];
    params.Destination.CcAddresses = [];

    try {
      const res = await this.AWS_SES.sendEmail(params);
      console.log(res, res.MessageId);
      return res;
    } catch (error) {
      console.error(error);
      throw new Error(`Unable to send mail: ${error.message}`)
    }
  }
}

const params: SendEmailCommandInput = {
  Destination: {
    /* required */
    CcAddresses: [
      'EMAIL_ADDRESS',
      /* more items */
    ],
    ToAddresses: [
      'EMAIL_ADDRESS',
      /* more items */
    ],
  },
  Content: {
    Simple: {
      Subject: {
        Charset: 'UTF-8',
        Data: 'Test email',
      },
      Body: {
        Text: {
          Charset: 'UTF-8',
          Data: '',
        },
      },
    },
  },
  FromEmailAddress: '',
};
