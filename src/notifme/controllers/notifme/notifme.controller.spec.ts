import { Test, TestingModule } from '@nestjs/testing';
import { NotifmeController } from './notifme.controller';

describe('NotifmeController', () => {
  let controller: NotifmeController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [NotifmeController],
    }).compile();

    controller = module.get<NotifmeController>(NotifmeController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
