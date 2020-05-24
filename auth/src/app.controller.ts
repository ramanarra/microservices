import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import { MessagePattern } from '@nestjs/microservices';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  
  @MessagePattern({ cmd: 'auth' })
  getAuth(data : {email : string, password : string}): string {
    return "Auth microservice is coming";
  }

  
}
