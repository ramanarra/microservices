import { Repository, EntityRepository } from "typeorm";
import {  Logger } from "@nestjs/common";
import {docConfig} from "./docConfig.entity";


@EntityRepository(docConfig)
export class docConfigRepository extends Repository<docConfig> {

    private logger = new Logger('docConfigRepository');


}