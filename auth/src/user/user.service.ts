import { Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { UserRepository } from './user.repository';
import { UserDto } from 'src/dto/user.dto';
import { JwtPayLoad } from 'src/common/jwt/jwt-payLoad.interface';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class UserService {

    constructor(
        @InjectRepository(UserRepository) private userRepository: UserRepository,
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
        
        const jwtUserInfo : JwtPayLoad  = { name : user.name, email : user.email, userId: user.id };
        const accessToken =  this.jwtService.sign(jwtUserInfo);
        user.accessToken = accessToken;
        return user;
    }

    async findByEmail(email : string) : Promise<any> {
        return await this.userRepository.findOne({email});
    }


}