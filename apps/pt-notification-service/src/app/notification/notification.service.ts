import { EmailProvider } from '../interfaces/providers';
import { EmailRequestType } from 'notifme-sdk';
import { Injectable, Logger } from '@nestjs/common';
import { NotifmeService } from '../notifme/notifme.service';

@Injectable()
export class NotificationService {
  private readonly logger = new Logger(NotificationService.name);

  constructor(private notifmeService: NotifmeService) {}

  setEmailProviders(primaryEmailProvider: EmailProvider, fallbackEmailProvider: EmailProvider) {
    this.notifmeService.setEmailProviders(primaryEmailProvider, fallbackEmailProvider);
  }

  async sendEmail(emailRequest: EmailRequestType) {
    try {
      const result = await this.notifmeService.sendEmail(emailRequest);
      return result;
    } catch (error) {
      this.logger.error(error);
      throw error;
    }
  }
}