import { Repository, EntityRepository } from "typeorm";
import { Users } from "./users.entity";
import { UserDto } from "src/dto/user.dto";
import * as bcrypt from "bcrypt";
import { ConflictException, InternalServerErrorException, Logger } from "@nestjs/common";

@EntityRepository(Users)
export class UserRepository extends Repository<Users> {

    private logger = new Logger('UserRepository');

    async signUP(userDto: UserDto): Promise<any> {

        const { name, email, password, role } = userDto;

        const user = new Users();
        const salt = await bcrypt.genSalt();
        user.name = name;
        user.password = await this.hashPassword(password, salt);
        user.salt = salt
        user.email = email;
        user.role = role;

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

}