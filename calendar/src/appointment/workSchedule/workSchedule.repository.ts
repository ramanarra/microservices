import { Repository, EntityRepository } from "typeorm";
import {  Logger } from "@nestjs/common";
import {WorkSchedule} from "./workSchedule.entity";


@EntityRepository(WorkSchedule)
export class WorkScheduleRepository extends Repository<WorkSchedule> {

    private logger = new Logger('WorkScheduleRepository');


}