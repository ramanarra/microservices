import { Repository, EntityRepository } from "typeorm";
import { ConflictException, InternalServerErrorException, Logger } from "@nestjs/common";
import { AccountDetails } from "./account_details.entity";


@EntityRepository(AccountDetails)
export class AccountDetailsRepository extends Repository<AccountDetails> {

    private logger = new Logger('AccountDetailsRepository');
    

}