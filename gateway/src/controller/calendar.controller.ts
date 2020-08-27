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
    ApiBadRequestResponse,
    ApiTags
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
    PatientDto,CONSTANT_MSG,HospitalDto, AccountDto
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
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        return await this.calendarService.createAppointment(appointmentDto, req.user);
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
        }else if(req.body.isPatientCancellationAllowed){
            let cTime=docConfigDto.cancellationHours+':'+docConfigDto.cancellationMins;
            if(docConfigDto.cancellationDays == 0){
                const canTime= await this.calendarService.getMilli(cTime);
                if(canTime < 600000){
                    console.log("cancellation time should be greater than 10 minutes");
                    return {statusCode:HttpStatus.BAD_REQUEST ,message: "cancellation time should be greater than 10 minutes"}
                }
            }           
        }else if(req.body.isPatientRescheduleAllowed){
            let rTime=docConfigDto.rescheduleHours+':'+docConfigDto.rescheduleMins;
            if(docConfigDto.rescheduleDays == 0){
                const canTime= await this.calendarService.getMilli(rTime);
                if(canTime < 600000){
                    console.log("reschedule time should be greater than 10 minutes");
                    return {statusCode:HttpStatus.BAD_REQUEST ,message: "reschedule time should be greater than 10 minutes"}
                }
            }           
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
        // if(!req.body.doctorKey){
        //     console.log("Provide doctorKey");
        //     return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide doctorKey"} 
        // }else if(workScheduleDto.updateWorkSchedule){
        //     let y;
        //     let x=workScheduleDto.updateWorkSchedule
        //     for(y=0;y<=workScheduleDto.updateWorkSchedule.length;y++){
        //         if(!x[y].scheduledayid){
        //             console.log("Provide scheduledayid");
        //             return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide scheduledayid"}  
        //         }else if(!x[y].startTime){
        //             console.log("Provide startTime");
        //             return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide startTime"}
        //         }else if(x[y].startTime){
        //             console.log(x[y].startTime);
        //             const start = await this.calendarService.getMilli(x.startTime);
        //             console.log(start);
        //             const base = await this.calendarService.getMilli('23:59');
        //             if(start>base){
        //                 console.log("Time must be in military time format");
        //                 return {statusCode:HttpStatus.BAD_REQUEST ,message: "Start time must be in military time format"}
        //             }
        //         }else if(!x[y].endTime){
        //             console.log("Provide endTime");
        //             return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide endTime"}
        //         }else if(x[y].endTime){
        //             const end = await this.calendarService.getMilli(x[y].endTime);
        //             const base = await this.calendarService.getMilli('23:59');
        //             if(end>base){
        //                 console.log("End time must be in military time format");
        //                 return {statusCode:HttpStatus.BAD_REQUEST ,message: "End time must be in military time format"}
        //             }
        //         }else if(!x[y].isDelete){
        //             console.log("Provide isDelete");
        //             return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide isDelete"}
        //         }
        //     }
        //     // workScheduleDto.updateWorkSchedule.forEach(async x => {
        //     //     if(!x.scheduledayid){
        //     //         console.log("Provide scheduledayid");
        //     //         return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide scheduledayid"}  
        //     //     }else if(!x.startTime){
        //     //         console.log("Provide startTime");
        //     //         return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide startTime"}
        //     //     }else if(x.startTime){
        //     //         console.log(x.startTime);
        //     //         const start = await this.calendarService.getMilli(x.startTime);
        //     //         const base = await this.calendarService.getMilli('23:59');
        //     //         if(start>base){
        //     //             console.log("Time must be in military time format");
        //     //             return {statusCode:HttpStatus.BAD_REQUEST ,message: "Start time must be in military time format"}
        //     //         }
        //     //     }else if(!x.endTime){
        //     //         console.log("Provide endTime");
        //     //         return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide endTime"}
        //     //     }else if(x.endTime){
        //     //         const end = await this.calendarService.getMilli(x.endTime);
        //     //         const base = await this.calendarService.getMilli('23:59');
        //     //         if(end>base){
        //     //             console.log("End time must be in military time format");
        //     //             return {statusCode:HttpStatus.BAD_REQUEST ,message: "End time must be in military time format"}
        //     //         }
        //     //     }else if(!x.isDelete){
        //     //         console.log("Provide isDelete");
        //     //         return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide isDelete"}
        //     //     }
        //     // });
        // }else if(workScheduleDto.workScheduleConfig){
        //     let y = workScheduleDto.workScheduleConfig;
        //     if(y.overBookingType != 'Per Hour' && y.overBookingType != 'Per Day'){
        //         console.log("Provide valid overBookingType");
        //         return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide valid overBookingType"}
        //     }else if(y.overBookingCount){
        //         if(!(y.overBookingCount>0 && y.overBookingCount<30)){
        //             console.log("Provide valid overBookingCount");
        //             return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide valid overBookingCount"}
        //         }
        //     }else if(!y.overBookingEnabled){
        //         console.log("Provide valid overBookingEnabled");
        //         return {statusCode:HttpStatus.BAD_REQUEST ,message: "Provide valid overBookingEnabled"}
        //     }else if(y.consultationSessionTimings){
        //         if(y.consultationSessionTimings>0 && y.consultationSessionTimings<=60){
        //             console.log("Provide valid consultationSessionTimings");
        //             return {statusCode:HttpStatus.BAD_REQUEST ,message: "consultationSessionTimings must be greater than 0 and less than 60 "}
        //         }
        //     }
        // }

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
        return await this.calendarService.appointmentReschedule(appointmentDto, req.user);
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
        return await this.calendarService.appointmentCancel(appointmentDto, req.user);
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
    @ApiTags('Patient')
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    @ApiBody({type: PatientDto})
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
        return await this.calendarService.patientBookAppointment(patientDto);
    }

    @Post('patient/appointmentSlotsView')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Patient')
    @ApiBody({type: DoctorDto})
    @ApiOkResponse({description: 'request body example:  Doc_5, 2020-05-05'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    async viewAppointmentSlotsForPatient(@Request() req,@patient() check:boolean,@Body() doctorDto: DoctorDto) {
        if (!check)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.PATIENT){
            await this.calendarService.updatePatLastActive(req.user.patientId);
        }
        this.logger.log(`Doctor View  Api -> Request data ${JSON.stringify(doctorDto)}`);
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
    async patientList(@Request() req,@selfAppointmentRead() check: boolean, @accountUsersSettingsRead() check2:boolean, @accountUsersAppointmentRead() check3: boolean,  @Query('doctorKey') doctorKey: String) {
        if (!check && !check2 && check3)
            return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
        if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            await this.calendarService.updateDocLastActive(req.user.doctor_key);
        }
        this.logger.log(`Upcoming Appointment Api -> Request data }`);
        return await this.calendarService.patientList(doctorKey);
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
    @ApiOkResponse({description: 'request body example:   {"doctorKey": "Doc_5"}'})
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
        let date = new Date(doctorDto.appointmentDate);    
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
    @ApiOkResponse({description: 'patientList API'})
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
        return await this.calendarService.patientAppointmentCancel(appointmentDto, req.user);
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
        this.logger.log(`patientUpcomingAppList Api -> Request data }`);
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
        const today = new Date()
        const yesterday = new Date(today)
        yesterday.setDate(yesterday.getDate() - 1)
        if(appointmentDto.appointmentDate < yesterday){
            return{
                statusCode:HttpStatus.BAD_REQUEST,
                message:"Past Dates are not acceptable"
            }
        }
        this.logger.log(`patient reschedule  Api -> Request data ${JSON.stringify(appointmentDto, req.user)}`);
        return await this.calendarService.patientAppointmentReschedule(appointmentDto, req.user);
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
        const appDate = new Date(appointmentDate);
        const today = new Date()
        const yesterday = new Date(today)
        yesterday.setDate(yesterday.getDate() - 1)
        if(appDate < yesterday){
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
    

}
