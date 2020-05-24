
import { PassportStrategy } from '@nestjs/passport';
import { Strategy, ExtractJwt} from 'passport-jwt';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtPayLoad } from './jwt-payload.interface';
import { UserService } from 'src/service/user.service';
import { UserDto } from 'src/dto/user.dto';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {

    constructor(private readonly userService : UserService){
        super({
            jwtFromRequest : ExtractJwt.fromAuthHeaderAsBearerToken(),
            secretOrKey: 'topSecret51'
        })
    }


    async validate(payload : JwtPayLoad) : Promise<UserDto>{
        console.log("JWT Pat laofd >> "+ JSON.stringify(payload));
        const user : UserDto = await this.userService.findUserByEmail(payload.email).toPromise();
        if(!user){
            throw new UnauthorizedException("Malformed User");
        }
        console.log(user);
        return user;
    }

}