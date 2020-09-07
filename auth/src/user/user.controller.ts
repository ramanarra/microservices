import {Controller, UseFilters, Body, Logger,HttpStatus, Inject} from '@nestjs/common';
import {MessagePattern} from '@nestjs/microservices';
import {UserService} from './user.service';
import {AccountRepository} from './account.repository';
import {UserDto,PatientDto,DoctorDto,CONSTANT_MSG} from 'common-dto';
import {AllExceptionsFilter} from 'src/common/filter/all-exceptions.filter';
import {ClientProxy} from "@nestjs/microservices";
import {async} from 'rxjs/internal/scheduler/async';

@Controller('user')
@UseFilters(AllExceptionsFilter)
export class UserController {

    private logger = new Logger('UserController');


    constructor(private readonly userService: UserService,private accountRepository:AccountRepository) {

    }


    @MessagePattern({cmd: 'auth_user_validate_email_password'})
    async login(userDto: UserDto): Promise<any> {
        this.logger.log(" login  service >> " + userDto);
        const user = await this.userService.validateEmailPassword(userDto);
        this.logger.log("asfn >>> " + user);
        return user;
    }


    @MessagePattern({cmd: 'auth_user_find_by_email'})
    async findByEmail(email: string): Promise<any> {
        const user = await this.userService.findByEmail(email);
        return user;
    }

    @MessagePattern({cmd: 'auth_patient_find_by_phone'})
    async findByPhone(phone: string): Promise<any> {
        const user = await this.userService.findByPhone(phone);
        return user;
    }


    @MessagePattern({cmd: 'auth_doctor_login'})
    async doctorLogin(doctorDto: any): Promise<any> {
        const {email, password} = doctorDto;
        const doctor = await this.userService.doctor_Login(email, password);
        if(doctor.message == CONSTANT_MSG.INVALID_CREDENTIALS){
            return{
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_CREDENTIALS
            }
        }
        return {
            "doctorKey": doctor.doctor_key,
            "accountKey": doctor.account_key,
            "role":doctor.role,
            "accessToken": doctor.accessToken,
            "rolesPermission": doctor.rolesPermission
        }
    };

    @MessagePattern({cmd: 'auth_patient_login'})
    async patientLogin(patientDto: any): Promise<any> {
        const {phone, password} = patientDto;
        const doctor = await this.userService.patientLogin(phone, password);
        if(doctor.message ){
            return{doctor}
        }
        return {
            "accessToken": doctor.accessToken,
            "patientId":doctor.patient_id
        }
    };

    
    @MessagePattern({cmd: 'auth_patient_registration'})
    async patientRegistration(patientDto: PatientDto): Promise<any> {
        const patient = await this.userService.patientRegistration(patientDto);
        if(patient.message){
            return patient;
        } else if(patient.update){
            return patient
        } else {
            return{
                phone:patient.phone,
                patientId:patient.patient_id,
                accessToken:patient.accessToken
            } 
        }
        
    };

    @MessagePattern({cmd: 'auth_doctor_forgot_password'})
    async doctorsForgotPassword(user: any): Promise<any> {
        const doctor = await this.userService.doctorForgotPassword(user);
        if(doctor.message == CONSTANT_MSG.INVALID_CREDENTIALS){
            return{
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_CREDENTIALS
            }
        }
        return {
            "doctorKey": doctor.doctor_key,
            "accountKey": doctor.account_key,
            "role":doctor.role,
            "accessToken": doctor.accessToken,
            "rolesPermission": doctor.rolesPermission
        }
    };

    @MessagePattern({cmd: 'auth_doctor_registration'})
    async doctorRegistration(doctorDto: any): Promise<any> {
        var account = await this.accountRepository.findOne({account_id:doctorDto.accountId})
        if(account.account_key == doctorDto.user.account_key){
            if(!doctorDto.accountId){
                doctorDto.accountId = account.account_id;
            }
            const doctor = await this.userService.doctorRegistration(doctorDto);
            if(doctor.message){
                return doctor;
            }else {
                return{
                    email:doctor.email,
                    userId:doctor.id,
                    doctorKey:doctor.doctor_key,
                    accountKey:account.account_key
                } 
            }
        }else{
            return{
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }
        
    };


}
