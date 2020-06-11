import { Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { UserRepository } from './user.repository';
import { UserDto } from 'common-dto';
import { JwtPayLoad } from 'src/common/jwt/jwt-payload.interface';
import { JwtService } from '@nestjs/jwt';
import { AccountRepository } from './account.repository';
import { RolesRepository } from './roles.repository';

@Injectable()
export class UserService {

    constructor(
        @InjectRepository(UserRepository) private userRepository: UserRepository, private accountRepository : AccountRepository, private rolesRepository : RolesRepository,
        private readonly jwtService : JwtService
    ) {
    }

    async signUp(userDto: UserDto): Promise<any> {
        return await this.userRepository.signUP(userDto);
    }


    async validateEmailPassword(userDto: UserDto): Promise<any> {
        const user = await this.userRepository.validateEmailPassword(userDto);
        if (!user)
            throw new UnauthorizedException("Invalid Credentials");
        
        const jwtUserInfo : JwtPayLoad  = { email : user.email, userId: user.id,account_key: '' , doctor_key : '', role: '' };
        const accessToken =  this.jwtService.sign(jwtUserInfo);
        user.accessToken = accessToken;
        return user;
    }

    async findByEmail(email : string) : Promise<any> {
        return await this.userRepository.findOne({email});
    }


    async doctor_Login(email,password) : Promise<any> {
        const user = await this.userRepository.validateEmailAndPassword(email,password);
        if (!user)
            throw new UnauthorizedException("Invalid Credentials");
        var accountId = user.account_id;
        var accountData = await this.accountKey(accountId);
        user.account_key = accountData.account_key;
         var roles = await  this.role(user.id);
        const jwtUserInfo : JwtPayLoad  = { email : user.email, userId: user.id, account_key: accountData.account_key, doctor_key: user.doctor_key, role: roles.roles };
       console.log("=======jwtUserInfo",jwtUserInfo )
        const accessToken =  this.jwtService.sign(jwtUserInfo);
        user.accessToken = accessToken;
        return user;
    }


    async accountKey(accountId : number) : Promise<any> {
        return await this.accountRepository.findOne({account_id : accountId});
    }

    async role(userId : number) : Promise<any> {
        return await this.rolesRepository.findOne({user_id : userId});
    }

}
