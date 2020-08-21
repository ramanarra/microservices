import { Injectable, HttpStatus } from '@nestjs/common';
import { OpenViduSessionTokenRepository } from './openviduSession/openviduSessionToken.repository';
import { OpenViduSessionRepository } from './openviduSession/openviduSession.repository';
import { OpenViduService } from './open-vidu.service';
import { Session } from 'openvidu-node-client';
import { Doctor } from './doctor/doctor.entity';
import { PatientDetails } from './patientDetails/patientDetails.entity';
import { CONSTANT_MSG } from 'common-dto';
import { OpenViduSession } from './openviduSession/openviduSession.entity';
import { OpenViduSessionToken } from './openviduSession/openviduSessionToken.entity';
import {AppointmentRepository} from './appointment.repository';


@Injectable()
export class VideoService {

    constructor(private openViduSessionTokenRepository : OpenViduSessionTokenRepository, 
        private openViduSessionRepo : OpenViduSessionRepository, private openViduService : OpenViduService,
        private appointmentRepository:AppointmentRepository){

    }


    async createDoctorSession(doc : Doctor) : Promise<any>{
        try {
            console.log("Create FDoc " + doc.doctorName);
            let session : Session = await this.openViduService.createSession();
    
            const token = await this.openViduService.createTokenForDoctor(session);
            const sessionId = session.getSessionId();
            let OVSessionData = {
                sessionId : session.getSessionId(),
                sessionName : doc.doctorName + '_'+ new Date().getTime(),
                doctorKey : doc.doctorKey
            }
            console.log("OVSessionData => " + JSON.stringify(OVSessionData));
            const openViduSessionId = await this.openViduSessionRepo.createSession(OVSessionData);
            let OVsessionTokenDate = {
                openviduSessionId : openViduSessionId, 
                token : token,
                doctorId : doc.doctorId
            }
            console.log("OVsessionTokenDate => " + JSON.stringify(OVsessionTokenDate));
            await this.openViduSessionTokenRepository.createTokenForDoctorAndPatient(OVsessionTokenDate, 'DOCTOR');
            console.log("Token => " + token);
            return {isToken : true, token : token, isDoctor : true, isPatient : false, sessionId : sessionId, doctorName : doc.doctorName };
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
        
    }


    async createPatientTokenByDoctor(doc : Doctor, patient : PatientDetails, appointmentId:any) : Promise<any> {
        try {
            const openViduSession : OpenViduSession =  await this.openViduSessionRepo.findOne({doctorKey : doc.doctorKey});
            if(openViduSession){
                const session : Session = await this.openViduService.findSessionFromSessionId(openViduSession.sessionId);
                const token = await this.openViduService.createTokenForDoctor(session);
                const sessionId = openViduSession.openviduSessionId;
                let OVsessionTokenDate = {
                    openviduSessionId : sessionId, 
                    token : token,
                    patientId : patient.patientId,
                    doctorId : doc.doctorId
                }
                console.log("OVsessionTokenDate => " + JSON.stringify(OVsessionTokenDate));
                await this.openViduSessionTokenRepository.createTokenForDoctorAndPatient(OVsessionTokenDate, CONSTANT_MSG.ROLES.PATIENT);
                console.log("Token => " + token);
                return { isToken : true, token : token, isDoctor : false, isPatient : true, sessionId : sessionId, patient : patient.patientId, appointmentId : appointmentId};
            } else {
                return {
                    isToken : false,
                    message : "Doctor session not created"
                }
            }
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }

    async getPatientToken(doctorId : number , patientId : number, appointmentId : number) : Promise<any> {
        try {
            const openViduSessionToken : OpenViduSessionToken =  await this.openViduSessionTokenRepository.findOne({where :
                {patientId : patientId, 
                doctorId : doctorId}});
            if(openViduSessionToken){
                const sessionId = openViduSessionToken.openviduSessionId;
                return { isToken : true, token : openViduSessionToken.token, isDoctor : false, isPatient : true, sessionId : sessionId, appointmentId : appointmentId };
            }else {
                return { isToken : false, message : "Still Token not created for patient" };
            }
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }


    async removePatientToken(doc : Doctor, patientId : number, appointmentId : number) : Promise<void> {

        const openViduSession : OpenViduSession =  await this.openViduSessionRepo.findOne({doctorKey : doc.doctorKey});
        const openViduSessionToken : OpenViduSessionToken =  await this.openViduSessionTokenRepository.findOne({ where: {
            patientId : patientId,
            openviduSessionId: openViduSession.openviduSessionId
        }});
        if(openViduSessionToken) {
            this.openViduSessionTokenRepository.remove(openViduSessionToken);
            await this.openViduService.removeTokenFromSession(openViduSession.sessionId, openViduSessionToken.token);
            var condition: any = {
                id: appointmentId
            }
            let dto={
                status:'paused'
            }
            var values: any = dto;
            var updateAppStatus = await this.appointmentRepository.update( condition, values);
        }
    }

    async removeSessionAndTokenByDoctor(doctor : Doctor,appointmentId:number) : Promise<void> {
        const openViduSessionList : OpenViduSession[] =  await this.openViduSessionRepo.find({ where: {
            doctorKey : doctor.doctorKey
        }});

        const sessionIdList : string[] = openViduSessionList.map(value =>  value.sessionId);
        const openViduSessionTokenList : OpenViduSessionToken[] = await this.openViduSessionTokenRepository.find({
            where : {
                doctorId : doctor.doctorId
            }
        });

        await this.openViduSessionTokenRepository.remove(openViduSessionTokenList)
        await this.openViduSessionRepo.remove(openViduSessionList);
        await this.openViduService.removeSessionList(sessionIdList);
        var condition: any = {
            id: appointmentId
        }
        let dto={
            status:'completed'
        }
        var values: any = dto;
        var updateAppStatus = await this.appointmentRepository.update( condition, values);
    }
   
}
