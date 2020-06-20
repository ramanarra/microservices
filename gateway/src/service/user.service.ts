import { Injectable, Inject, UseFilters, RequestTimeoutException, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { ClientProxy } from "@nestjs/microservices";
import { UserDto ,DoctorDto, HealthCheckMicroServiceInterface} from 'common-dto';
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

    public usersList() : Observable <any> {
        return this.redisClient.send( {cmd : 'auth_user_list'},'');
    }

    public doctorLogin(doctorDto: DoctorDto): Observable<any> {
        return this.redisClient.send( { cmd: 'auth_doctor_login' }, doctorDto);
    }

    public doctorList(id): Observable<any> {
        return this.redisClient.send( { cmd: 'auth_doctor_list' }, id);
    }

    public doctorView(doctorDto: DoctorDto): Observable<any> {
        return this.redisClient.send( { cmd: 'auth_doctor_view' }, doctorDto);
    }

    
    public doctor_Login(doctorDto: DoctorDto): Observable<any> {
        return this.redisClient.send( { cmd: 'auth_doctor__login' }, doctorDto);
    }

    public doctorsLogin(userDto: UserDto): Observable<any> {
        return this.redisClient.send( { cmd: 'auth_doctor_login' }, userDto);
    }

    
    public patientLogin(userDto: UserDto): Observable<any> {
        return this.redisClient.send( { cmd: 'auth_patient_login' }, userDto);
    }


}
