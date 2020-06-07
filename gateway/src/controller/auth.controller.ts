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

    constructor( private readonly userService : UserService){}

    // @Post('signUp')
    // @ApiResponse({ status: 201, description: 'User record has been successfully created', type: UserDto })
    // @ApiResponse({ status: 403, description: 'Email already exists'})
    // signUp(@Body() userDto : UserDto) {
    //   this.logger.log(`Sign Up Api -> Request data ${JSON.stringify(userDto)}`);
    //   return this.userService.signUp(userDto);
    // }

    // @Post('login')
    // @ApiOkResponse({ description: 'User Login' })
    // @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    // @ApiBody({ type: UserDto })
    // login(@Body() loginDto : UserDto) {
    //   this.logger.log(`Login  Api -> Request data ${JSON.stringify(loginDto)}`);
    //   return this.userService.validateEmailPassword(loginDto);
    // }

    @Post('doctorLogin')
    @ApiOkResponse({ description: 'Doctor Login' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBody({ type: DoctorDto })
    doctorLogin(@Body() doctorDto : DoctorDto) {
      this.logger.log(`Doctor Login  Api -> Request data ${JSON.stringify(doctorDto)}`);
      return this.userService.doctorLogin(doctorDto);
    }

    // @Get('doctor_List')
    // @ApiOkResponse({ description: 'Doctor List' })
    // @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    // doctorList(@Query('id') id: number) {
    //   this.logger.log(`Doctor Login  Api -> Request data ${JSON.stringify(id)}`);
    //   return this.userService.doctorList(id);
    // }

    // @Post('doctorView')
    // @ApiOkResponse({ description: 'Doctor View' })
    // @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    // @ApiBody({ type: DoctorDto })
    // doctorView(@Body() doctorDto : DoctorDto) {
    //   this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(doctorDto)}`);
    //   return this.userService.doctorView(doctorDto);
    // }

    
    // @Put('fee&consultaion')
    // @ApiOkResponse({ description: 'Doctor fee and consultation update' })
    // updateFee(@Param('id') id: string, @Body() feeDto: FeeDto) {
    // return `This action updates a #${id} cat`;
    // }


    // @Post('doctor_Login')
    // @ApiOkResponse({ description: 'Doctor Login' })
    // @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    // @ApiBody({ type: DoctorDto })
    // doctor_Login(@Body() doctorDto : DoctorDto) {
    //   this.logger.log(`Doctor Login  Api -> Request data ${JSON.stringify(doctorDto)}`);
    //   return this.userService.doctor_Login(doctorDto);
    // }

    
    
}
