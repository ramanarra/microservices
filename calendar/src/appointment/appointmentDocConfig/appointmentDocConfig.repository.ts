import { Repository, EntityRepository } from "typeorm";
import {  Logger } from "@nestjs/common";
import {AppointmentDocConfig} from "./appointmentDocConfig.entity";


@EntityRepository(AppointmentDocConfig)
export class AppointmentDocConfigRepository extends Repository<AppointmentDocConfig> {

    private logger = new Logger('AppointmentDocConfigRepository');
    

}