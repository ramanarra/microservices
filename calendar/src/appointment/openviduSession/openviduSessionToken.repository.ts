import { Repository, EntityRepository } from "typeorm";
import {  Logger } from "@nestjs/common";
import {OpenViduSessionToken} from "./openviduSessionToken.entity";


@EntityRepository(OpenViduSessionToken)
export class OpenViduSessionTokenRepository extends Repository<OpenViduSessionToken> {

    private logger = new Logger('OpenViduSessionTokenRepository');
   

}