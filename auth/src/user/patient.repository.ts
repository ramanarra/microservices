import { Repository, EntityRepository } from "typeorm";
import { Users } from "./users.entity";
import { Account } from "./account.entity";
import { UserDto,PatientDto,CONSTANT_MSG } from "common-dto";
import * as bcrypt from "bcrypt";
import { ConflictException, InternalServerErrorException, Logger,HttpStatus } from "@nestjs/common";
import { Patient } from "./patient.entity";

@EntityRepository(Patient)
export class PatientRepository extends Repository<Patient> {

    private logger = new Logger('PatientRepository');

    async patientRegistration(patientDto: PatientDto): Promise<any> {

        const { name, phone, password} = patientDto;

        const patient = new Patient();
        const salt = await bcrypt.genSalt();
        if(password){
            patient.password = await this.hashPassword(password, salt);
            patient.salt = salt
        }        
        patient.phone = phone;

        try {
            return await patient.save();
        } catch (error) {
            if (error.code === "23505") {
                this.logger.warn(`Phone number already exists, Phone number is ${phone}`);
                throw new ConflictException("Phone number already exists");
            } else {
                this.logger.error(`Unexpected Sign up process save error` + error);
                throw new InternalServerErrorException();
            }
        }


    }

    private async hashPassword(password: string, salt : string): Promise<string> {
        return bcrypt.hash(password, salt);
    }

    async validatePhoneAndPassword(phone,password) : Promise<any> {
        const patient = await this.findOne({phone : phone});
        if(!patient){
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_PHONE
            }
        }
        if(patient && await patient.validatePassword(password)){
            return patient;
        }else {
            console.log("===",JSON.stringify(patient))
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_PASSWORD
            }
           // return null;
        }

    }




}