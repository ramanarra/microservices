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
    UnauthorizedException, HttpStatus, UploadedFile, UseInterceptors
} from '@nestjs/common';
import { FilesInterceptor,FileInterceptor } from '@nestjs/platform-express';
import { UserService } from 'src/service/user.service';
import {CalendarService} from 'src/service/calendar.service';
import {
    ApiOkResponse,
    ApiUnauthorizedResponse,
    ApiBody,
    ApiBearerAuth,
    ApiCreatedResponse,
    ApiBadRequestResponse,
    ApiTags,ApiConsumes, ApiQuery
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
    PrescriptionDto,
    WorkScheduleDto,
    PatientDto,CONSTANT_MSG,HospitalDto, AccountDto, patientReportDto
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
import { retryWhen } from 'rxjs/operators';
import { Observable } from 'rxjs';
import { report } from 'process';
var moment = require('moment');


@Controller('api/calendar')
@UsePipes(new ValidationPipe({transform: true}))
@UseFilters(AllExceptionsFilter)
export class CalendarController {

    private logger = new Logger('CalendarController');

    constructor(private readonly calendarService: CalendarService,private readonly userService: UserService ) {
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
    @ApiTags('Doctors')
    @Roles('admin')
    async createAppointment(@selfAppointmentWrite() check:boolean,@accountUsersAppointmentWrite() check2:boolean, @Request() req, @Body() appointmentDto: AppointmentDto) {
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
        // const yesterday = new Date(today)
        // yesterday.setDate(yesterday.getDate() - 1)
        appointmentDto.appointmentDate = new Date(appointmentDto.appointmentDate);
        var appDate:any = new Date(appointmentDto.appointmentDate);
        var month = appDate.getMonth() + 1
        var day = appDate.getDate();
        var year = appDate.getFullYear();
        appDate = year + "-" + month + "-" + day;
        var today:any = new Date()
        month = today.getMonth() + 1
        day = today.getDate();
        year = today.getFullYear();
        var today1 = year + "-" + month + "-" + day;
        // appointmentDto.appointmentDate = moment(appointmentDto.appointmentDate).format();
        // const yesterday = moment().subtract(1, 'days').format()
        if((appointmentDto.appointmentDate < today)&&!(appDate == today1)){
            return{
                statusCode:HttpStatus.BAD_REQUEST,
                message:"Past Dates are not acceptable"
            }
        }
        this.logger.log(`Appointment  Api -> Request data ${JSON.stringify(appointmentDto, req.user)}`);
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
           await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        const appointment = await this.calendarService.createAppointment(appointmentDto, req.user);

        //Send mail functionality
        if (req.user.email && !appointment.message) {
            const template = await this.calendarService.getMessageTemplate({ messageType: 'APPOINTMENT_CREATED', communicationType: 'Email' });

            if (template && template.data) {
                let data = {
                    email: req.user.email,
                    template: template.data.body,
                    subject: template.data.subject,
                    type: CONSTANT_MSG.MAIL.APPOINTMENT_CREATED,
                    sender: template.data.sender,
                    user_name: appointment.patientDetail.doctorFirstName + ' ' + appointment.patientDetail.doctorLastName,
                    Details: appointment.patientDetail,
                };

                const sendMail = await this.userService.sendEmailWithTemplate(data);

                if (sendMail && sendMail.statusCode === HttpStatus.OK) {
                    if (appointment.patientDetail.email) {
                        const template = await this.calendarService.getMessageTemplate({ messageType: 'APPOINTMENT_CREATED', communicationType: 'Email' });

                        if (template && template.data) {
                            let data = {
                                email: appointment.patientDetail.email,
                                template: template.data.body,
                                subject: template.data.subject,
                                type: CONSTANT_MSG.MAIL.APPOINTMENT_CREATED,
                                sender: template.data.sender,
                                user_name: appointment.patientDetail.patientFirstName + ' ' + appointment.patientDetail.patientLastName,
                                Details: appointment.patientDetail,
                            };

                            const sendMail = await this.userService.sendEmailWithTemplate(data);

                            if (sendMail && sendMail.statusCode === HttpStatus.OK) {
                                delete req.user.name;
                                delete appointment.patientDetail;
                                return appointment;
                            } else {
                                return sendMail;
                            }
                        }
                    }
                }

            }
        }
       
        return appointment;
    }

    @Get('doctor/list')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Doctors')
    @ApiOkResponse({description: 'request Query example:  if login as DOCTOR, Key is doctorKey example: Doc_5 , else Key is accountKey example:Acc_1'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    async doctorList(@selfUserSettingRead() check: boolean, @accountUsersSettingsRead() check2: boolean, @Request() req) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        return await this.calendarService.doctorList(req.user);

    }


    @Get('doctor/personalSettingsView')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Doctors')
    @ApiOkResponse({description: 'request body example:   {"doctorKey": "Doc_5"}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    async doctorView(@selfUserSettingRead() check:boolean,@accountUsersSettingsRead() check2:boolean, @Request() req, @Query('doctorKey') doctorKey: String) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(!doctorKey){
            console.log("Provide doctorKey");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide doctorKey"}
        }
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(doctorKey)}`);
        return await this.calendarService.doctorView(req.user,doctorKey);
    }


    @Get('doctor/configCancelRescheduleView')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Doctors')
    @ApiOkResponse({description: 'Cancel &  Reschedule View'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    async doctorCanReschView(@selfUserSettingRead() check: boolean, @accountUsersSettingsRead() check2: boolean, @Request() req , @Query('doctorKey') doctorKey: String) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        this.logger.log(`Doctor config view  Api -> Request data ${JSON.stringify(req.user)}`);
        return await this.calendarService.doctorCanReschView(req.user,doctorKey);
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
    @ApiTags('Doctors')
    @ApiBody({type: DocConfigDto})
    async doctorConfigUpdate(@selfUserSettingWrite() check: boolean, @accountUsersSettingsWrite() check2: boolean, @Request() req, @Body() docConfigDto: DocConfigDto) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(!req.body.doctorKey){
            console.log("Provide doctorKey");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide doctorKey"}
        }
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        this.logger.log(`Doctor config Update  Api -> Request data ${JSON.stringify(docConfigDto, req.user)}`);
        return await this.calendarService.doctorConfigUpdate(req.user, docConfigDto);
    }

    @Post('doctor/workScheduleEdit')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Doctors')
    @ApiOkResponse({
        description: '{"doctorKey":"Doc_5", "updateWorkSchedule": [ {"scheduledayid": 4, "scheduletimeid": 32, "startTime": "11:30", "endTime": "12:00", "isDelete": true }], "workScheduleConfig" : { "overBookingType" : "Per Hour", "overBookingCount" : 5, "overBookingEnabled": false, "consultationSessionTimings": "60"}}'
    })
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBody({type: WorkScheduleDto})
    async workScheduleEdit(@selfAppointmentWrite() check:boolean,@accountUsersSettingsWrite() check2:boolean, @Request() req, @Body() workScheduleDto: any) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        if(!req.body.doctorKey){
            console.log("Provide doctorKey");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide doctorKey"} 
        }else if(workScheduleDto.updateWorkSchedule){
            let y;
            let x=workScheduleDto.updateWorkSchedule
            for(y=0;y<workScheduleDto.updateWorkSchedule.length;y++){
                if(!x[y].scheduledayid){
                    console.log("Provide scheduledayid");
                    return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide scheduledayid"}  
                }else if(!x[y].startTime){
                    console.log("Provide startTime");
                    return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide startTime"}
                }else if(!x[y].endTime){
                    console.log("Provide endTime");
                    return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide endTime"}
                }
                if(x[y].startTime){
                    console.log(x[y].startTime);
                    let splitStartTime = x[y].startTime.split(':');
                    if((splitStartTime[0]*60*60000) > 86340000){
                        return {statusCode:HttpStatus.BAD_REQUEST ,message: "Start time hours must be less than 23 hours"}
                    }
                    if((splitStartTime[1]*60000) > 3540000){
                        return {statusCode:HttpStatus.BAD_REQUEST ,message: "Start time minutes must be less than 59 minutes"}
                    }
                }
                if(x[y].endTime){
                    let splitEndTime = x[y].endTime.split(':');
                    if((splitEndTime[0]*60*60000) > 86340000){
                        return {statusCode:HttpStatus.BAD_REQUEST ,message: "End time hours must be less than 23 hours"}
                    }
                    if((splitEndTime[1]*60000) > 3540000){
                        return {statusCode:HttpStatus.BAD_REQUEST ,message: "End time minutes must be less than 59 minutes"}
                    }
                }
            }
        }
        if(workScheduleDto.workScheduleConfig){
            let y = workScheduleDto.workScheduleConfig;
            if(y.overBookingType){
                if(y.overBookingType != 'Per Hour' && y.overBookingType != 'Per Day'){
                    console.log("Provide valid overBookingType");
                    return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide valid overBookingType"}
                }
            }
            if(y.overBookingEnabled){
                if(!y.overBookingEnabled){
                    console.log("Provide valid overBookingEnabled");
                    return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide valid overBookingEnabled"}
                }
            }
            if(y.consultationSessionTimings){
                if(!(y.consultationSessionTimings>0 && y.consultationSessionTimings<=60)){
                    console.log("Provide valid consultationSessionTimings");
                    return {statusCode:HttpStatus.BAD_REQUEST ,message: "consultationSessionTimings must be greater than 0 and less than 60 "}
                }
            }
            if(y.overBookingCount){
                if(!(y.overBookingCount>0 && y.overBookingCount<30)){
                    console.log("Provide valid overBookingCount");
                    return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide valid overBookingCount"}
                }
            }
        }

        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(workScheduleDto, req.user)}`);
        return await this.calendarService.workScheduleEdit(workScheduleDto, req.user);
    }

    @Get('doctor/workScheduleView')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Doctors')
    @ApiOkResponse({description: 'request body example:   {"doctorKey": "Doc_5"}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    async workScheduleView(@selfUserSettingRead() check: boolean, @accountUsersSettingsRead() check2: boolean, @Request() req, @Query('doctorKey') doctorKey: String) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(req.user.doctor_key)}`);
        return await this.calendarService.workScheduleView(req.user, doctorKey);
    }

    @Get('doctor/appointmentSlotsView')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Doctors')
    @ApiOkResponse({description: 'request body example:  Doc_5, 0 (default value)'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    async appointmentSlotsView(@selfAppointmentRead() check:boolean, @accountUsersAppointmentRead() check2:boolean, @Request() req, @Query('doctorKey') doctorKey: String, @Query('paginationNumber') paginationNumber: number) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(req.user)}`);
        return await this.calendarService.appointmentSlotsView(req.user, doctorKey,paginationNumber);
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
    @ApiTags('Doctors')
    @ApiBody({type: AppointmentDto})
    async appointmentReschedule(@selfAppointmentWrite() check:boolean,@accountUsersAppointmentWrite() check2:boolean, @Request() req, @Body() appointmentDto: AppointmentDto) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
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
        // const yesterday = new Date(today)
        // yesterday.setDate(yesterday.getDate() - 1)
        // appointmentDto.appointmentDate = moment(appointmentDto.appointmentDate).format();
        // const yesterday = moment().subtract(1, 'days').format()
        var appDate:any = new Date(appointmentDto.appointmentDate);
        var month = appDate.getMonth() + 1
        var date = appDate.getDate();
        var year = appDate.getFullYear();
        appDate = year + "-" + month + "-" + date;
        var today:any = new Date()
        month = today.getMonth() + 1
        date = today.getDate();
        year = today.getFullYear();
        var today1 = year + "-" + month + "-" + date;
        if((appointmentDto.appointmentDate < today)&&!(appDate == today1)){
            return{
                statusCode:HttpStatus.BAD_REQUEST,
                message:"Past Dates are not acceptable"
            }
        }
        this.logger.log(`Doctor config reschedule  Api -> Request data ${JSON.stringify(appointmentDto, req.user)}`);
        const rescheduleAppointment = await this.calendarService.appointmentReschedule(appointmentDto, req.user);

        //Send mail functionality
        if (req.user.email) {
            const template = await this.calendarService.getMessageTemplate({ messageType: 'APPOINTMENT_RESCHEDULE', communicationType: 'Email' });

            if (template && template.data) {
                let data = {
                    email: req.user.email,
                    template: template.data.body,
                    subject: template.data.subject,
                    type: CONSTANT_MSG.MAIL.APPOINTMENT_RESCHEDULE,
                    sender: template.data.sender,
                    user_name: rescheduleAppointment.patientDetail.doctorFirstName + ' ' + rescheduleAppointment.patientDetail.doctorLastName,
                    Details: rescheduleAppointment.patientDetail,
                };

                const sendMail = await this.userService.sendEmailWithTemplate(data,);

                if (sendMail && sendMail.statusCode === HttpStatus.OK) {
                    if (rescheduleAppointment.patientDetail.patientEmail) {
                        const template = await this.calendarService.getMessageTemplate({ messageType: 'APPOINTMENT_RESCHEDULE', communicationType: 'Email' });

                        if (template && template.data) {
                            let data = {
                                email: rescheduleAppointment.patientDetail.patientEmail,
                                template: template.data.body,
                                subject: template.data.subject,
                                type: CONSTANT_MSG.MAIL.APPOINTMENT_RESCHEDULE,
                                sender: template.data.sender,
                                user_name: rescheduleAppointment.patientDetail.patientFirstName + ' ' + rescheduleAppointment.patientDetail.patientLastName,
                                Details: rescheduleAppointment.patientDetail
                            };

                            const sendMail = await this.userService.sendEmailWithTemplate(data);

                            if (sendMail && sendMail.statusCode === HttpStatus.OK) {
                                delete rescheduleAppointment.patientDetail;
                                return rescheduleAppointment;
                            } else {
                                return sendMail;
                            }
                        }
                    }
                }

            }
        }
        return rescheduleAppointment;
    }

    @Post('doctor/appointmentCancel')
    @ApiOkResponse({description: 'Appointment Cancel'})
    @ApiUnauthorizedResponse({description: 'request body example:   {"appointmentId": 28,"confirmation":true}'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Doctors')
    @ApiBody({type: AppointmentDto})
    async appointmentCancel(@selfAppointmentWrite() check:boolean,@accountUsersAppointmentWrite() check2:boolean, @Request() req, @Body() appointmentDto: AppointmentDto) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(!req.body.appointmentId){
            console.log("Provide appointmentId");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide appointmentId"}
        }
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        this.logger.log(`Doctor config cancel  Api -> Request data ${JSON.stringify(appointmentDto, req.user)}`);
        const cancelAppointment = await this.calendarService.appointmentCancel(appointmentDto, req.user);

        //Send mail functionality
        if (req.user.email) {
            const template = await this.calendarService.getMessageTemplate({ messageType: 'APPOINTMENT_CANCEL', communicationType: 'Email' });

            if (template && template.data) {
                let data = {
                    email: req.user.email,
                    template: template.data.body,
                    subject: template.data.subject,
                    type: CONSTANT_MSG.MAIL.APPOINTMENT_CANCEL,
                    sender: template.data.sender,
                    user_name: cancelAppointment.patientDetail.doctorFirstName + ' ' + cancelAppointment.patientDetail.doctorLastName,
                    Details: cancelAppointment.patientDetail,
                };

                const sendMail = await this.userService.sendEmailWithTemplate(data);

                if (sendMail && sendMail.statusCode === HttpStatus.OK) {
                    if (cancelAppointment.patientDetail.email) {
                        const template = await this.calendarService.getMessageTemplate({ messageType: 'APPOINTMENT_CANCEL', communicationType: 'Email' });

                        if (template && template.data) {
                            let data = {
                                email: cancelAppointment.patientDetail.email,
                                template: template.data.body,
                                subject: template.data.subject,
                                type: CONSTANT_MSG.MAIL.APPOINTMENT_CANCEL,
                                sender: template.data.sender,
                                user_name: cancelAppointment.patientDetail.patientFirstName + ' ' + cancelAppointment.patientDetail.patientLastName,
                                Details: cancelAppointment.patientDetail
                            };

                            const sendMail = await this.userService.sendEmailWithTemplate(data);

                            if (sendMail && sendMail.statusCode === HttpStatus.OK) {
                                delete cancelAppointment.patientDetail
                                return cancelAppointment;
                            } else {
                                return sendMail;
                            }
                        }
                    }
                }

            }
        }
        return cancelAppointment;
    }

    @Post('doctor/patientSearch')
    @ApiOkResponse({description: 'request body example:   {"phone": "9999999993"}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Doctors')
    @ApiBody({})
    async patientSearch(@Request() req,@accountSettingsRead() check:boolean, @Body() patientDto: string) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        if(req.body.phone){
            this.logger.log(`Doctor config cancel/reschedule  Api -> Request data ${JSON.stringify(patientDto, req.user)}`);
            return await this.calendarService.patientSearch(patientDto, req.user);
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
    @ApiTags('Doctors')
    @ApiBody({type: AppointmentDto})
    async AppointmentView(@selfAppointmentRead() check:boolean, @accountUsersAppointmentRead() check2:boolean, @Request() req, @Body() appointmentId: AppointmentDto) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        if(!req.body.appointmentId){
            console.log("Provide appointmentId");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide appointmentId"}
        }
        this.logger.log(`Doctor List  Api -> Request data ${JSON.stringify(req.user)}`);
        return await this.calendarService.AppointmentView(req.user, appointmentId);  
    }

    @Get('patient/doctorList')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Patient')
    @ApiOkResponse({description: 'request body example:  Acc_1'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    async doctorListForPatients(@Request() req ,@patient() check:boolean) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.PATIENT){
            await this.calendarService.updatePatLastActive(req.user.patientId);
        }
        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(req.user)}`);
        return await this.calendarService.doctorListForPatients(req.user);
    }

    @Post('patient/findDoctorByCodeOrName')
    @ApiOkResponse({description: 'request body example:   {"codeOrName": "RegD_1"}  or {"codeOrName": "Adithya K"} '})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Patient')
    @ApiBody({type: DoctorDto})
    async findDoctorByCodeOrName(@Request() req, @patient() check:boolean, @Body() codeOrName: DoctorDto) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.PATIENT){
            await this.calendarService.updatePatLastActive(req.user.patientId);
        }
        if(!req.body.codeOrName){
            console.log("Provide codeOrName");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide codeOrName"}
        }
        this.logger.log(`Find Doctor Api -> Request data ${JSON.stringify(req.user)}`);
        return await this.calendarService.findDoctorByCodeOrName(req.user, codeOrName);
    }

    @Post('patient/detailsEdit')
    @ApiOkResponse({
        description: 'requestBody example :   {\n' +
            '"patientId":5,\n' +
            '"email":"nirmala@gmail.com",\n' +
            '"landmark":"landmark", \n' +
            '"country":"country", \n' +
            '"firstName":"name", \n' +
            '"address":"address", \n' +
            '"state":"state", \n' +
            '"pincode":"IN-pincode", \n' +
            '"city":"city", \n' +
            '"dateOfBirth":"dateOfBirth", \n' +
            '"photo":"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSwHKqjyz6NY7C4rDUDSn61fPOhtjT9ifC84w&usqp=CAU" \n' +
            '}'
    })
    @ApiBody({type: PatientDto})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Patient')
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    async patientDetailsEdit(@Request() req,@patient() check:boolean, @Body() patientDto: PatientDto) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.PATIENT){
            await this.calendarService.updatePatLastActive(req.user.patientId);
        }
        if(!req.body.patientId){
            console.log("Provide patientId");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide patientId"}
        }
        if(req.body.patientId !== req.user.patientId){
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.INVALID_REQUEST}
        }
        if(req.body.firstName){
            // patientDto.lastName = "";
            patientDto.name =  req.body.firstName+ " " + patientDto.lastName;
        }
        if(req.body.firstName){
                patientDto.firstName =  req.body.firstName;
                patientDto.name =  req.body.name;
            }
         
        if(req.body.lastName){
                patientDto.lastName =  req.body.lastName;
                patientDto.name =  req.body.name;
            }
        if(req.body.email){
            patientDto.email = req.body.email.toLowerCase()
        }
        function validateEmail(email){
            return /^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[A-Za-z]+$/.test(email);
        }

        if(patientDto.email){ 
            if((patientDto.email).trim()!==""){

               if(!(validateEmail(patientDto.email)))
               {
                  return {statusCode:HttpStatus.BAD_REQUEST ,message: "Invalid Email"}
               }
           
              }
           }

        function validatePincode (pin) {
            if(  pin.length === 6 ) {
              if( /[0-9]/.test(pin))  {
                return true;
              }else {return false;}
            }else {
                return false;
                }
          }
            if(patientDto.pincode){ 
             if((patientDto.pincode).trim()!==""){

                if(!(validatePincode(patientDto.pincode)))
                {
                   return {statusCode:HttpStatus.BAD_REQUEST ,message: "Invalid PinCode"}
                }
            
               }
            }
        this.logger.log(`Patient Details Edit Api -> Request data ${JSON.stringify(patientDto)}`);
        return await this.calendarService.patientDetailsEdit(patientDto);
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
            '"paymentId":176,\n'+
            '"consultationMode":"online" \n' +
            '}'
    })
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Patient')
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBody({type: PatientDto})
    async patientBookAppointment(@Request() req,@patient() check: boolean, @Body() patientDto: AppointmentDto) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.PATIENT){
            await this.calendarService.updatePatLastActive(req.user.patientId);
        }
        if(!req.body.doctorKey){
            console.log("Provide doctorKey");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide doctorKey"}
        } else if(!req.body.appointmentDate){
            console.log("Provide appointmentDate");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide appointmentDate"}
        } else if(!req.body.startTime){
            console.log("Provide startTime");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide startTime"}
        } else if(!req.body.paymentId){
            console.log("Provide paymentId");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide paymentId"}
        }
        patientDto.appointmentDate= new Date(patientDto.appointmentDate);
        // const yesterday = new Date(today)
        // yesterday.setDate(yesterday.getDate() - 1)
        // patientDto.appointmentDate = moment(patientDto.appointmentDate).format();
        // const yesterday = moment().subtract(1, 'days').format()
        var appDate:any = new Date(patientDto.appointmentDate);
        var month = appDate.getMonth() + 1
        var date = appDate.getDate();
        var year = appDate.getFullYear();
        appDate = year + "-" + month + "-" + date;
        var today:any = new Date()
        month = today.getMonth() + 1
        date = today.getDate();
        year = today.getFullYear();
        var today1 = year + "-" + month + "-" + date;
        if((patientDto.appointmentDate < today)&&!(appDate == today1)){
            return{
                statusCode:HttpStatus.BAD_REQUEST,
                message:"Past Dates are not acceptable"
            }
        }
        if(patientDto.patientId !== req.user.patientId){
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.INVALID_REQUEST}
        }
        this.logger.log(`Patient Book Appointment Api -> Request data ${JSON.stringify(patientDto)}`);
        const patientAppointment:any = await this.calendarService.patientBookAppointment(patientDto);

        //Send mail functionality
        if (patientAppointment.patientDetail.email) {
            const template = await this.calendarService.getMessageTemplate({ messageType: 'APPOINTMENT_CREATED', communicationType: 'Email' });

            if (template && template.data) {
                let data = {
                    email: patientAppointment.patientDetail.email,
                    template: template.data.body,
                    subject: template.data.subject,
                    type: CONSTANT_MSG.MAIL.APPOINTMENT_CREATED,
                    sender: template.data.sender,
                    user_name: patientAppointment.patientDetail.doctorFirstName + ' ' + patientAppointment.patientDetail.doctorLastName,
                    Details: patientAppointment.patientDetail,
                };

                const sendMail = await this.userService.sendEmailWithTemplate(data);

                if (sendMail && sendMail.statusCode === HttpStatus.OK) {
                    if (patientAppointment.patientDetail.patientEmail) {
                        const template = await this.calendarService.getMessageTemplate({ messageType: 'APPOINTMENT_CREATED', communicationType: 'Email' });

                        if (template && template.data) {
                            let data = {
                                email: patientAppointment.patientDetail.patientEmail,
                                template: template.data.body,
                                subject: template.data.subject,
                                type: CONSTANT_MSG.MAIL.APPOINTMENT_CREATED,
                                sender: template.data.sender,
                                user_name: patientAppointment.patientDetail.patientFirstName + ' ' + patientAppointment.patientDetail.patientLastName,
                                Details: patientAppointment.patientDetail,
                            };

                            const sendMail = await this.userService.sendEmailWithTemplate(data);

                            if (sendMail && sendMail.statusCode === HttpStatus.OK) {
                                delete patientAppointment.patientDetail
                                return patientAppointment;
                            } else {
                                return sendMail;
                            }
                        }
                    }
                }

            }
        }
           
        return patientAppointment;
    }

    @Post('patient/appointmentSlotsView')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Patient')
    @ApiBody({type: DoctorDto})
    @ApiOkResponse({description: 'request body example: {"doctorKey":"Doc_5","appointmentDate":"2020-08-27","confirmation":true}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    async viewAppointmentSlotsForPatient(@Request() req,@patient() check:boolean,@Body() doctorDto: DoctorDto) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.PATIENT){
            await this.calendarService.updatePatLastActive(req.user.patientId);
        }
        if(!req.body.doctorKey){
            console.log("Provide doctorKey");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide doctorKey"}
        } else if(!req.body.appointmentDate){
            console.log("Provide appointmentDate");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide appointmentDate"}
        } 
        doctorDto.appointmentDate= new Date(doctorDto.appointmentDate);
        // const yesterday = new Date(today)
        // yesterday.setDate(yesterday.getDate() - 1)
        // doctorDto.appointmentDate = moment(doctorDto.appointmentDate).format();
        // const yesterday = moment().subtract(1, 'days').format()
        var appDate:any = new Date(doctorDto.appointmentDate);
        var month = appDate.getMonth() + 1
        var date = appDate.getDate();
        var year = appDate.getFullYear();
        appDate = year + "-" + month + "-" + date;
        var today:any = new Date()
        month = today.getMonth() + 1
        date = today.getDate();
        year = today.getFullYear();
        var today1 = year + "-" + month + "-" + date;
        if((doctorDto.appointmentDate < today)&&!(appDate == today1)){
            return{
                statusCode:HttpStatus.BAD_REQUEST,
                message:"Past Dates are not acceptable"
            }
        }
        this.logger.log(`Doctor View Appointments Slots Api -> Request data ${JSON.stringify(doctorDto)}`);
        return await this.calendarService.viewAppointmentSlotsForPatient(req.user,doctorDto);
    }

    @Get('patient/pastAppointmentsList')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Patient')
    @ApiOkResponse({description: 'request body example:  1'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    async patientPastAppointments(@Request() req, @patient() check: boolean, @Query('limit') limit: Number, @Query('paginationNumber') paginationNumber: Number) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.PATIENT){
            await this.calendarService.updatePatLastActive(req.user.patientId);
        }
        this.logger.log(`Past Appointment Api -> Request data ${JSON.stringify(req.user.patientId)}`);
        return await this.calendarService.patientPastAppointments(req.user.patientId,paginationNumber,limit);
    }

    @Get('patient/upcomingAppointmentsList')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Patient')
    @ApiOkResponse({description: 'request body example:  1'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    async patientUpcomingAppointments( @Request() req, @patient() check: boolean, @Query('limit') limit: number, @Query('paginationNumber') paginationNumber: Number) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.PATIENT){
            await this.calendarService.updatePatLastActive(req.user.patientId);
        }
        this.logger.log(`Upcoming Appointment Api -> Request data ${JSON.stringify(req.user.patientId)}`);
        return await this.calendarService.patientUpcomingAppointments(req.user.patientId,paginationNumber,limit);
    }

    @Get('doctor/patientList')
    @ApiOkResponse({description: 'patientList API'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Doctors')
    async patientList(@Request() req,@selfAppointmentRead() check: boolean, @accountUsersSettingsRead() check2:boolean, @accountUsersAppointmentRead() check3: boolean,  @Query('paginationNumber') paginationNumber: Number) {
        if (!check && !check2 && check3)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        this.logger.log(`Upcoming Appointment Api -> Request data }`);
        return await this.calendarService.patientList(req.user.doctor_key,paginationNumber);
    }

    @Post('doctor/personalSettingsEdit')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Doctors')
    @ApiBody({type: DoctorDto})
    @ApiOkResponse({description: 'request body example:   {"doctorKey": "Doc_5"}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    async doctorPersonalSettingsEdit(@selfUserSettingWrite() check:boolean,@accountUsersSettingsWrite() check2:boolean, @Request() req, @Body() doctorDto: DoctorDto) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        if(!req.body.doctorKey){
            console.log("Provide doctorKey");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide doctorKey"}
        }
        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(doctorDto)}`);
        return await this.calendarService.doctorPersonalSettingsEdit(req.user,doctorDto);
    }

    @Get('doctor/hospitaldetailsView')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Doctors')
    @ApiOkResponse({description: ' '})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    async hospitaldetailsView(@accountSettingsRead() check: boolean, @Request() req , @Query('accountKey') accountKey: String) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        this.logger.log(`Doctor config view  Api -> Request data ${JSON.stringify(req.user)}`);
        return await this.calendarService.hospitaldetailsView(req.user,accountKey);
    }

    @Post('doctor/hospitaldetailsEdit')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Admin')
    @ApiBody({type: DoctorDto})
    @ApiOkResponse({description: 'request body example:   {"accountKey":"Acc_1","hospitalName":"Apollo Hospitals", cityState":"Tamil Nadu","pincode":"600006","country":"India","street1":"Thousand lights","phone":"9623456256","supportEmail":"chennaiapollo@gmail.com","hospitalPhoto":"https://s.ndtvimg.com//images/entities/300/apollo-hospital-chennai_636408444078079763_108400.jpg?q=50","landmark":"Thousand Lights"}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    async hospitaldetailsEdit(@accountSettingsWrite() check:boolean, @Request() req, @Body() hospitalDto: HospitalDto) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        if(!req.body.accountKey){
            console.log("Provide accountKey");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide accountKey"}
        }

        function validateEmail(email){
            return /^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[A-Za-z]+$/.test(email);
        }

        if(hospitalDto.supportEmail){ 
            if((hospitalDto.supportEmail).trim()!==""){

               if(!(validateEmail(hospitalDto.supportEmail)))
               {
                  return {statusCode:HttpStatus.BAD_REQUEST ,message: "Invalid Email"}
               }
           
              }
           }

        function validatePincode (pin) {
            if(  pin.length === 6 ) {
              if( /[0-9]/.test(pin))  {
                return true;
              }else {return false;}
            }else {
                return false;
                }
          }
            if(hospitalDto.pincode){ 
             if((hospitalDto.pincode).trim()!==""){

                if(!(validatePincode(hospitalDto.pincode)))
                {
                   return {statusCode:HttpStatus.BAD_REQUEST ,message: "Invalid PinCode"}
                }
            
               }
            }

        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(hospitalDto)}`);
        return await this.calendarService.hospitaldetailsEdit(req.user,hospitalDto);
    }

    @Get('patient/appointmentDoctorDetails')
    @ApiOkResponse({description: 'request body example:   {"doctorKey": "Doc_5"}'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Patient')
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    async doctorDetails( @Request() req,@patient() check: boolean, @Query('doctorKey') doctorKey: String, @Query('appointmentId') appointmentId: number) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(!doctorKey){
            console.log("Provide doctorKey");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide doctorKey"}
        }
        if(req.user.role == CONSTANT_MSG.ROLES.PATIENT){
            await this.calendarService.updatePatLastActive(req.user.patientId);
        }
        this.logger.log(`View Doctor Details  Api -> Request data ${JSON.stringify(doctorKey)}`);
        return await this.calendarService.doctorDetails(doctorKey,appointmentId);
    }

    @Post('doctor/availableSlots')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Doctors')
    @ApiBody({type: DoctorDto})
    @ApiOkResponse({description: 'request body example:  {"appointmentDate": "2020-08-14","doctorKey":"Doc_5","confirmation":true}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    async availableSlots(@selfAppointmentRead() check:boolean, @accountUsersAppointmentRead() check2:boolean, @Request() req, @Body() doctorDto: DoctorDto) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        doctorDto.appointmentDate = new Date(doctorDto.appointmentDate);
        //var appDate:any = new Date(doctorDto.appointmentDate);
        var month = doctorDto.appointmentDate.getMonth() + 1
        var day = doctorDto.appointmentDate.getDate();
        var year = doctorDto.appointmentDate.getFullYear();
        var appDate:any = year + "-" + month + "-" + day;
        const today = new Date()
        month = today.getMonth() + 1
        day = today.getDate();
        year = today.getFullYear();
        var shortStartDate:any = year + "-" + month + "-" + day;
        if((doctorDto.appointmentDate < today)&&!(appDate == shortStartDate)){
            return{
                statusCode:HttpStatus.BAD_REQUEST,
                message:"Past Dates are not acceptable"
            }
        } 
        this.logger.log(`Doctor availableSlots  Api -> Request data ${JSON.stringify(req.user)}`);
        return await this.calendarService.availableSlots(req.user, doctorDto);
    }

    @Post('doctor/creatingAppointmetAlongWithRegisteringPatient')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Doctors')
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
                                            '"doctorKey":"Doc_5", \n' +
                                            '"paymentOption":"directPayment", \n' +
                                            '"consultationMode":"online" \n' +
                                            '}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    async RegisteringAndCreateApp(@selfAppointmentWrite() check:boolean, @accountUsersAppointmentWrite() check2:boolean, @Request() req, @Body() patientDto: PatientDto) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
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
                    consultationMode:patientDto.consultationMode,
                    doctorKey:patientDto.doctorKey
                }
                appointmentDto.appointmentDate= new Date(appointmentDto.appointmentDate);
                // const yesterday = new Date(today)
                // yesterday.setDate(yesterday.getDate() - 1)
                // appointmentDto.appointmentDate = moment(appointmentDto.appointmentDate).format();
                // const yesterday = moment().subtract(1, 'days').format()
                var appDate:any = new Date(appointmentDto.appointmentDate);
                var month = appDate.getMonth() + 1
                var date = appDate.getDate();
                var year = appDate.getFullYear();
                appDate = year + "-" + month + "-" + date;
                var today:any = new Date()
                month = today.getMonth() + 1
                date = today.getDate();
                year = today.getFullYear();
                var today1 = year + "-" + month + "-" + date;
                if((appointmentDto.appointmentDate < today)&&!(appDate == today1)){
                    return{
                        statusCode:HttpStatus.BAD_REQUEST,
                        message:"Past Dates are not acceptable"
                    }
                }
                this.logger.log(`Appointment  Api -> Request data ${JSON.stringify(appointmentDto, req.user)}`);
                const app = await this.calendarService.createAppointment(appointmentDto, req.user);

                //Send mail functionality
                if (req.user.email && !patient.message && !details.message && !app.message) {
                    const template = await this.calendarService.getMessageTemplate({ messageType: 'PATIENT_REGISTRATION', communicationType: 'Email' });
                    details.password = patient.password;
                    details.phone = patient.phone;
                    if (template && template.data) {
                        let data = {
                            email: req.user.email,
                            template: template.data.body,
                            subject: template.data.subject,
                            type: CONSTANT_MSG.MAIL.PATIENT_REGISTRATION,
                            sender: template.data.sender,
                            user_name: app.patientDetail.doctorFirstName + ' ' + app.patientDetail.doctorLastName,
                            Details: details,
                        };

                        const sendMail = await this.userService.sendEmailWithTemplate(data);

                        if (sendMail && sendMail.statusCode === HttpStatus.OK) {
                            if (details.email) {
                                const template = await this.calendarService.getMessageTemplate({ messageType: 'PATIENT_REGISTRATION', communicationType: 'Email' });

                                if (template && template.data) {
                                    let data = {
                                        email: details.email,
                                        template: template.data.body,
                                        subject: template.data.subject,
                                        type: CONSTANT_MSG.MAIL.PATIENT_REGISTRATION,
                                        sender: template.data.sender,
                                        user_name: details.name,
                                        Details: details,
                                    };

                                    const sendMail = await this.userService.sendEmailWithTemplate(data);

                                    if (sendMail && sendMail.statusCode === HttpStatus.OK) {
                                        return {
                                            patient: patient,
                                            details: details,
                                            appointment: app
                                        }
                                    } else {
                                        return sendMail;
                                    }
                                }
                            }
                        }

                    }
                }
                
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
    @ApiTags('Doctors')
    async patientDetails(@Request() req, @selfAppointmentRead() check:boolean, @accountUsersAppointmentRead() check2:boolean,  @Query('patientId') patientId: number,  @Query('doctorKey') doctorKey: string) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        this.logger.log(`PatientDetails Api -> Request data }`);
        return await this.calendarService.patientDetails(req.user, patientId,doctorKey);
    }

    @Get('admin/reports')
    @ApiOkResponse({description: 'reportsList API'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Admin')
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
    @ApiTags('Patient')
    async listOfDoctorsInHospital(@Request() req, @patient() check: boolean, @Query('accountKey') accountKey: string) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.PATIENT){
            await this.calendarService.updatePatLastActive(req.user.patientId);
        }
        this.logger.log(`listOfDoctorsInHospital Api -> Request data }`);
        return await this.calendarService.listOfDoctorsInHospital(req.user, accountKey);
    }

    @Get('patient/viewDoctorDetails')
    @ApiOkResponse({description: 'viewDoctorDetails API'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Patient')
    async viewDoctorDetails(@Request() req,@patient() check: boolean, @Query('doctorKey') doctorKey: string) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.PATIENT){
            await this.calendarService.updatePatLastActive(req.user.patientId);
        }
        this.logger.log(`viewDoctorDetails Api -> Request data }`);
        return await this.calendarService.viewDoctorDetails(req.user, doctorKey);
    }

    @Post('patient/appointmentCancel')
    @ApiOkResponse({description: 'request body example:   {"appointmentId": 28}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Patient')
    @ApiBody({type: AppointmentDto})
    async appointmentCancelByPatient(@Request() req, @patient() check: boolean, @Body() appointmentDto: AppointmentDto) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.PATIENT){
            await this.calendarService.updatePatLastActive(req.user.patientId);
        }
        if(!req.body.appointmentId){
            console.log("Provide appointmentId");
            return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide appointmentId"}
        }
        this.logger.log(`Patient Appointment cancel Api -> Request data }`);
        const cancelAppointment = await this.calendarService.patientAppointmentCancel(appointmentDto, req.user);

        //Send Mail functionality
        if (cancelAppointment.patientDetail.email) {
            const template = await this.calendarService.getMessageTemplate({ messageType: 'APPOINTMENT_CANCEL', communicationType: 'Email' });

            if (template && template.data) {
                let data = {
                    email: cancelAppointment.patientDetail.email,
                    template: template.data.body,
                    subject: template.data.subject,
                    type: CONSTANT_MSG.MAIL.APPOINTMENT_CANCEL,
                    sender: template.data.sender,
                    user_name: cancelAppointment.patientDetail.doctorFirstName + ' ' + cancelAppointment.patientDetail.doctorLastName,
                    Details: cancelAppointment.patientDetail
                };

                const sendMail = await this.userService.sendEmailWithTemplate(data);

                if (sendMail && sendMail.statusCode === HttpStatus.OK) {
                    if (cancelAppointment.patientDetail.patientEmail) {
                        const template = await this.calendarService.getMessageTemplate({ messageType: 'APPOINTMENT_CANCEL', communicationType: 'Email' });

                        if (template && template.data) {
                            let data = {
                                email: cancelAppointment.patientDetail.patientEmail,
                                template: template.data.body,
                                subject: template.data.subject,
                                type: CONSTANT_MSG.MAIL.APPOINTMENT_CANCEL,
                                sender: template.data.sender,
                                user_name: cancelAppointment.patientDetail.patientFirstName + ' ' + cancelAppointment.patientDetail.patientLastName,
                                Details: cancelAppointment.patientDetail
                            };

                            const sendMail = await this.userService.sendEmailWithTemplate(data);

                            if (sendMail && sendMail.statusCode === HttpStatus.OK) {
                                delete cancelAppointment.patientDetail
                                return cancelAppointment;
                            } else {
                                return sendMail;
                            }
                        }
                    }
                }

            }
        }
        return cancelAppointment
    }

    @Get('doctor/detailsOfPatient')
    @ApiOkResponse({description: 'patientDetails API'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Doctors')
    async detailsOfPatient(@Request() req, @selfAppointmentRead() check:boolean, @accountUsersAppointmentRead() check2:boolean,  @Query('patientId') patientId: number,  @Query('doctorKey') doctorKey: string) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        this.logger.log(`detailsOfPatient Api -> Request data }`);
        return await this.calendarService.detailsOfPatient(req.user, patientId,doctorKey);
    }

    @Post('doctor/patientUpcomingAppList')
    @ApiOkResponse({description: 'request body example:   {"patientId":5,"doctorKey":"Doc_5"}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({type: PatientDto})
    @ApiTags('Doctors')
    async patientUpcomingAppList(@Request() req, @selfAppointmentRead() check:boolean, @accountUsersAppointmentRead() check2:boolean,  @Body() patientDto: PatientDto) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        this.logger.log(`patientUpcomingAppList Api -> Request data }`);
        return await this.calendarService.patientUpcomingAppList(req.user, patientDto);
    }

    @Post('doctor/patientPastAppList')
    @ApiOkResponse({description: 'request body example:   {"patientId":5,"doctorKey":"Doc_5"}'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({type: PatientDto})
    @ApiTags('Doctors')
    async patientPastAppList(@Request() req, @selfAppointmentRead() check:boolean, @accountUsersAppointmentRead() check2:boolean,  @Body() patientDto: PatientDto) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        this.logger.log(`patientPastAppList Api -> Request data }`);
        return await this.calendarService.patientPastAppList(req.user, patientDto);
    }

    @Get('doctor/patientGeneralSearch')
    @ApiOkResponse({description: 'patient Genaral Search API'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Doctors')
    async patientGeneralSearch(@Request() req, @selfAppointmentRead() check:boolean, @accountUsersAppointmentRead() check2:boolean,  @Query('patientSearch') patientSearch: string, @Query('doctorKey') doctorKey: string) {
        if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        this.logger.log(`patient Genaral Search Api -> Request data }`);
        return await this.calendarService.patientGeneralSearch(req.user, patientSearch,doctorKey);
    }

    @Post('patient/patientAppointmentReschedule')
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
    @ApiTags('Patient')
    @ApiBody({type: AppointmentDto})
    async patientAppointmentReschedule(@Request() req,@patient() check: boolean, @Body() appointmentDto: AppointmentDto) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.PATIENT){
            await this.calendarService.updatePatLastActive(req.user.patientId);
        }
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
        // const yesterday = new Date(today)
        // yesterday.setDate(yesterday.getDate() - 1)
        // appointmentDto.appointmentDate = moment(appointmentDto.appointmentDate).format();
        // const yesterday = moment().subtract(1, 'days').format()
        var appDate:any = new Date(appointmentDto.appointmentDate);
        var month = appDate.getMonth() + 1
        var date = appDate.getDate();
        var year = appDate.getFullYear();
        appDate = year + "-" + month + "-" + date;
        var today:any = new Date()
        month = today.getMonth() + 1
        date = today.getDate();
        year = today.getFullYear();
        var today1 = year + "-" + month + "-" + date;
        if((appointmentDto.appointmentDate < today)&&!(appDate == today1)){
            return{
                statusCode:HttpStatus.BAD_REQUEST,
                message:"Past Dates are not acceptable"
            }
        }
        this.logger.log(`patient reschedule  Api -> Request data ${JSON.stringify(appointmentDto, req.user)}`);
        const appointmentReschedule = await this.calendarService.patientAppointmentReschedule(appointmentDto, req.user);

        //send mail functionality
        if (appointmentReschedule.patientDetail.email) {
            const template = await this.calendarService.getMessageTemplate({ messageType: 'APPOINTMENT_RESCHEDULE', communicationType: 'Email' });

            if (template && template.data) {
                let data = {
                    email: appointmentReschedule.patientDetail.email,
                    template: template.data.body,
                    subject: template.data.subject,
                    type: CONSTANT_MSG.MAIL.APPOINTMENT_RESCHEDULE,
                    sender: template.data.sender,
                    user_name: appointmentReschedule.patientDetail.doctorFirstName + ' ' + appointmentReschedule.patientDetail.doctorLastName,
                    Details: appointmentReschedule.patientDetail
                };

                const sendMail = await this.userService.sendEmailWithTemplate(data);

                if (sendMail && sendMail.statusCode === HttpStatus.OK) {
                    if (appointmentReschedule.patientDetail.patientEmail) {
                        const template = await this.calendarService.getMessageTemplate({ messageType: 'APPOINTMENT_RESCHEDULE', communicationType: 'Email' });

                        if (template && template.data) {
                            let data = {
                                email: appointmentReschedule.patientDetail.patientEmail,
                                template: template.data.body,
                                subject: template.data.subject,
                                type: CONSTANT_MSG.MAIL.APPOINTMENT_RESCHEDULE,
                                sender: template.data.sender,
                                user_name: appointmentReschedule.patientDetail.patientFirstName + ' ' + appointmentReschedule.patientDetail.patientLastName,
                                Details: appointmentReschedule.patientDetail
                            };

                            const sendMail = await this.userService.sendEmailWithTemplate(data);

                            if (sendMail && sendMail.statusCode === HttpStatus.OK) {
                                delete appointmentReschedule.patientDetail
                                return appointmentReschedule;
                            } else {
                                return sendMail;
                            }
                        }
                    }
                }

            }
        }
        return appointmentReschedule;
    }


    @Post('payment/order')
    @ApiOkResponse({
        description: 'requestBody example :   { "amount":"100" }'
    })
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Payment')
    @ApiBody({type: AccountDto})
    paymentOrder(@Request() req, @Body() accountDto: AccountDto) {
        this.logger.log(`getting paymentOrder  Api -> Request data ${JSON.stringify(accountDto, req.user)}`);
        return this.calendarService.paymentOrder(accountDto, req.user);
    }

    @Post('payment/verification')
    @ApiOkResponse({
        description: 'requestBody example :   {"razorpay_order_id": "order_FV6u13eob2vaLE","razorpay_payment_id": "pay_FV6uMsxQHGLJwC","razorpay_signature": "d4adf91d6277a9ef0350638e6370b148ab372be11da2c002d101b56814688cb3"}'
    })
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Payment')
    @ApiBody({type: AccountDto})
    paymentVerification(@Request() req, @Body() accountDto: AccountDto) {
        this.logger.log(`getting paymentOrder  Api -> Request data ${JSON.stringify(accountDto, req.user)}`);

        if(!req.email) {
            const updateEmail = async () => {
                const pymntRecipt = await this.calendarService.paymentReciptDetails(req.body.razorpay_payment_id)
                if(!!pymntRecipt?.email) {
                    this.calendarService.patientDetailsEdit({
                        patientId: req.body?.patientId,
                        email: pymntRecipt?.email
                    })
                }
            }
            updateEmail()
        }

        return this.calendarService.paymentVerification(accountDto, req.user);
    }

    @Get('patient/viewPatientDetails')
    @ApiOkResponse({description: 'viewPatientDetails API'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Patient')
    async viewPatientDetails(@Request() req,@patient() check: boolean, @Query('patientId') patientId: number) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.PATIENT){
            await this.calendarService.updatePatLastActive(req.user.patientId);
        }
        this.logger.log(`viewDoctorDetails Api -> Request data }`);
        if(req.user.patientId == patientId){
            return await this.calendarService.getPatientDetails(patientId);
        }else{
            return{
                statusCode:HttpStatus.BAD_REQUEST,
                message:CONSTANT_MSG.INVALID_REQUEST
            }
        }
        
    }

    @Get('patient/appointmentPresentOnDate')
    @ApiOkResponse({description: 'appointmentPresentOnDate API'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Patient')
    async appointmentPresentOnDate(@Request() req,@patient() check: boolean, @Query('appointmentDate') appointmentDate: string, @Query('doctorKey') doctorKey: string) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.PATIENT){
            await this.calendarService.updatePatLastActive(req.user.patientId);
        }
        // const appDate = new Date(appointmentDate);
        // const today = new Date()
        // const yesterday = new Date(today)
        // yesterday.setDate(yesterday.getDate() - 1)
        // const appDate = moment(appointmentDate).format();
        // const yesterday = moment().subtract(1, 'days').format()
        var appDate1 = new Date(appointmentDate);
        var appDate:any = new Date(appointmentDate);
        var month = appDate.getMonth() + 1
        var date = appDate.getDate();
        var year = appDate.getFullYear();
        appDate = year + "-" + month + "-" + date;
        var today:any = new Date()
        month = today.getMonth() + 1
        date = today.getDate();
        year = today.getFullYear();
        var today1 = year + "-" + month + "-" + date;
        if((appDate1 < today)&&!(appDate == today1)){
            return{
                statusCode:HttpStatus.BAD_REQUEST,
                message:"Past Dates are not acceptable"
            }
        }
        this.logger.log(`appointmentPresentOnDate Api -> Request data }`);
        return this.calendarService.appointmentPresentOnDate(req.user,appDate,doctorKey);
    }


    @Get('admin/patients')
    @ApiOkResponse({description: 'patientList API'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Admin')
    async accountPatientsList(@Request() req, @accountSettingsRead() check:boolean, @Query('accountKey') accountKey: string) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        this.logger.log(`account patientsList Api -> Request data }`);
        return await this.calendarService.accountPatientsList(req.user, accountKey);
    }

    @Post('payment/createPaymentLink')
    @ApiOkResponse({
        description: 'requestBody example :   {"customer": {"name": "Acme Enterprises", "email": "admin@aenterprises.com","contact": "9999999999"}, "type": "link", "view_less": 1,"amount": 6742,"currency": "INR", "description": "Payment Link for this purpose - cvb.","receipt": "#TS1989","sms_notify": 1, "email_notify": 1, "expire_by": 1793630556 }'
    })
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Payment')
    @ApiBody({type: AccountDto})
    createPaymentLink(@Request() req, @Body() accountDto: any) {
        this.logger.log(`getting paymentOrder  Api -> Request data ${JSON.stringify(accountDto, req.user)}`);
        return this.calendarService.createPaymentLink(accountDto, req.user);
    }

    @Get('patient/listOfHospitals')
    @ApiOkResponse({description: 'listOfHospitals API'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Patient')
    async listOfHospitals(@Request() req, @patient() check: boolean) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.PATIENT){
            await this.calendarService.updatePatLastActive(req.user.patientId);
        }
        this.logger.log(`listOfHospitals Api -> Request data }`);
        return await this.calendarService.listOfHospitals(req.user);
    }

    @Post('doctor/prescription/add')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Doctors')
    @ApiBody({ type: PrescriptionDto })
    @ApiOkResponse({ description: 'request body example:    {"appointmentId": "251", "prescriptionList" : [{"medicineList": [{"nameOfMedicine":"syrup", "countOfDays":"30", "doseOfMedicine":"10 ml"},{"nameOfMedicine":"syrup", "countOfDays":"30", "doseOfMedicine":"10 ml"}]},{"medicineList": [{"nameOfMedicine":"syrup", "countOfDays":"30", "doseOfMedicine":"10 ml"}]}]}' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    async prescriptionInsertion(@selfUserSettingWrite() check: boolean, @accountUsersSettingsWrite() check2: boolean, @Request() req, @Body() prescriptionDto: any) {
        // N number of prescription allowed for an appointment
        if (!check)
            return { statusCode: HttpStatus.BAD_REQUEST, message: CONSTANT_MSG.NO_PERMISSION }
        if (req.user.role == CONSTANT_MSG.ROLES.DOCTOR) {
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        
        // Checking medicine is added or not
        if (prescriptionDto && prescriptionDto.prescriptionList && prescriptionDto.prescriptionList.length 
            && prescriptionDto.prescriptionList[0].medicineList && prescriptionDto.prescriptionList[0].medicineList.length) {
            this.logger.log(`Doctor prescriptionInsertion  Api -> Request data ${JSON.stringify(prescriptionDto)}`);
            return await this.calendarService.prescriptionInsertion(req.user, prescriptionDto);    
        } else {
            return { statusCode: HttpStatus.NO_CONTENT, message: CONSTANT_MSG.NO_PRESCRIPTION }
        }
        
    }

    
  //Patient report upload

  @Post('patient/report/upload')
  @ApiOkResponse({
    description:
      'requestBody example :   {\n' +
      '"files":"fileList",\n'+
      '"patientId":560,\n' +
      '}',
  })
  @ApiBody({ type: patientReportDto })
  @ApiBearerAuth('JWT')
  @UseGuards(AuthGuard())
  @ApiTags('Patient')
  @Roles('patient')
  @UseInterceptors(FileInterceptor('files'))
  async uploadFile(@UploadedFile() file, @Body() body) {
    console.log(file);
    console.log(body);
    const reports = {
      file: file,
      data : body
    }
    if (!body.patientId) {
      console.log('Provide patientId');
      return {
        statusCode: HttpStatus.BAD_REQUEST,
        message: 'Provide patientId',
      };
    } else {

      return await this.calendarService.patientReport(reports);
    }
  }

   //patient report list
   @Get('patient/report/list')
   @ApiOkResponse({description: 'reportList API'})
   @ApiUnauthorizedResponse({description: 'Invalid credentials'})
   @ApiBearerAuth('JWT')
   @UseGuards(AuthGuard())
   @ApiTags('Patient')
   @ApiQuery({ name: 'searchText', required: false })
   async reportList(@Request() req, @patient() check:boolean, @Query('paginationStart') paginationStart: number,@Query('searchText') searchText: string,
    @Query('paginationLimit') paginationLimit: number,@Query('appointmentId') appointmentId : number  ) {
      const data={
        user : req.user,
        paginationStart : paginationStart,
        paginationLimit : paginationLimit,
        patientId : req.user.patientId,
        searchText : searchText,
        appointmentId : appointmentId
       } 
        if (!check){
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
            this.logger.log(`admin reports Api -> Request data }`);
        } else{
          return this.calendarService.reportList(data);
        }
   }

    // upload doctor signature    
    @Post('dotor/signature/upload')
    @ApiConsumes('multipart/form-data')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @UseInterceptors(FileInterceptor('file'))
     @ApiBody({
        schema: {
        type: 'object',
        properties: {
            file: {
            type: 'string',
            format: 'binary',
             },
            "doctorId":{
                "type":"string",
                "description":"...",
                "example":"1"
             }
        },
        },
    })
    @ApiTags('Doctors')
    @ApiOkResponse({
          description:
            'requestBody example :   {\n' +
             '"file":"file",\n'+
            '"doctorId":2,\n' +
            '}',
        })
    async uploadedFile(@UploadedFile() file, @Body() body) {
    
    const reports = {
        file: file,
       data : body
     }

     if (!body.doctorId) {
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: 'Provide doctorId',
        };
      } else {
       
        
        let data = await this.calendarService.addDoctorSinature(reports);
         return data;
        }
  }

  //file upload
  @Post('patient/fileupload')
  @ApiOkResponse({
    description:
      'requestBody example :   {\n' +
      '"files":"fileList",\n'+
      '"patientId":560,\n' +
      '}',
  })
  @ApiBody({ type: patientReportDto })
  @ApiBearerAuth('JWT')
  @UseGuards(AuthGuard())
  @ApiTags('Patient')
  @Roles('patient')
  @UseInterceptors(FileInterceptor('files'))
  async fileUpload(@UploadedFile() file, @Body() body) {
    const files = {
      file: file,
      data : body
    }
        let data = await this.calendarService.uploadFile(files);
      return data;
  }

  
   //patient report in patient detail page
   @Get('doctor/patientDetailLabReport')
   @ApiOkResponse({description: 'patientDetailLabReport API'})
   @ApiUnauthorizedResponse({description: 'Invalid credentials'})
   @ApiBearerAuth('JWT')
   @UseGuards(AuthGuard())
   @ApiTags('Doctors')
   async patientDetailLabReport(@Request() req, @selfAppointmentRead() check:boolean, @accountUsersAppointmentRead() check2:boolean,  @Query('patientId') patientId: number) {
    if (!check && !check2)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        this.logger.log(`patientDetailLabReport Api -> Request data }`);
        const PatientDetailReport = await this.calendarService.patientDetailLabReport(req.user, patientId, req.user.doctor_key);
        return PatientDetailReport;
    }

   //Appointment list report 
   @Get('doctor/appoinmentListReport')
   @ApiOkResponse( {description:  'requestBody example :   {\n' +
   '"paginationStart":0,\n'+
   '"paginationLimit":15,\n' +
   '"searchText":"name",\n '+
   '}',})
   @ApiUnauthorizedResponse({description: 'Invalid credentials'})
   @ApiBearerAuth('JWT')
   @UseGuards(AuthGuard())
   @ApiTags('Doctors')
   @ApiQuery({ name: 'searchText', required: false })
    @ApiQuery({ name: 'toDate', required: false })
   async appoinmentListReport(@Request() req, @selfAppointmentRead() check:boolean, 
    @accountUsersAppointmentRead() check2:boolean,  @Query('paginationStart') paginationStart: number, 
    @Query('searchText') searchText: string,
    @Query('paginationLimit') paginationLimit: number, @Query('fromDate') fromDate: string, 
    @Query('toDate') toDate: string ) {
    
    // check doctor & admin permission
    if (!check && !check2 && 
        (req.user.role == CONSTANT_MSG.ROLES.DOCTOR || req.user.role == CONSTANT_MSG.ROLES.ADMIN ||
        req.user.role == CONSTANT_MSG.ROLES.DOC_ASSISTANT)) {
        return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
    }
    
    // Update last active status
    if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR) {
        await this.calendarService.updateDocLastActive(req.user.doctor_key);
    }
    
    const data={
        user : req.user,
        paginationStart : paginationStart,
        paginationLimit : paginationLimit,
        searchText : searchText,
        fromDate : fromDate,
        toDate : toDate,
    }
    
    // Get appointment list
    return await this.calendarService.appoinmentListReport(data);

    }
   
     //Amount list report 
   @Get('doctor/amountListReport')
   @ApiOkResponse( {description:  'requestBody example :   {\n' +
   '"paginationStart":0,\n'+
   '"paginationLimit":15,\n' +
   '"searchText":"name",\n '+
   '}',})
   @ApiUnauthorizedResponse({description: 'Invalid credentials'})
   @ApiBearerAuth('JWT')
   @UseGuards(AuthGuard())
   @ApiTags('Doctors')
   @ApiQuery({ name: 'searchText', required: false })
   @ApiQuery({ name: 'toDate', required: false })
   async amountListReport(@Request() req, @selfAppointmentRead() check: boolean, 
    @accountUsersAppointmentRead() check2: boolean, @Query('paginationStart') paginationStart: number, 
    @Query('searchText') searchText: string, @Query('paginationLimit') paginationLimit: number,
    @Query('fromDate') fromDate: string, @Query('toDate') toDate: string) {

       // check doctor & admin permission
       if (!check && !check2 &&
           (req.user.role == CONSTANT_MSG.ROLES.DOCTOR || req.user.role == CONSTANT_MSG.ROLES.ADMIN ||
               req.user.role == CONSTANT_MSG.ROLES.DOC_ASSISTANT)) {
           return { statusCode: HttpStatus.BAD_REQUEST, message: CONSTANT_MSG.NO_PERMISSION }
       }

       // Update last active status
       if (req.user.role == CONSTANT_MSG.ROLES.DOCTOR) {
           await this.calendarService.updateDocLastActive(req.user.doctor_key);
       }

       const data = {
           user: req.user,
           paginationStart: paginationStart,
           paginationLimit: paginationLimit,
           searchText: searchText,
           fromDate: fromDate,
           toDate: toDate,
       };
       return await this.calendarService.amountListReport(data);

   }

    //Getting advertisement list
    @Get('advertisementList')
    @ApiOkResponse({ description: 'advertisementList API' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    advertisementList(@Request() req) {

        this.logger.log(`advertisement List Api -> Request data }`);
        try {
            return this.calendarService.advertisementList(req.user);
        } catch (e) {
            return e;
            console.log(e);
        }
    }

}
