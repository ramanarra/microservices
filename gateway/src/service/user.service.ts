import { Injectable, Inject, UseFilters, RequestTimeoutException, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { ClientProxy } from "@nestjs/microservices";
import { UserDto ,DoctorDto, HealthCheckMicroServiceInterface,PatientDto,HospitalDto} from 'common-dto';
import { Observable, throwError, TimeoutError, of } from 'rxjs';
import { timeout, catchError } from 'rxjs/operators';
import { HealthCheckService } from './health-check.service';

@Injectable()
export class UserService implements OnModuleInit, OnModuleDestroy {


    constructor(@Inject('REDIS_SERVICE') private readonly redisClient: ClientProxy,
        private readonly healthCheckService: HealthCheckService) {

    }

    async onModuleInit() {
        this.redisClient.connect();
    }

    onModuleDestroy() {
        this.redisClient.close();
    }

    public async signUp(userDto: UserDto): Promise<any> {
        if (await this.healthCheckService.checkAuthService()) {
            const userDtoRes = await this.redisClient.send({ cmd: 'auth_user_signUp' }, userDto)
            .pipe(catchError(err => {
                    // console.log(err);
                    // return of({ error: err.message ? err.message : 'Auth service is in offline' })
                    return throwError(err);
                }),).toPromise();
            return userDtoRes;
        } else {
            return {error : 'Auth service is in offline'};
        }
    }

    public validateEmailPassword(loginDto: UserDto): Observable<any> {
        return this.redisClient.send({ cmd: "auth_user_validate_email_password" }, loginDto);
    }

    public findUserByEmail(email : string) : Observable <any> {
        return this.redisClient.send({ cmd : 'auth_user_find_by_email'}, email);
    }

    public findUserByPhone(phone : string) : Observable <any> {
        return this.redisClient.send({ cmd : 'auth_patient_find_by_phone'}, phone);
    }

    public usersList() : Observable <any> {
        return this.redisClient.send( {cmd : 'auth_user_list'},'');
    }

    public doctorList(id): Observable<any> {
        return this.redisClient.send( { cmd: 'auth_doctor_list' }, id);
    }

    public doctorView(doctorDto: DoctorDto): Observable<any> {
        return this.redisClient.send( { cmd: 'auth_doctor_view' }, doctorDto);
    }

    public doctorsLogin(userDto: UserDto): Promise <any> {
        return this.redisClient.send( { cmd: 'auth_doctor_login' }, userDto).toPromise();
    }

    
    public patientLogin(patientDto: PatientDto): Promise<any> {
        return this.redisClient.send( { cmd: 'auth_patient_login' }, patientDto).toPromise();
    }

    public patientRegistration(patientDto: any):Promise<any> {
        const patient = this.redisClient.send( { cmd: 'auth_patient_registration' }, patientDto)
        .pipe(catchError(err => {
            return throwError(err);
        }),).toPromise();
        return patient;
    }

    public findPatientByPhone(phone : string) : Observable <any> {
        return this.redisClient.send({ cmd : 'auth_patient_find_by_phone'}, phone);
    }


}
