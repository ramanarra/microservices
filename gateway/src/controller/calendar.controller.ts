import {
    Controller,
    Logger,
    Get,
    UseGuards,
    Post,
    Query,
    Put,
    Param,
    UseFilters,
    Body,
    UsePipes,
    ValidationPipe,
    Request,
    ClassSerializerInterceptor,
    UnauthorizedException
} from '@nestjs/common';
import { CalendarService } from 'src/service/calendar.service';
import { ApiOkResponse, ApiUnauthorizedResponse, ApiBody, ApiBearerAuth, ApiCreatedResponse, ApiBadRequestResponse } from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';
import { Roles } from 'src/common/decorator/roles.decorator';
import { GetUser } from 'src/common/decorator/get-user.decorator';
import { GetAppointment } from 'src/common/decorator/get-appointment.decorator';
import { GetDoctor } from 'src/common/decorator/get-doctor.decorator';
import { UserDto, AppointmentDto , DoctorConfigPreConsultationDto, DoctorConfigCanReschDto,DoctorDto,DocConfigDto} from 'common-dto';
import { AllExceptionsFilter } from 'src/common/filter/all-exceptions.filter';
import { Strategy, ExtractJwt} from 'passport-jwt';

@Controller('api/calendar')
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
    @ApiOkResponse({description: 'request body example:   {"doctorKey": "Doc_5"}'})
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBody({ type: UserDto })
    doctorView(@Request() req, @Body() userDto : UserDto) {
        // check if doctor key and token doctor key are same
        if(req.user.doctor_key !== userDto.doctorKey){
            throw new UnauthorizedException("Invalid User")
        }
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

    @Post('doctorConfigUpdate')
    @ApiOkResponse({ description: 'requestBody example :   {\n' +
    '"doctorKey":"Doc_5",\n' +
    '"consultationCost": "123456" \n' +
    '"isPreconsultationAllowed": "123456" \n' +
    '"preconsultationHours": "123456" \n' +
    '"preconsultationMins": "123456" \n' +
    '"isPatientCancellationAllowed": "123456" \n' +
    '"cancellationDays": "123456" \n' +
    '"cancellationHours": "123456" \n' +
    '"cancellationMins": "123456" \n' +
    '"isPatientRescheduleAllowed": "123456" \n' +
    '"rescheduleDays": "123456" \n' +
    '"rescheduleHours": "123456" \n' +
    '"rescheduleMins": "123456" \n' +
    '"autoCancelDays": "123456" \n' +
    '"autoCancelHours": "123456" \n' +
    '"autoCancelMins": "123456" \n' +
    '}' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({ type: DocConfigDto })
    doctorConfigUpdate(@Request() req,@Body() docConfigDto : DocConfigDto) {
      this.logger.log(`Doctor config Update  Api -> Request data ${JSON.stringify(docConfigDto,req.user)}`);
      return this.calendarService.doctorConfigUpdate(docConfigDto,req.user);
    }




}
