import { Controller, Post, Body, Logger } from '@nestjs/common';
import { NotificationService } from './notification.service';
import { NewEmail } from './dto/email.dto';

@Controller('notification')
export class NotificationController {
  private readonly logger = new Logger(NotificationController.name);

  constructor(private notificationService: NotificationService) {}

  @Post('/send-email')
  async sendEmail(@Body() requestBody: NewEmail) {
    try {
      this.notificationService.setEmailProviders(requestBody.primaryEmailProvider, requestBody.fallbackEmailProvider)
      const result = await this.notificationService.sendEmail(requestBody.emailRequest);
      this.logger.log(result);
      return result;
    } catch (error) {
      return error.message;
    }
  }
}
