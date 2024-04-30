import { Module } from '@nestjs/common';
import { NotifmeService } from './notifme.service';
import { NotifmeController } from './notifme.controller';

@Module({
  providers: [NotifmeService],
  controllers: [NotifmeController]
})
export class NotifmeModule {}
