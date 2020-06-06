import { Controller, Get, UseGuards, Req } from '@nestjs/common';
import { AppService } from './app.service';
import { AuthGuard } from '@nestjs/passport';
import { GetUser } from './common/decorator/get-user.decorator';
import { UserDto } from 'common-dto';

@Controller('')
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  @UseGuards(AuthGuard())
  getHello(@GetUser() userInfo : UserDto): string {
    return this.appService.getHello();
  }
}
