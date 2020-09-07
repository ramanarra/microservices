import { Repository, EntityRepository } from "typeorm";
import { ConflictException, InternalServerErrorException, Logger } from "@nestjs/common";
import { Doctor } from "./doctor.entity";
import { DoctorDto } from "common-dto";


@EntityRepository(Doctor)
export class DoctorRepository extends Repository<Doctor> {

    private logger = new Logger('DoctorRepository');

    async doctorRegistration(doctorDto: DoctorDto): Promise<any> {

        const doctor = new Doctor();
        doctor.accountKey =doctorDto.accountKey ;
        doctor.doctorKey = doctorDto.doctorKey;
        doctor.firstName = doctorDto.firstName;
        doctor.lastName = doctorDto.lastName;
        doctor.doctorName = doctorDto.firstName+" "+doctorDto.lastName; 
        try {
            return await doctor.save();          
        } catch (error) {
                this.logger.error(`Unexpected Appointment save error` + error.message);
                //throw new InternalServerErrorException();
            }
        }  

}