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
    UnauthorizedException, HttpStatus
} from '@nestjs/common';
import {CalendarService} from 'src/service/calendar.service';
import {
    ApiOkResponse,
    ApiUnauthorizedResponse,
    ApiBody,
    ApiBearerAuth,
    ApiCreatedResponse,
    ApiBadRequestResponse
} from '@nestjs/swagger';
import {AuthGuard} from '@nestjs/passport';
import {Roles} from 'src/common/decorator/roles.decorator';
import {GetUser} from 'src/common/decorator/get-user.decorator';
import {GetAppointment} from 'src/common/decorator/get-appointment.decorator';
import {GetDoctor} from 'src/common/decorator/get-doctor.decorator';
import {
    UserDto,
    AppointmentDto,
    DoctorConfigPreConsultationDto,
    DoctorConfigCanReschDto,
    DoctorDto,
    DocConfigDto,
    WorkScheduleDto,
    PatientDto
} from 'common-dto';
import {AllExceptionsFilter} from 'src/common/filter/all-exceptions.filter';
import {Strategy, ExtractJwt} from 'passport-jwt';
import {selfUserSettingRead} from "../common/decorator/selfUserSettingRead.decorator";
import {selfUserSettingWrite} from "../common/decorator/selfUserSettingWrite.decorator";
import {accountUsersSettingsRead} from "../common/decorator/accountUsersSettingsRead.decorator";
import {selfAppointmentWrite} from "../common/decorator/selfAppointmentWrite.decorator";
import {accountUsersSettingsWrite} from "../common/decorator/accountUsersSettingsWrite.decorator";
import {selfAppointmentRead} from "../common/decorator/selfAppointmentRead.decorator";
import {accountUsersAppointmentRead} from "../common/decorator/accountUsersAppointmentRead.decorator";
import {accountUsersAppointmentWrite} from "../common/decorator/accountUsersAppointmentWrite.decorator";


@Controller('api/calendar')
@UsePipes(new ValidationPipe({transform: true}))
@UseFilters(AllExceptionsFilter)
export class CalendarController {

    private logger = new Logger('CalendarController');

    constructor(private readonly calendarService: CalendarService) {
    }


    @Post('createAppointment')
    @ApiOkResponse({
        description: 'requestBody example :   {\n' +
            '"patientId":"1",\n' +
            '"startTime": "10:00 AM",\n' +
            '"endTime": "11:00 AM",\n' +
            '"appointmentDate": "2020-06-12" \n' +
            '}'
    })
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBadRequestResponse({description: 'Invalid Schema'})
    @ApiBody({type: AppointmentDto})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @Roles('admin')
    createAppointment(@selfAppointmentWrite() check:boolean,@accountUsersAppointmentWrite() check2:boolean, @Request() req, @Body() appointmentDto: AppointmentDto) {
        if (!check && !check2)
            return {message: 'No persmission'}
        this.logger.log(`Appointment  Api -> Request data ${JSON.stringify(appointmentDto, req.user)}`);
        return this.calendarService.createAppointment(appointmentDto, req.user);
    }

    @Get('doctorList')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({description: 'request Query example:  if login as DOCTOR, Key is doctorKey example: Doc_5 , else Key is accountKey example:Acc_1'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    doctorList(@selfUserSettingRead() check: boolean, @accountUsersSettingsRead() check2: boolean, @Request() req, @Query('key') key: String) {
        if (!check && !check2)
            return {message: 'No persmission'}
        return this.calendarService.doctorList(req.user, key.trim());

    }


    @Post('doctorSettingsPersonalView')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({description: 'request body example:   {"doctorKey": "Doc_5"}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBody({type: UserDto})
    doctorView(@selfUserSettingWrite() check:boolean,@accountUsersSettingsWrite() check2:boolean, @Request() req, @Body() userDto: UserDto) {
        if (!check && !check2)
            return {message: 'No persmission'}
        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(req.user.doctor_key)}`);
        return this.calendarService.doctorView(req.user, userDto.doctorKey);
    }

    // @Post('doctorConfigCostAndPreconsultationUpdate')
    // @ApiOkResponse({description: 'Cost &  Preconsultation Update'})
    // @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    // @ApiBearerAuth('JWT')
    // @UseGuards(AuthGuard())
    // @ApiBody({type: DoctorConfigPreConsultationDto})
    // doctor_Login(@Request() req, @Body() doctorConfigPreConsultationDto: DoctorConfigPreConsultationDto) {
    //     this.logger.log(`Doctor Login  Api -> Request data ${JSON.stringify(doctorConfigPreConsultationDto, req.user)}`);
    //     return this.calendarService.doctorPreconsultation(doctorConfigPreConsultationDto, req.user);
    // }

    // @Get('HospitalDetails')
    // @ApiBearerAuth('JWT')
    // @UseGuards(AuthGuard())
    // @ApiOkResponse({description: 'Hospital Details'})
    // hospitalDetails(@Request() req) {
    //     this.logger.log(`Doctor List  Api -> Request data ${JSON.stringify(req.user.account_key)}`);
    //     return this.calendarService.hospitalDetails(req.user.account_key);
    // }

    // @Post('doctorConfigCancelRescheduleEdit')
    // @ApiOkResponse({description: 'Cancel &  Reschedule Update'})
    // @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    // @ApiBearerAuth('JWT')
    // @UseGuards(AuthGuard())
    // @ApiBody({type: DoctorConfigCanReschDto})
    // doctorCanReschEdit(@Request() req, @Body() doctorConfigCanReschDto: DoctorConfigCanReschDto) {
    //     this.logger.log(`Doctor config cancel/reschedule  Api -> Request data ${JSON.stringify(doctorConfigCanReschDto, req.user)}`);
    //     return this.calendarService.doctorCanReschEdit(doctorConfigCanReschDto, req.user);
    // }


    @Get('doctorConfigCancelRescheduleView')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({description: 'Cancel &  Reschedule View'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    doctorCanReschView(@selfUserSettingRead() check: boolean, @accountUsersSettingsRead() check2: boolean, @Request() req , @Query('doctorKey') doctorKey: String) {
        if (!check && !check2)
            return {message: 'No persmission'}
        this.logger.log(`Doctor config view  Api -> Request data ${JSON.stringify(req.user)}`);
        return this.calendarService.doctorCanReschView(req.user,doctorKey);
    }

    // @Get('appointmentsView')
    // @ApiOkResponse({description: 'Appointment List'})
    // @ApiBearerAuth('JWT')
    // @UseGuards(AuthGuard())
    // @Roles('doctor', 'patient')
    // getAppointmentList(@Request() req) {
    //     this.logger.log(`Appointments are view Api -> Request data ${JSON.stringify(req.user.doctor_key)}`);
    //     return this.calendarService.appointmentList(req.user.doctor_key);
    // }

    @Post('doctorConfigUpdate')
    @ApiOkResponse({
        description: 'requestBody example :   {\n' +
            '"doctorKey":"Doc_5",\n' +
            '"consultationCost": "5000" ,\n' +
            '"isPreconsultationAllowed": true, \n' +
            '"preconsultationHours": "5", \n' +
            '"preconsultationMins": "30", \n' +
            '"isPatientCancellationAllowed": false ,\n' +
            '"cancellationDays": "2" ,\n' +
            '"cancellationHours": "3" ,\n' +
            '"cancellationMins": "30", \n' +
            '"isPatientRescheduleAllowed": false, \n' +
            '"rescheduleDays": "2", \n' +
            '"rescheduleHours": "4" ,\n' +
            '"rescheduleMins": "15", \n' +
            '"autoCancelDays": "1", \n' +
            '"autoCancelHours": "3" ,\n' +
            '"autoCancelMins": "15" \n' +
            '}'
    })
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({type: DocConfigDto})
    doctorConfigUpdate(@selfUserSettingRead() check: boolean, @accountUsersSettingsRead() check2: boolean, @Request() req, @Body() docConfigDto: DocConfigDto) {
        if (!check && !check2)
            return {message: 'No persmission'}
        this.logger.log(`Doctor config Update  Api -> Request data ${JSON.stringify(docConfigDto, req.user)}`);
        return this.calendarService.doctorConfigUpdate(req.user, docConfigDto);
    }

    @Post('workScheduleEdit')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({
        description: 'requestBody example :   {\n' +
            '"doctorKey":"Doc_5",\n' +
            '"date": "20-06-2020",\n' +
            '"dayOfWeek": "Monday" \n' +
            '}'
    })
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBody({type: WorkScheduleDto})
    workScheduleEdit(@selfAppointmentWrite() check:boolean,@accountUsersSettingsWrite() check2:boolean, @Request() req, @Body() workScheduleDto: any) {
        if (!check && !check2)
            return {message: 'No persmission'}
        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(workScheduleDto, req.user)}`);
        return this.calendarService.workScheduleEdit(workScheduleDto, req.user);
    }

    @Get('workScheduleView')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({description: 'request body example:   {"doctorKey": "Doc_5"}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    workScheduleView(@selfUserSettingRead() check: boolean, @accountUsersSettingsRead() check2: boolean, @Request() req, @Query('doctorKey') doctorKey: String) {
        if (!check && !check2)
            return {message: 'No persmission'}
        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(req.user.doctor_key)}`);
        return this.calendarService.workScheduleView(req.user, doctorKey);
    }

    @Get('appointmentSlotsView')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({description: 'request body example:  Doc_5, 2020-05-05, 2020-06-21'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    appointmentSlotsView(@selfAppointmentRead() check:boolean, @accountUsersAppointmentRead() check2:boolean, @Request() req, @Query('doctorKey') doctorKey: String, @Query('startDate') startDate: String, @Query('endDate') endDate: String) {
        if (!check && !check2)
            return {message: 'No persmission'}
        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(req.user)}`);
        return this.calendarService.appointmentSlotsView(req.user, doctorKey, startDate, endDate);
    }

    @Post('appointmentReschedule')
    @ApiOkResponse({
        description: 'requestBody example :   {\n' +
            '"appointmentId":"33",\n' +
            '"patientId":"1",\n' +
            '"startTime": "10:00 AM",\n' +
            '"endTime": "11:00 AM",\n' +
            '"appointmentDate": "2020-06-12" \n' +
            '}'
    })
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({type: AppointmentDto})
    appointmentReschedule(@selfAppointmentWrite() check:boolean,@accountUsersAppointmentWrite() check2:boolean, @Request() req, @Body() appointmentDto: AppointmentDto) {
        if (!check && !check2)
            return {message: 'No persmission'}
        this.logger.log(`Doctor config reschedule  Api -> Request data ${JSON.stringify(appointmentDto, req.user)}`);
        return this.calendarService.appointmentReschedule(appointmentDto, req.user);
    }

    @Post('appointmentCancel')
    @ApiOkResponse({description: 'Appointment Cancel'})
    @ApiUnauthorizedResponse({description: 'request body example:   {"appointmentId": "28"}'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({type: AppointmentDto})
    appointmentCancel(@selfAppointmentWrite() check:boolean,@accountUsersAppointmentWrite() check2:boolean, @Request() req, @Body() appointmentDto: AppointmentDto) {
        if (!check && !check2)
            return {message: 'No persmission'}
        this.logger.log(`Doctor config cancel  Api -> Request data ${JSON.stringify(appointmentDto, req.user)}`);
        return this.calendarService.appointmentCancel(appointmentDto, req.user);
    }

    @Post('patientSearch')
    @ApiOkResponse({description: 'request body example:   {"phone": "9999999993"}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({type: PatientDto})
    patientSearch(@Request() req, @Body() patientDto: PatientDto) {
        this.logger.log(`Doctor config cancel/reschedule  Api -> Request data ${JSON.stringify(patientDto, req.user)}`);
        return this.calendarService.patientSearch(patientDto, req.user);
    }

    @Post('appointmentView')
    @ApiOkResponse({description: 'request body example:   {"appointmentId": "28"}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({type: AppointmentDto})
    AppointmentView(@selfAppointmentRead() check:boolean, @accountUsersAppointmentRead() check2:boolean, @Request() req, @Body() appointmentId: AppointmentDto) {
        if (!check && !check2)
            return {message: 'No persmission'}
        this.logger.log(`Doctor List  Api -> Request data ${JSON.stringify(req.user)}`);
        return this.calendarService.AppointmentView(req.user, appointmentId);
    }

    @Get('doctorListForPatients')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({description: 'request body example:  Acc_1'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    doctorListForPatients(@Request() req, @Query('accountKey') accountKey: String) {
        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(req.user)}`);
        return this.calendarService.doctorListForPatients(req.user, accountKey);
    }

    @Post('findDoctorByCodeOrName')
    @ApiOkResponse({description: 'request body example:   {"codeOrName": "RegD_1"}  or {"codeOrName": "Adithya K"} '})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({type: DoctorDto})
    findDoctorByCodeOrName(@Request() req, @Body() codeOrName: DoctorDto) {
        this.logger.log(`Find DOctor Api -> Request data ${JSON.stringify(req.user)}`);
        return this.calendarService.findDoctorByCodeOrName(req.user, codeOrName);
    }

    @Post('patientDetailsEdit')
    @ApiOkResponse({
        description: 'requestBody example :   {\n' +
            '"patientId":"5",\n' +
            '"email":"nirmala@gmail.com",\n' +
            '"landmark":"landmark", \n' +
            '"country":"country", \n' +
            '"name":"name", \n' +
            '"address":"address", \n' +
            '"state":"state", \n' +
            '"pincode":"12346", \n' +
            '"photo":"https://homepages.cae.wisc.edu/~ece533/images/airplane.png" \n' +
            '}'
    })
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBody({type: PatientDto})
    patientDetailsEdit(@Request() req, @Body() patientDto: PatientDto) {
        this.logger.log(`Find DOctor Api -> Request data ${JSON.stringify(patientDto)}`);
        return this.calendarService.patientDetailsEdit(patientDto);
    }

    @Post('patientBookAppointment')
    @ApiOkResponse({
        description: 'requestBody example :   {\n' +
            '"patientId":"1",\n' +
            '"startTime": "10:00 AM",\n' +
            '"endTime": "11:00 AM",\n' +
            '"appointmentDate": "2020-06-12" \n' +
            '}'
    })
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBody({type: PatientDto})
    patientBookAppointment(@Request() req, @Body() patientDto: PatientDto) {
        this.logger.log(`Find DOctor Api -> Request data ${JSON.stringify(patientDto)}`);
        return this.calendarService.patientBookAppointment(patientDto);
    }

    @Get('viewAppointmentSlotsForPatient')
    @ApiOkResponse({description: 'request body example:  Doc_5, 2020-05-05'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    viewAppointmentSlotsForPatient(@Request() req, @Query('doctorKey') doctorKey: String, @Query('appointmentDate') appointmentDate: String) {
        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(doctorKey)}`);
        return this.calendarService.viewAppointmentSlotsForPatient(doctorKey, appointmentDate);
    }


}
