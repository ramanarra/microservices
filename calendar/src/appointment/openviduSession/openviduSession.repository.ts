import { Repository, EntityRepository } from "typeorm";
import {  Logger, InternalServerErrorException } from "@nestjs/common";
import {OpenViduSession} from "./openviduSession.entity";


@EntityRepository(OpenViduSession)
export class OpenViduSessionRepository extends Repository<OpenViduSession> {

    private logger = new Logger('OpenViduSessionRepository');
   
    async createSession(sessionDetails: any): Promise<any> {

        const { doctorKey, sessionName, sessionId } = sessionDetails;
        let openSession: OpenViduSession;

        openSession = await this.findOne({
            where : {
                doctorKey : doctorKey
            }
        });
        
    
        try {
            if(openSession){
                openSession.sessionName = sessionName;
                openSession.sessionId = sessionId;

                await this.update({doctorKey : doctorKey}, openSession); 
                return openSession.openviduSessionId; 
            } else {

                openSession = new OpenViduSession();
                
                openSession.doctorKey = doctorKey;
                openSession.sessionName = sessionName;
                openSession.sessionId = sessionId;
                
                const app : OpenViduSession =  await this.save(openSession); 
                return app.openviduSessionId;
            }  
        } catch (error) {
            if (error.code === "22007") {
                this.logger.warn(`OpenVidu session date is invalid ${sessionId} data`);
            } else {
                this.logger.error(`Unexpected Openvidu session save error` + error.message);
                throw new InternalServerErrorException();
            }
        }
    }

}