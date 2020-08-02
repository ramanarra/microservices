import { Injectable } from '@nestjs/common';
import { OpenVidu, Session, TokenOptions, OpenViduRole, Connection } from 'openvidu-node-client';
import * as config from 'config';

@Injectable()
export class OpenViduService {

    openVidu: OpenVidu;
    session: Session;
    currentSessionList : Session[];
    openViduConfig : any;
    constructor() {
        this.openViduConfig = config.get('openVidu');
        this.connectOpenVidu();
    }

    private connectOpenVidu(){
        this.openVidu = new OpenVidu(this.openViduConfig.urlOpenViduServer, this.openViduConfig.secret);
        this.updateSessionList();
    }

    private async updateSessionList() {
        this.currentSessionList = this.openVidu.activeSessions;
        await this.fetchOpenVideoChanges();
    }

    public async createSession() {
        this.updateSessionList();
        var properties = {};
        return await this.openVidu.createSession();
    }

    public async createTokenForDoctor(session : Session) {
        const tokenOptions: TokenOptions = {
            role: OpenViduRole.PUBLISHER,
            data: "user_data"
        }
        return await session.generateToken(tokenOptions);
    }

    async fetchOpenVideoChanges() {
        await this.openVidu.fetch();
        this.currentSessionList = this.openVidu.activeSessions;
    }

    async findSessionFromSessionId(sessionId) : Promise<Session> {
        await this.fetchOpenVideoChanges();
        return this.currentSessionList.find(ses => ses.sessionId === sessionId);
    }

    async removeSessionList(sessionIdList : string[]){
        for(let sessionId of sessionIdList){
            const currentSession : Session = await this.findSessionFromSessionId(sessionId);
            if (currentSession) 
                currentSession.close();
        }
    }

    async removeTokenFromSession(sessionId : string, token : string){
        let connection : Connection;
        const currentSession : Session = await this.findSessionFromSessionId(sessionId);
        if(currentSession)
        connection = await this.findConnectFromSessionByToken(currentSession, token);
        if(connection)
            await currentSession.forceDisconnect(connection);
    }


    async findConnectFromSessionByToken(session : Session, token : string) : Promise<Connection>{
        const connections : Connection[] = session.activeConnections;
        return connections.find(con => con.token === token);
    }

}
