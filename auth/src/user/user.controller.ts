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

        let docLoginResponse = {
            "doctorKey": doctor.doctor_key,
            "accountKey": doctor.account_key,
            "role":doctor.role,
            "accessToken": doctor.accessToken,
            "rolesPermission": doctor.rolesPermission,
            "accountName":doctor.accountName
        };

        console.log('returning doc login in auth ', docLoginResponse);

        return docLoginResponse;
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
                accessToken:patient.accessToken,
                password:patient.password
            } 
        }
        
    };

    @MessagePattern({cmd: 'auth_doctor_reset_password'})
    async doctorsResetPassword(userDto: any): Promise<any> {
        const user = await this.userService.doctorsResetPassword(userDto);
        if(user){
            return user;
        }else{
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.USER_NOT_FOUND
            }
        }
    }

    @MessagePattern({ cmd: 'auth_doctor_registration' })
    async doctorRegistration(doctorDto: any): Promise<any> {

        if (!doctorDto.isNewAccount) {            
            if (!doctorDto.accountId) {
                var account = await this.accountRepository.findOne({ account_key: doctorDto.user.account_key })
                doctorDto.accountId = account.account_id;
            } else{
                var accountDet =  await this.accountRepository.findOne({ account_id: doctorDto.accountId })
                if(accountDet.account_key != doctorDto.user.account_key){
                    return {
                        statusCode: HttpStatus.BAD_REQUEST,
                        message: CONSTANT_MSG.DOC_REG_HOS_RES,
                    }
                }
            }
           
            const doctor = await this.userService.doctorRegistration(doctorDto);
            if (doctor.message) {
                return doctor;
            } else {
                return {
                    email: doctor.email,
                    userId: doctor.id,
                    doctorKey: doctor.doctor_key,
                    accountKey: account ? account.account_key: '',
                    experience: doctor.experience ? doctor.experience : null,
                    speciality: doctor.speciality ? doctor.speciality : null,
                    qualification: doctor.qualification ? doctor.qualification : null,
                    photo: doctor.photo ? doctor.photo : null,
                    number: doctor.number ? doctor.number : null,
                    signature: doctor.signature ? doctor.signature : null,
                    name: doctor.name ? doctor.name : '',
                }
            }
        } else {
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: 'Under development'
            }
        }

    };

    @MessagePattern({cmd: 'auth_account_registration'})
    async accountRegistration(user: any): Promise<any> {
        return await this.userService.accountRegistration(user.doctorDto);
    };

    @MessagePattern({cmd: 'auth_doctor_forgotpassword'})
    async doctorForgotPassword(user: any): Promise<any> {
        const doctor = await this.userService.doctorForgotPassword(user.email);
        return doctor;
    }

    @MessagePattern({cmd: 'auth_patient_forgotpassword'})
    async patientForgotPassword(patientDto: PatientDto): Promise<any> {
        const forgotPassword = await this.userService.patientForgotPassword(patientDto);
        return forgotPassword;
    }

    @MessagePattern({cmd: 'auth_patient_resetpassword'})
    async patientResetPassword(patientDto: any): Promise<any> {
        const user = await this.userService.patientResetPassword(patientDto);
        if(user){
            return user;
        }else{
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.USER_NOT_FOUND
            }
        }
    }

    @MessagePattern({cmd: 'auth_patient_changepassword'})
    async patientChangePassword(patientDto: any): Promise<any> {
        const user = await this.userService.patientChangePassword(patientDto);
        if(user){
            return user;
        }else{
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.USER_NOT_FOUND
            }
        }
    }

    @MessagePattern({cmd: 'auth_doctor_changepassword'})
    async doctorChangePassword(patientDto: any): Promise<any> {
        const user = await this.userService.doctorChangePassword(patientDto);
        if(user){
            return user;
        }else{
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.USER_NOT_FOUND
            }
        }
    }

    @MessagePattern({cmd: 'auth_patient_otp_verification'})
    async OTPVerification(patientDto: PatientDto): Promise<any> {
        const otpVerification = await this.userService.OTPVerification(patientDto);
        return otpVerification;
    }

    @MessagePattern({cmd: 'auth_patient_login_for_phone'})
    async patientLoginForPhone(patientDto: PatientDto): Promise<any> {
        const patient = await this.userService.patientLoginForPhone(patientDto.phone);
        return patient;
    }
    
    @MessagePattern({cmd: 'auth_send_email_with_template'})
    async sendMailWithTemplate(data: any): Promise<any> {
        const template = await this.userService.sendEmailWithTemplate(data);
        return template;
    }
}
