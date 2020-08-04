import { UseInterceptors, Logger } from '@nestjs/common';
import { SubscribeMessage, WebSocketGateway, WebSocketServer } from '@nestjs/websockets';
import { RedisPropagatorInterceptor } from '@app/shared/redis-propagator/redis-propagator.interceptor';
import { Socket, Server } from 'socket.io';
import { VideoService } from '@src/service/video.service';
import socketio from 'socket.io';
import { SocketStateService } from '@app/shared/socket-state/socket-state.service';

interface TokenPayload {
  readonly userId: string;
  readonly data : any ;
}

export interface AuthenticatedSocket extends socketio.Socket {
  auth: TokenPayload;

}

@UseInterceptors(RedisPropagatorInterceptor)
@WebSocketGateway()
export class VideoGateway {
  
  @WebSocketServer() wss: Server;

  private logger = new Logger('VideoGateway');

  constructor(private readonly videoService : VideoService, private readonly socketStateService : SocketStateService){

  }

  @SubscribeMessage('createTokenForDoctor')
  async createTokenForDoctor(client: AuthenticatedSocket, data : string) {
    this.logger.log(`Socket request for create Token for Doctor from Doc-key => ${client.auth.data.doctor_key}`);
    const response : any = await this.videoService.videoDoctorSessionCreate(client.auth.data.doctor_key);
    client.emit("videoTokenForDoctor", response);
    return response;
  }

  @SubscribeMessage('createTokenForPatientByDoctor')
  async createTokenForPatientByDoctor(client: AuthenticatedSocket, patientId : string) {
    this.logger.log(`Socket request for create Token for Patient from Doc-key => ${client.auth.data.doctor_key} and PatientId => ${patientId}` );
    const response : any = await this.videoService.createTokenForPatientByDoctor(client.auth.data.doctor_key, patientId);
    let patientSocketList : Socket[] = this.socketStateService.get("CUSTOMER_"+patientId);
    patientSocketList.forEach( (val : Socket) => {
      val.emit("videoTokenForPatient", response);
    });
  }

  @SubscribeMessage('getPatientTokenForDoctor')
  async getPatientToken(client: AuthenticatedSocket, doctorKey : string) {
    this.logger.log(`Socket request get patient token for Doctor from  PatientId => ${client.auth.data.patientId} and doc-key => ${doctorKey}`);
    const response : any = await this.videoService.getPatientTokenForDoctor(doctorKey, client.auth.data.patientId);
    client.emit("videoTokenForPatient", response);
  }

  @SubscribeMessage('removePatientTokenByDoctor')
  async removePatientTokenByDoctor(client: AuthenticatedSocket, patientId : string) {
    this.logger.log(`Socket request remove Patient Token By Doctor from Doc-key => ${client.auth.data.doctor_key} and PatientId => ${patientId}` );
    await this.videoService.removePatientTokenByDoctor(client.auth.data.doctor_key, patientId);
    let patientSocketList : Socket[] = this.socketStateService.get("CUSTOMER_"+patientId);
    patientSocketList.forEach( (val : Socket) => {
      val.emit("videoTokenRemoved", {isRemoved : true});
    });
  }

  @SubscribeMessage('removeSessionAndTokenByDoctor')
  async removeSessionAndTokenByDoctor(client: AuthenticatedSocket, data : string) {
    this.logger.log(`Socket request remove Session And Token By Doctor from Doc-key => ${client.auth.data.doctor_key}` );
    await this.videoService.removeSessionAndTokenByDoctor(client.auth.data.doctor_key);
  }

}