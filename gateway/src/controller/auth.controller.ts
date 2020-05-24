import { Controller, Body, Post, Get, UseFilters, Logger } from '@nestjs/common';
import { UserService } from 'src/service/user.service';
import { UserDto, LoginDto } from 'src/dto/user.dto';
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

    constructor( private readonly userService : UserService){}

    @Post('signUp')
    @ApiResponse({ status: 201, description: 'User record has been successfully created', type: UserDto })
    @ApiResponse({ status: 403, description: 'Email already exists'})
    signUp(@Body() userDto : UserDto) {
      this.logger.log(`Sign Up Api -> Request data ${JSON.stringify(userDto)}`);
      return this.userService.signUp(userDto);
    }

    @Post('login')
    @ApiOkResponse({ description: 'User Login' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBody({ type: UserDto })
    login(@Body() loginDto : LoginDto) {
      this.logger.log(`Login  Api -> Request data ${JSON.stringify(loginDto)}`);
      return this.userService.validateEmailPassword(loginDto);
    }

    
}
