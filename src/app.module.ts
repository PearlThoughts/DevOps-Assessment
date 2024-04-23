import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';

import { AppController } from './app.controller';
import { AppService } from './app.service';
import { NotificationModule } from './notification/notification.module';
import environment from './environments/environment';

@Module({
  imports: [ConfigModule.forRoot({
    load: [environment],
    isGlobal: true,
  }), NotificationModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule { }