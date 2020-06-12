import { Controller, Body, Param, Query, Post, Get, Put, UseFilters, Logger } from '@nestjs/common';
import { UserService } from 'src/service/user.service';
import { UserDto, DoctorDto } from 'common-dto';
import { AllExceptionsFilter } from 'src/common/filter/all-exceptions.filter';
import {
  ApiCreatedResponse,
  ApiOkResponse,
  ApiUnauthorizedResponse,
  ApiBody,
  ApiResponse
} from '@nestjs/swagger';

@Controller('auth')
@UseFilters(AllExceptionsFilter)
export class AuthController {

  private logger = new Logger('AuthController');

  constructor(private readonly userService: UserService) { }

    @Post('doctorLogin')
    @ApiOkResponse({ description: 'Doctor Login' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBody({ type: UserDto })
    doctorsLogin(@Body() userDto : UserDto) {
      this.logger.log(`Doctor Login  Api -> Request data ${JSON.stringify(userDto)}`);
      return this.userService.doctorsLogin(userDto);
    }


}
