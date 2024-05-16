import { Body, Controller, HttpException, Post, RawBodyRequest, Req } from '@nestjs/common';
import { NotifmeService } from 'src/notifme/notifme.service';

@Controller('notifme')
export class NotifmeController {
    constructor(private notifmeService: NotifmeService) {}

    @Post('/send-email')
    async sendMessage(@Req() req: RawBodyRequest<Request>, @Body() requestBody) {
        try {
            const body = requestBody;
            if(!(body.from && body.to && body.subject && body.html)) {
                throw new HttpException("Missing 'from', 'to', 'subject' or 'html' in request body", 401);
            }
            const emailRequest = {
                from: body.from,
                to: body.to,
                subject: body.subject,
                html: body.html,
            };
            return await this.notifmeService.sendEmail(emailRequest);
        } catch (error) {
            return error.message;       
        }
    }
}
