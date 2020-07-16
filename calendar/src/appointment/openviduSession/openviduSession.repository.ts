import { Repository, EntityRepository } from "typeorm";
import {  Logger } from "@nestjs/common";
import {OpenViduSession} from "./openviduSession.entity";


@EntityRepository(OpenViduSession)
export class OpenViduSessionRepository extends Repository<OpenViduSession> {

    private logger = new Logger('OpenViduSessionRepository');
   

}