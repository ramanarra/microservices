import { Repository, EntityRepository } from "typeorm";
import { ConflictException, InternalServerErrorException, Logger } from "@nestjs/common";
import { Doctor } from "./doctor.entity";


@EntityRepository(Doctor)
export class DoctorRepository extends Repository<Doctor> {

    private logger = new Logger('DoctorRepository');
    

}