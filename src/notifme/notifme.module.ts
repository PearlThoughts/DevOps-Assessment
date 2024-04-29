import { Module } from '@nestjs/common';
import { NotifmeService } from './services/notifme/notifme.service';
import { NotifmeController } from './controllers/notifme/notifme.controller';

@Module({
  providers: [NotifmeService],
  controllers: [NotifmeController]
})
export class NotifmeModule {}
