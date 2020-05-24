import { Repository, EntityRepository } from "typeorm";
import { ConflictException, InternalServerErrorException, Logger } from "@nestjs/common";
import { Appointment } from "./appointment.entity";

@EntityRepository(Appointment)
export class AppointmentRepository extends Repository<Appointment> {

    private logger = new Logger('AppointmentRepository');


}