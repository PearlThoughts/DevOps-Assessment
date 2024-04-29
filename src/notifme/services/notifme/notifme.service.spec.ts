import { Test, TestingModule } from '@nestjs/testing';
import { NotifmeService } from './notifme.service';

describe('NotifmeService', () => {
  let service: NotifmeService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [NotifmeService],
    }).compile();

    service = module.get<NotifmeService>(NotifmeService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
