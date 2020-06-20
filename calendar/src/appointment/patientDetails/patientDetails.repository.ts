import { Repository, EntityRepository } from "typeorm";
import {  Logger } from "@nestjs/common";
import {PatientDetails} from "./patientDetails.entity";


@EntityRepository(PatientDetails)
export class PatientDetailsRepository extends Repository<PatientDetails> {

    private logger = new Logger('PatientDetailsRepository');
    

}