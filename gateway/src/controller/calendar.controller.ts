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
import { UserService } from 'src/service/user.service';
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
    PatientDto,CONSTANT_MSG,HospitalDto
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
import {accountSettingsRead} from "../common/decorator/accountSettingsRead.decorator";
import {accountSettingsWrite} from "../common/decorator/accountSettingsWrite.decorator";
import {reports} from "../common/decorator/reports.decorator";
import {patient} from "../common/decorator/patientPermission.decorator";
import { AnyARecord } from 'dns';
import {IsMilitaryTime, isMilitaryTime} from 'class-validator';


@Controller('api/calendar')
@UsePipes(new ValidationPipe({transform: true}))
@UseFilters(AllExceptionsFilter)
export class CalendarController {

    private logger = new Logger('CalendarController');

    constructor(private readonly calendarService: CalendarService,private readonly userService: UserService,) {
    }


    @Post('doctor/createAppointment')
    @ApiOkResponse({
        description: 'requestBody example :   {\n' +
            '"patientId":1,\n' +
            '"doctorKey":"Doc_5",\n' +
            '"startTime": "10:00",\n' +
            '"endTime": "11:00",\n' +
            '"appointmentDate": "2020-06-12", \n' +
            '"paymentOption":"directPayment", \n' +
            '"confirmation":false,\n'+
            '"consultationMode":"online" \n' +
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
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(!req.body.patientId){
            console.log("Provide patientId");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide patientId"}
        } else if(!req.body.appointmentDate){
            console.log("Provide appointmentDate");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide appointmentDate"}
        } else if(!req.body.startTime){
            console.log("Provide startTime");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide startTime"}
        }
        appointmentDto.appointmentDate= new Date(appointmentDto.appointmentDate);
        const today = new Date()
        const yesterday = new Date(today)
        yesterday.setDate(yesterday.getDate() - 1)
        if(appointmentDto.appointmentDate < yesterday){
            return{
                statusCode:HttpStatus.BAD_REQUEST,
                message:"Past Dates are not acceptable"
            }
        }
        this.logger.log(`Appointment  Api -> Request data ${JSON.stringify(appointmentDto, req.user)}`);
        return this.calendarService.createAppointment(appointmentDto, req.user);
    }

    @Get('doctor/list')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({description: 'request Query example:  if login as DOCTOR, Key is doctorKey example: Doc_5 , else Key is accountKey example:Acc_1'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    doctorList(@selfUserSettingRead() check: boolean, @accountUsersSettingsRead() check2: boolean, @Request() req) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        return this.calendarService.doctorList(req.user);

    }


    @Get('doctor/personalSettingsView')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({description: 'request body example:   {"doctorKey": "Doc_5"}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    doctorView(@selfUserSettingRead() check:boolean,@accountUsersSettingsRead() check2:boolean, @Request() req, @Query('doctorKey') doctorKey: String) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(!doctorKey){
            console.log("Provide doctorKey");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide doctorKey"}
        }
        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(doctorKey)}`);
        return this.calendarService.doctorView(req.user,doctorKey);
    }


    @Get('doctor/configCancelRescheduleView')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({description: 'Cancel &  Reschedule View'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    doctorCanReschView(@selfUserSettingRead() check: boolean, @accountUsersSettingsRead() check2: boolean, @Request() req , @Query('doctorKey') doctorKey: String) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        this.logger.log(`Doctor config view  Api -> Request data ${JSON.stringify(req.user)}`);
        return this.calendarService.doctorCanReschView(req.user,doctorKey);
    }


    @Post('doctor/configUpdate')
    @ApiOkResponse({
        description: 'requestBody example :   {\n' +
            '"doctorKey":"Doc_5",\n' +
            '"consultationCost": "5000" ,\n' +
            '"isPreconsultationAllowed": true, \n' +
            '"preconsultationHours": 5, \n' +
            '"preconsultationMins": 30, \n' +
            '"isPatientCancellationAllowed": false ,\n' +
            '"cancellationDays": 2 ,\n' +
            '"cancellationHours": 3 ,\n' +
            '"cancellationMins": 30, \n' +
            '"isPatientRescheduleAllowed": false, \n' +
            '"rescheduleDays": 2, \n' +
            '"rescheduleHours": 4 ,\n' +
            '"rescheduleMins": 15, \n' +
            '"autoCancelDays": 1, \n' +
            '"autoCancelHours": 3 ,\n' +
            '"autoCancelMins": 15 ,\n' +
            '"consultationSessionTimings": 10 \n' +
            '}'
    })
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({type: DocConfigDto})
    doctorConfigUpdate(@selfUserSettingWrite() check: boolean, @accountUsersSettingsWrite() check2: boolean, @Request() req, @Body() docConfigDto: DocConfigDto) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(!req.body.doctorKey){
            console.log("Provide doctorKey");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide doctorKey"}
        }
        this.logger.log(`Doctor config Update  Api -> Request data ${JSON.stringify(docConfigDto, req.user)}`);
        return this.calendarService.doctorConfigUpdate(req.user, docConfigDto);
    }

    @Post('doctor/workScheduleEdit')
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
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        // if(!req.body.doctorKey){
        //     console.log("Provide doctorKey");
        //     return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide doctorKey"} 
        // }else if(req.body.updateWorkSchedule){
        //     if(!req.body.updateWorkSchedule[0].scheduledayid){
        //         console.log("Provide scheduledayid");
        //         return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide scheduledayid"} 
        //     }else if(req.body.updateWorkSchedule[0].startTime){
        //         let startTime= req.body.updateWorkSchedule[0].startTime;
        //         startTime:WorkScheduleDto;              
                
        //     }
        // }
        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(workScheduleDto, req.user)}`);
        return this.calendarService.workScheduleEdit(workScheduleDto, req.user);
    }

    @Get('doctor/workScheduleView')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({description: 'request body example:   {"doctorKey": "Doc_5"}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    workScheduleView(@selfUserSettingRead() check: boolean, @accountUsersSettingsRead() check2: boolean, @Request() req, @Query('doctorKey') doctorKey: String) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(req.user.doctor_key)}`);
        return this.calendarService.workScheduleView(req.user, doctorKey);
    }

    @Get('doctor/appointmentSlotsView')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({description: 'request body example:  Doc_5, 0 (default value)'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    appointmentSlotsView(@selfAppointmentRead() check:boolean, @accountUsersAppointmentRead() check2:boolean, @Request() req, @Query('doctorKey') doctorKey: String, @Query('paginationNumber') paginationNumber: number) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(req.user)}`);
        return this.calendarService.appointmentSlotsView(req.user, doctorKey,paginationNumber);
    }

    @Post('doctor/appointmentReschedule')
    @ApiOkResponse({
        description: 'requestBody example :   {\n' +
            '"appointmentId":"33",\n' +
            '"patientId":"1",\n' +
            '"startTime": "10:00",\n' +
            '"endTime": "11:00",\n' +
            '"appointmentDate": "2020-06-12" \n' +
            '}'
    })
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({type: AppointmentDto})
    appointmentReschedule(@selfAppointmentWrite() check:boolean,@accountUsersAppointmentWrite() check2:boolean, @Request() req, @Body() appointmentDto: AppointmentDto) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(!req.body.appointmentId){
            console.log("Provide appointmentId");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide appointmentId"}
        } else if(!req.body.patientId){
            console.log("Provide patientId");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide patientId"}
        } else if(!req.body.appointmentDate){
            console.log("Provide appointmentDate");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide appointmentDate"}
        } else if(!req.body.startTime){
            console.log("Provide startTime");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide startTime"}
        }
        appointmentDto.appointmentDate= new Date(appointmentDto.appointmentDate);
        const today = new Date()
        const yesterday = new Date(today)
        yesterday.setDate(yesterday.getDate() - 1)
        if(appointmentDto.appointmentDate < yesterday){
            return{
                statusCode:HttpStatus.BAD_REQUEST,
                message:"Past Dates are not acceptable"
            }
        }
        this.logger.log(`Doctor config reschedule  Api -> Request data ${JSON.stringify(appointmentDto, req.user)}`);
        return this.calendarService.appointmentReschedule(appointmentDto, req.user);
    }

    @Post('doctor/appointmentCancel')
    @ApiOkResponse({description: 'Appointment Cancel'})
    @ApiUnauthorizedResponse({description: 'request body example:   {"appointmentId": 28,"confirmation":true}'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({type: AppointmentDto})
    appointmentCancel(@selfAppointmentWrite() check:boolean,@accountUsersAppointmentWrite() check2:boolean, @Request() req, @Body() appointmentDto: AppointmentDto) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(!req.body.appointmentId){
            console.log("Provide appointmentId");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide appointmentId"}
        }
        this.logger.log(`Doctor config cancel  Api -> Request data ${JSON.stringify(appointmentDto, req.user)}`);
        return this.calendarService.appointmentCancel(appointmentDto, req.user);
    }

    @Post('doctor/patientSearch')
    @ApiOkResponse({description: 'request body example:   {"phone": "9999999993"}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({})
    patientSearch(@Request() req, @Body() patientDto: string) {
        if(req.body.phone){
            this.logger.log(`Doctor config cancel/reschedule  Api -> Request data ${JSON.stringify(patientDto, req.user)}`);
            return this.calendarService.patientSearch(patientDto, req.user);
        }else{
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: "Provide valid phone number"
            } 
        }
    }

    @Post('appointmentView')
    @ApiOkResponse({description: 'request body example:   {"appointmentId": "28"}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({type: AppointmentDto})
    AppointmentView(@selfAppointmentRead() check:boolean, @accountUsersAppointmentRead() check2:boolean, @Request() req, @Body() appointmentId: AppointmentDto) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(!req.body.appointmentId){
            console.log("Provide appointmentId");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide appointmentId"}
        }
        this.logger.log(`Doctor List  Api -> Request data ${JSON.stringify(req.user)}`);
        return this.calendarService.AppointmentView(req.user, appointmentId);  
    }

    @Get('patient/doctorList')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({description: 'request body example:  Acc_1'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    doctorListForPatients(@patient() check:boolean, @Request() req) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(req.user)}`);
        return this.calendarService.doctorListForPatients(req.user);
    }

    @Post('patient/findDoctorByCodeOrName')
    @ApiOkResponse({description: 'request body example:   {"codeOrName": "RegD_1"}  or {"codeOrName": "Adithya K"} '})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({type: DoctorDto})
    findDoctorByCodeOrName(@patient() check:boolean, @Request() req, @Body() codeOrName: DoctorDto) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(!req.body.codeOrName){
            console.log("Provide codeOrName");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide codeOrName"}
        }
        this.logger.log(`Find Doctor Api -> Request data ${JSON.stringify(req.user)}`);
        return this.calendarService.findDoctorByCodeOrName(req.user, codeOrName);
    }

    @Post('patient/detailsEdit')
    @ApiOkResponse({
        description: 'requestBody example :   {\n' +
            '"patientId":"5",\n' +
            '"email":"nirmala@gmail.com",\n' +
            '"landmark":"landmark", \n' +
            '"country":"country", \n' +
            '"name":"name", \n' +
            '"address":"address", \n' +
            '"state":"state", \n' +
            '"pincode":"pincode", \n' +
            '"dateOfBirth":"dateOfBirth", \n' +
            '"photo":"https://homepages.cae.wisc.edu/~ece533/images/airplane.png" \n' +
            '}'
    })
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBody({type: PatientDto})
    patientDetailsEdit(@patient() check:boolean, @Request() req, @Body() patientDto: PatientDto) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(!req.body.patientId){
            console.log("Provide patientId");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide patientId"}
        }
        if(req.body.patientId !== req.user.patientId){
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.INVALID_REQUEST}
        }
        this.logger.log(`Patient Details Edit Api -> Request data ${JSON.stringify(patientDto)}`);
        return this.calendarService.patientDetailsEdit(patientDto);
    }

    @Post('patient/bookAppointment')
    @ApiOkResponse({
        description: 'requestBody example :   {\n' +
            '"patientId":1,\n' +
            '"doctorKey":"Doc_5"\n' +
            '"startTime": "10:00",\n' +
            '"endTime": "11:00",\n' +
            '"appointmentDate": "2020-06-12", \n' +
            '"paymentOption":"directPayment", \n' +
            '"confirmation":false,\n'+
            '"consultationMode":"online" \n' +
            '}'
    })
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBody({type: PatientDto})
    patientBookAppointment(@patient() check:boolean, @Request() req, @Body() patientDto: AppointmentDto) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(!req.body.doctorKey){
            console.log("Provide doctorKey");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide doctorKey"}
        } else if(!req.body.appointmentDate){
            console.log("Provide appointmentDate");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide appointmentDate"}
        } else if(!req.body.startTime){
            console.log("Provide startTime");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide startTime"}
        }
        patientDto.appointmentDate= new Date(patientDto.appointmentDate);
        const today = new Date()
        const yesterday = new Date(today)
        yesterday.setDate(yesterday.getDate() - 1)
        if(patientDto.appointmentDate < yesterday){
            return{
                statusCode:HttpStatus.BAD_REQUEST,
                message:"Past Dates are not acceptable"
            }
        }
        if(patientDto.patientId !== req.user.patientId){
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.INVALID_REQUEST}
        }
        this.logger.log(`Patient Book Appointment Api -> Request data ${JSON.stringify(patientDto)}`);
        return this.calendarService.patientBookAppointment(patientDto);
    }

    @Get('patient/appointmentSlotsView')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({description: 'request body example:  Doc_5, 2020-05-05'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    viewAppointmentSlotsForPatient(@patient() check:boolean, @Request() req, @Query('doctorKey') doctorKey: String, @Query('appointmentDate') appointmentDate: String) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(doctorKey)}`);
        return this.calendarService.viewAppointmentSlotsForPatient(doctorKey, appointmentDate);
    }

    @Get('patient/pastAppointmentsList')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({description: 'request body example:  1'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    patientPastAppointments(@patient() check:boolean, @Request() req,  @Query('limit') limit: Number, @Query('paginationNumber') paginationNumber: Number) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        this.logger.log(`Past Appointment Api -> Request data ${JSON.stringify(req.user.patientId)}`);
        return this.calendarService.patientPastAppointments(req.user.patientId,paginationNumber,limit);
    }

    @Get('patient/upcomingAppointmentsList')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({description: 'request body example:  1'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    patientUpcomingAppointments(@patient() check:boolean, @Request() req,  @Query('limit') limit: number, @Query('paginationNumber') paginationNumber: Number) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        this.logger.log(`Upcoming Appointment Api -> Request data ${JSON.stringify(req.user.patientId)}`);
        return this.calendarService.patientUpcomingAppointments(req.user.patientId,paginationNumber,limit);
    }

    @Get('doctor/patientList')
    @ApiOkResponse({description: 'patientList API'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    patientList(@Request() req,  @Query('doctorKey') doctorKey: String) {
        this.logger.log(`Upcoming Appointment Api -> Request data }`);
        return this.calendarService.patientList(doctorKey);
    }

    @Post('doctor/personalSettingsEdit')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({type: DoctorDto})
    @ApiOkResponse({description: 'request body example:   {"doctorKey": "Doc_5"}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    doctorPersonalSettingsEdit(@selfUserSettingWrite() check:boolean,@accountUsersSettingsWrite() check2:boolean, @Request() req, @Body() doctorDto: DoctorDto) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(!req.body.doctorKey){
            console.log("Provide doctorKey");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide doctorKey"}
        }
        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(doctorDto)}`);
        return this.calendarService.doctorPersonalSettingsEdit(req.user,doctorDto);
    }

    @Get('doctor/hospitaldetailsView')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({description: ' '})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    hospitaldetailsView(@accountSettingsRead() check: boolean, @Request() req , @Query('accountKey') accountKey: String) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        this.logger.log(`Doctor config view  Api -> Request data ${JSON.stringify(req.user)}`);
        return this.calendarService.hospitaldetailsView(req.user,accountKey);
    }

    @Post('doctor/hospitaldetailsEdit')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({type: DoctorDto})
    @ApiOkResponse({description: 'request body example:   {"doctorKey": "Doc_5"}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    hospitaldetailsEdit(@accountSettingsWrite() check:boolean, @Request() req, @Body() hospitalDto: HospitalDto) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(!req.body.accountKey){
            console.log("Provide accountKey");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide accountKey"}
        }
        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(hospitalDto)}`);
        return this.calendarService.hospitaldetailsEdit(req.user,hospitalDto);
    }

    @Get('patient/appointmentDoctorDetails')
    @ApiOkResponse({description: 'request body example:   {"doctorKey": "Doc_5"}'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    doctorDetails(@patient() check:boolean, @Request() req, @Query('doctorKey') doctorKey: String, @Query('appointmentId') appointmentId: number) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(!doctorKey){
            console.log("Provide doctorKey");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide doctorKey"}
        }
        this.logger.log(`View Doctor Details  Api -> Request data ${JSON.stringify(doctorKey)}`);
        return this.calendarService.doctorDetails(doctorKey,appointmentId);
    }

    @Get('doctor/availableSlots')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({description: 'request body example:  Doc_5'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    availableSlots(@selfAppointmentRead() check:boolean, @accountUsersAppointmentRead() check2:boolean, @Request() req, @Query('doctorKey') doctorKey: String, @Query('appointmentDate') appointmentDate: string) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        let date = new Date(appointmentDate);    
        this.logger.log(`Doctor availableSlots  Api -> Request data ${JSON.stringify(req.user)}`);
        return this.calendarService.availableSlots(req.user, doctorKey,date);
    }

    @Post('doctor/creatingAppointmetAlongWithRegisteringPatient')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({type: AppointmentDto})
    @ApiOkResponse({description: 'requestBody example :   {\n' +
                                            '"phone":"99999999999",\n' +
                                            '"firstName":"nirmala@gmail.com",\n' +
                                            '"lastName":"lastName", \n' +
                                            '"email":"email@gmail.com", \n' +
                                            '"dateOfBirth":"1999-10-26", \n' +
                                            '"appointmentDate":"2020-07-26", \n' +
                                            '"startTime":"10:00", \n' +
                                            '"endTime":"11:00", \n' +
                                            '"paymentOption":"directPayment", \n' +
                                            '"consultationMode":"online" \n' +
                                            '}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    async RegisteringAndCreateApp(@selfAppointmentWrite() check:boolean, @accountUsersAppointmentWrite() check2:boolean, @Request() req, @Body() patientDto: PatientDto) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(!req.body.phone){
            console.log("Provide phone");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide phone"}
        } else if(!req.body.firstName){
            console.log("Provide firstName");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide firstName"}
        } else if(!req.body.lastName){
            console.log("Provide lastName");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide lastName"}
        } else if(!req.body.email){
            console.log("Provide email");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide email"}
        } else if(!req.body.dateOfBirth){
            console.log("Provide dateOfBirth");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide dateOfBirth"}
        } else if(!req.body.appointmentDate){
            console.log("Provide appointmentDate");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide appointmentDate"}
        } else if(!req.body.startTime){
            console.log("Provide startTime");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide startTime"}
        } else if(!req.body.endTime){
            console.log("Provide endTime");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide endTime"}
        } else if(!req.body.paymentOption){
            console.log("Provide paymentOption");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide paymentOption"}
        } else if(!req.body.consultationMode){
            console.log("Provide consultationMode");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide consultationMode"}
        }
        let patientRegDto:any ={
            phone:patientDto.phone,
            firstName:patientDto.firstName,
            lastName:patientDto.lastName,
            email:patientDto.email,
            dateOfBirth:patientDto.dateOfBirth,
            createdBy:req.user.role,
            name:patientDto.firstName +" "+ patientDto.lastName
        }
        if(patientDto.phone && patientDto.phone.length == 10){
            this.logger.log(`Patient Registration  Api -> Request data ${JSON.stringify(patientRegDto)}`);
            const patient = await this.userService.patientRegistration(patientRegDto);
            if(patient.message){
                return patient;
            }else {
                const details = await this.calendarService.patientInsertion(patientRegDto,patient.patientId);
                let appointmentDto = {
                    patientId:patient.patientId,
                    appointmentDate:patientDto.appointmentDate,
                    startTime:patientDto.startTime,
                    endTime:patientDto.endTime,
                    paymentOption:patientDto.paymentOption,
                    consultationMode:patientDto.consultationMode
                }
               
                appointmentDto.appointmentDate= new Date(appointmentDto.appointmentDate);
                const today = new Date()
                const yesterday = new Date(today)
                yesterday.setDate(yesterday.getDate() - 1)
                if(appointmentDto.appointmentDate < yesterday){
                    return{
                        statusCode:HttpStatus.BAD_REQUEST,
                        message:"Past Dates are not acceptable"
                    }
                }
                this.logger.log(`Appointment  Api -> Request data ${JSON.stringify(appointmentDto, req.user)}`);
                const app = await this.calendarService.createAppointment(appointmentDto, req.user);
                return {
                    patient:patient,
                    details:details,
                    appointment:app
                }
            }
        }else{
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: "Provide valid phone"
            }
        }
    }

    @Get('doctor/patientDetails')
    @ApiOkResponse({description: 'patientList API'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    patientDetails(@Request() req, @selfAppointmentRead() check:boolean, @accountUsersAppointmentRead() check2:boolean,  @Query('patientId') patientId: number,  @Query('doctorKey') doctorKey: string) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        this.logger.log(`PatientDetails Api -> Request data }`);
        return this.calendarService.patientDetails(req.user, patientId,doctorKey);
    }

    @Get('admin/reports')
    @ApiOkResponse({description: 'patientList API'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    reports(@Request() req, @reports() check:boolean,  @Query('accountKey') accountKey: string, @Query('paginationNumber') paginationNumber: number) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        this.logger.log(`admin reports Api -> Request data }`);
        return this.calendarService.reports(req.user, accountKey,paginationNumber);
    }

    @Get('patient/listOfDoctorsInHospital')
    @ApiOkResponse({description: 'listOfDoctorsInHospital API'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    listOfDoctorsInHospital(@patient() check:boolean, @Request() req, @Query('accountKey') accountKey: string) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        this.logger.log(`listOfDoctorsInHospital Api -> Request data }`);
        return this.calendarService.listOfDoctorsInHospital(req.user, accountKey);
    }

    @Get('patient/viewDoctorDetails')
    @ApiOkResponse({description: 'viewDoctorDetails API'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    viewDoctorDetails(@patient() check:boolean, @Request() req, @Query('doctorKey') doctorKey: string) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        this.logger.log(`viewDoctorDetails Api -> Request data }`);
        return this.calendarService.viewDoctorDetails(req.user, doctorKey);
    }


    // @Get('doctor/personalSettingsView')
    // @ApiBearerAuth('JWT')
    // @UseGuards(AuthGuard())
    // @ApiOkResponse({description: 'request body example:   {"doctorKey": "Doc_5"}'})
    // @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    // doctorView(@selfUserSettingRead() check:boolean,@accountUsersSettingsRead() check2:boolean, @Request() req, @Query('doctorKey') doctorKey: String) {
    //     if (!check && !check2)
    //         return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
    //     if(!doctorKey){
    //         console.log("Provide doctorKey");
    //         return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide doctorKey"}
    //     }
    //     this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(doctorKey)}`);
    //     return this.calendarService.doctorView(req.user,doctorKey);
    // }


}
