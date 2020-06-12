import { Controller, Logger, Get, UseGuards, Post,Query,Put,Param, UseFilters, Body, UsePipes, ValidationPipe,Request, ClassSerializerInterceptor } from '@nestjs/common';
import { CalendarService } from 'src/service/calendar.service';
import { ApiOkResponse, ApiUnauthorizedResponse, ApiBody, ApiBearerAuth, ApiCreatedResponse, ApiBadRequestResponse } from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';
import { Roles } from 'src/common/decorator/roles.decorator';
import { GetUser } from 'src/common/decorator/get-user.decorator';
import { GetAppointment } from 'src/common/decorator/get-appointment.decorator';
import { GetDoctor } from 'src/common/decorator/get-doctor.decorator';
import { UserDto, AppointmentDto , DoctorConfigPreConsultationDto, DoctorConfigCanReschDto,DoctorDto} from 'common-dto';
import { AllExceptionsFilter } from 'src/common/filter/all-exceptions.filter';
import { Strategy, ExtractJwt} from 'passport-jwt';

@Controller('calendar')
@UsePipes(new ValidationPipe({ transform: true }))
@UseFilters(AllExceptionsFilter)
export class CalendarController {

    private logger = new Logger('CalendarController');

    constructor( private readonly calendarService : CalendarService){}

    // @Get('appointmentsView')
    // @ApiOkResponse({ description: 'Appointment List' })
    //  @ApiBearerAuth('JWT')
    // getAppointmentList(@GetAppointment() appInfo : AppointmentDto) {
    //   this.logger.log(`Appointments view Api -> Request data ${JSON.stringify(appInfo)}`);

    //   var opts = {
    //     jwtFromRequest : ExtractJwt.fromAuthHeaderAsBearerToken(),
    //     secretOrKey : 'secret'
    // }
    // var JwtStrategy = require('passport-jwt').Strategy,
    //     ExtractJwt = require('passport-jwt').ExtractJwt;
    // const decodedJwt =  new JwtStrategy(opts);
    // this.logger.log(`Appointments view Api -> Request data ${JSON.stringify(decodedJwt)}`);
    //   return this.calendarService.appointmentList();
  
    // }


    @Post('createAppointment')
    @ApiOkResponse({ description: 'Create Appointment' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBadRequestResponse({description:'Invalid Schema'})
    @ApiBody({ type: AppointmentDto })
    @ApiBearerAuth('JWT')
 // @UseGuards(AuthGuard())
    @Roles('admin')
    createAppointment(@Body() appointmentDto : AppointmentDto) {
      this.logger.log(`Appointment  Api -> Request data ${JSON.stringify(appointmentDto)}`);
      return this.calendarService.createAppointment(appointmentDto);
    }

    @Get('doctor_List')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({ description: 'Doctor List' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    //@UseInterceptors(ClassSerializerInterceptor)
    doctorList(@Request() req) {
      return this.calendarService.doctorList(req.user.role,req.user.doctor_key);
    }


    @Post('doctorSettingsPersonalView')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({ description: 'Doctor View' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    //@ApiBody({ type: DoctorDto })
    doctorView(@Request() req) {
      this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(req.user.doctor_key)}`);
      return this.calendarService.doctorView(req.user.doctor_key);
    }

    @Post('doctorConfigCostAndPreconsultationUpdate')
    @ApiOkResponse({ description: 'Cost &  Preconsultation Update' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBody({ type: DoctorConfigPreConsultationDto })
    doctor_Login(@Body() doctorConfigPreConsultationDto : DoctorConfigPreConsultationDto) {
      this.logger.log(`Doctor Login  Api -> Request data ${JSON.stringify(doctorConfigPreConsultationDto)}`);
      return this.calendarService.doctorPreconsultation(doctorConfigPreConsultationDto);
    }

    @Get('HospitalDetails')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({ description: 'Hospital Details' })
    hospitalDetails(@Request() req) {
      this.logger.log(`Doctor List  Api -> Request data ${JSON.stringify(req.user.account_key)}`);
      return this.calendarService.hospitalDetails(req.user.account_key);
    }

    @Post('doctorConfigCancelRescheduleEdit')
    @ApiOkResponse({ description: 'Cancel &  Reschedule Update' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBody({ type: DoctorConfigCanReschDto })
    doctorCanReschEdit(@Body() doctorConfigCanReschDto : DoctorConfigCanReschDto) {
      this.logger.log(`Doctor config cancel/reschedule  Api -> Request data ${JSON.stringify(doctorConfigCanReschDto)}`);
      return this.calendarService.doctorCanReschEdit(doctorConfigCanReschDto);
    }


    @Get('doctorConfigCancelRescheduleView')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({ description: 'Cancel &  Reschedule View' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    //@UseInterceptors(ClassSerializerInterceptor)
    doctorCanReschView(@Request() req) {
      this.logger.log(`Doctor config view  Api -> Request data ${JSON.stringify(req.user.doctor_key)}`);
      return this.calendarService.doctorCanReschView(req.user.doctor_key);
    }

    @Get('appointmentsView')
    @ApiOkResponse({ description: 'Appointment List' })
     @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @Roles('doctor', 'patient')
  // getAppointmentList1(@GetUser() userInfo : UserDto) {
    getAppointmentList1(@Request() req) {
   // getAppointmentList(@GetAppointment() appInfo : AppointmentDto) {
      this.logger.log(`Appointments are view Api -> Request data ${JSON.stringify(req.user.doctor_key)}`);
      return this.calendarService.appointmentList1(req.user.doctor_key);
  
    }




}
