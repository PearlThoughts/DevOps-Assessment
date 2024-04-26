import { Controller, Post } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { EmailService } from 'src/notification/services/email/email.service';

@Controller('email')
export class EmailController {

    constructor(private configService: ConfigService, private emailService: EmailService) {}

    @Post('/send-email')
    async sendMessage() {
        try {
            // const successEmail = await this.emailService.sendEmail('apschauhan181@gmail.com', 'apschauhan181@gmail.com', "Hello from SES");
            // return `Eamil sent: ${successEmail.MessageId}`;

            return await this.emailService.sendNotification('vanshitarohela@gmail.com', 'apschauhan181@gmail.com', "Hello from notifmeSdk");
        } catch (error) {
            return error.message;       
        }
    }
}