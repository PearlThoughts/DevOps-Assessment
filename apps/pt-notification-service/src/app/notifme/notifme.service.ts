import { Injectable, Logger } from '@nestjs/common';
import NotifmeSdk from 'notifme-sdk';
import { EmailRequestType } from 'notifme-sdk';
import { EmailProvider } from '../interfaces/providers';

@Injectable()
export class NotifmeService {
  private notifmeSdk: NotifmeSdk;
  private readonly logger = new Logger(NotifmeService.name);

  // constructor(private configService: ConfigService) {
  //   this.notifmeSdk = new NotifmeSdk({
  //     channels: {
  //       email: {
  //         providers: [
  //           {
  //             type: 'ses',
  //             region: this.configService.get('aws.region'),
  //             accessKeyId: this.configService.get('aws.access_key'),
  //             secretAccessKey: this.configService.get('aws.secret_access_key'),
  //             // sessionToken: 'xxxxx', // optional
  //           },
  //           {
  //             type: 'mailgun',
  //             apiKey: this.configService.get('mailgun.apiKey'),
  //             domainName: this.configService.get('mailgun.domainName'),
  //           },
  //         ],
  //         multiProviderStrategy: this.customRetryFallbackStrategy,
  //       },
  //     },
  //   });
  // }

  // constructor(
  //   primaryEmailProvider: EmailProvider,
  //   fallbackEmailProvider: EmailProvider,
  // ) {
  //   this.notifmeSdk = new NotifmeSdk({
  //     channels: {
  //       email: {
  //         providers: [primaryEmailProvider, fallbackEmailProvider],
  //         multiProviderStrategy: this.customRetryFallbackStrategy,
  //       },
  //     },
  //   });
  // }

  setEmailProviders(
    primaryEmailProvider: EmailProvider,
    fallbackEmailProvider: EmailProvider,
  ) {
    this.notifmeSdk = new NotifmeSdk({
      channels: {
        email: {
          providers: [primaryEmailProvider, fallbackEmailProvider],
          multiProviderStrategy: this.customRetryFallbackStrategy,
        },
      },
    });
  }

  async sendEmail(emailRequest: EmailRequestType) {
    try {
      const result = await this.notifmeSdk.send({ email: emailRequest });
      return result;
    } catch (error) {
      this.logger.error(error);
      throw error;
    }
  }

  customRetryFallbackStrategy = (providers) => async (request) => {
    if (providers.length >= 2) {
      const primaryEmailServiceProvider = providers[0];
      const fallbackEmailServiceProvider = providers[1];
      let numberOfTries = 2;

      while (numberOfTries > 0) {
        try {
          const id = await primaryEmailServiceProvider.send(request);
          return { id, providerId: primaryEmailServiceProvider.id };
        } catch (error) {
          this.logger.error(error);
          numberOfTries -= 1;
        }
      }

      try {
        const id = await fallbackEmailServiceProvider.send(request);
        return { id, providerId: fallbackEmailServiceProvider.id };
      } catch (error) {
        this.logger.error(error);
        throw error;
      }
    }
  };
}
