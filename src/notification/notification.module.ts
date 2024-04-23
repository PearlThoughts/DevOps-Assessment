import { Module } from '@nestjs/common';
import { EmailController } from './controllers/email/email.controller';
import { EmailService } from './services/email/email.service';

@Module({
  controllers: [EmailController],
  providers: [EmailService]
})
export class NotificationModule {}
