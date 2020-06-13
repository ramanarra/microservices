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


    @Post('createAppointment')
    @ApiOkResponse({ description: 'Create Appointment' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBadRequestResponse({description:'Invalid Schema'})
    @ApiBody({ type: AppointmentDto })
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @Roles('admin')
    createAppointment(@Request() req, @Body() appointmentDto : AppointmentDto) {
      this.logger.log(`Appointment  Api -> Request data ${JSON.stringify(appointmentDto,req.user)}`);
      return this.calendarService.createAppointment(appointmentDto,req.user);
    }

    @Get('doctor_List')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({ description: 'Doctor List' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    doctorList(@Request() req) {
      return this.calendarService.doctorList(req.user.role,req.user.doctor_key);
    }


    @Post('doctorSettingsPersonalView')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({ description: 'Doctor View' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    doctorView(@Request() req) {
      this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(req.user.doctor_key)}`);
      return this.calendarService.doctorView(req.user.doctor_key);
    }

    @Post('doctorConfigCostAndPreconsultationUpdate')
    @ApiOkResponse({ description: 'Cost &  Preconsultation Update' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({ type: DoctorConfigPreConsultationDto })
    doctor_Login(@Request() req,@Body() doctorConfigPreConsultationDto : DoctorConfigPreConsultationDto) {
      this.logger.log(`Doctor Login  Api -> Request data ${JSON.stringify(doctorConfigPreConsultationDto,req.user)}`);
      return this.calendarService.doctorPreconsultation(doctorConfigPreConsultationDto,req.user);
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
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({ type: DoctorConfigCanReschDto })
    doctorCanReschEdit(@Request() req,@Body() doctorConfigCanReschDto : DoctorConfigCanReschDto) {
      this.logger.log(`Doctor config cancel/reschedule  Api -> Request data ${JSON.stringify(doctorConfigCanReschDto,req.user)}`);
      return this.calendarService.doctorCanReschEdit(doctorConfigCanReschDto,req.user);
    }


    @Get('doctorConfigCancelRescheduleView')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({ description: 'Cancel &  Reschedule View' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    doctorCanReschView(@Request() req) {
      this.logger.log(`Doctor config view  Api -> Request data ${JSON.stringify(req.user.doctor_key)}`);
      return this.calendarService.doctorCanReschView(req.user.doctor_key);
    }

    @Get('appointmentsView')
    @ApiOkResponse({ description: 'Appointment List' })
     @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @Roles('doctor', 'patient')
    getAppointmentList(@Request() req) {
      this.logger.log(`Appointments are view Api -> Request data ${JSON.stringify(req.user.doctor_key)}`);
      return this.calendarService.appointmentList(req.user.doctor_key);  
    }




}
