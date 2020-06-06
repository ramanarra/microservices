import { Injectable, Inject, UseFilters } from '@nestjs/common';
import { ClientProxy } from "@nestjs/microservices";
import { Observable } from 'rxjs';
import { UserDto ,DoctorDto} from 'common-dto';
import { AllClientServiceException } from 'src/common/filter/all-clientservice-exceptions.filter';

@Injectable()
export class UserService {


    constructor(@Inject('REDIS_SERVICE') private readonly redisClient: ClientProxy) {

    }

    @UseFilters(AllClientServiceException)
    public signUp(userDto: UserDto): Observable<any> {
        return this.redisClient.send({ cmd: 'auth_user_signUp' }, userDto);
    }

    public validateEmailPassword(loginDto : UserDto): Observable<any> {
        return this.redisClient.send({cmd : "auth_user_validate_email_password"}, loginDto);
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



}
