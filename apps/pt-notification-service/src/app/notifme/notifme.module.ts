import { Module } from '@nestjs/common';
import { NotifmeService } from './notifme.service';

@Module({
  providers: [NotifmeService],
  exports: [NotifmeService]
})
export class NotifmeModule {}
