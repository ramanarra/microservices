import {Controller, UseFilters, Body, Logger, Inject} from '@nestjs/common';
import {MessagePattern} from '@nestjs/microservices';
import {UserService} from './user.service';
import {UserDto,PatientDto} from 'common-dto';
import {AllExceptionsFilter} from 'src/common/filter/all-exceptions.filter';
import {ClientProxy} from "@nestjs/microservices";
import {async} from 'rxjs/internal/scheduler/async';

@Controller('user')
@UseFilters(AllExceptionsFilter)
export class UserController {

    private logger = new Logger('UserController');


    constructor(private readonly userService: UserService) {

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
        return {
            "accessToken": doctor.accessToken,
            // "rolesPermission": doctor.rolesPermission,
            "patientId":doctor.patient_id
        }
    };

    
    @MessagePattern({cmd: 'auth_patient_registration'})
    async patientRegistration(patientDto: PatientDto): Promise<any> {
        const patient = await this.userService.patientRegistration(patientDto);
        return patient;
    };

    @MessagePattern({cmd: 'auth_roles_permission'})
    async rolesPermission(role: string): Promise<any> {
        const user = await this.userService.getRolesPermisssion(role);
        return user;
    }


}
