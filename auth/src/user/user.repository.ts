import { Repository, EntityRepository } from "typeorm";
import { Users } from "./users.entity";
import { UserDto,PatientDto,CONSTANT_MSG } from "common-dto";
import * as bcrypt from "bcrypt";
import { ConflictException, InternalServerErrorException, Logger ,HttpStatus} from "@nestjs/common";

@EntityRepository(Users)
export class UserRepository extends Repository<Users> {

    private logger = new Logger('UserRepository');

    async signUP(userDto: UserDto): Promise<any> {

        const { name, email, password} = userDto;

        const user = new Users();
        const salt = await bcrypt.genSalt();
        user.name = name;
        user.password = await this.hashPassword(password, salt);
        user.salt = salt
        user.email = email;
        // user.role = role;

        try {
            return await user.save();
        } catch (error) {
            if (error.code === "23505") {
                this.logger.warn(`Email already exists, Email is ${email}`);
                throw new ConflictException("Email already exists");
            } else {
                this.logger.error(`Unexpected Sign up process save error` + error);
                throw new InternalServerErrorException();
            }
        }


    }

    async validateEmailPassword(userDto : UserDto) : Promise<any> {
        const { email, password } = userDto;
        const user = await this.findOne({email : email});
        if(user && await user.validatePassword(password)){
            return user;
        }else {
            return null;
        }

    }

    private async hashPassword(password: string, salt : string): Promise<string> {
        return bcrypt.hash(password, salt);
    }

    async validateEmailAndPassword(email,password) : Promise<any> {
        const user = await this.findOne({email : email});
        if(user && await user.validatePassword(password)){
            return user;
        }else {
            console.log("===",JSON.stringify(user))
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_CREDENTIALS
            }
            //return null;
        }

    }

    // async validatePhoneAndPassword(phone,password) : Promise<any> {
    //     console.log("======test")

    //     const user = await this.findOne({email : phone});
    //     if(user && await user.validatePassword(password)){
    //         return user;
    //     }else {
    //         console.log("===",JSON.stringify(user))
    //         return null;
    //     }

    // }


}