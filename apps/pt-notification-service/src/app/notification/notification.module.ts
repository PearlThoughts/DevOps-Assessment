import { Module } from '@nestjs/common';
import { NotificationService } from './notification.service';
import { NotificationController } from './notification.controller';
import { NotifmeModule } from '../notifme/notifme.module';

@Module({
  imports: [NotifmeModule],
  controllers: [NotificationController],
  providers: [NotificationService],
})
export class NotificationModule {}
