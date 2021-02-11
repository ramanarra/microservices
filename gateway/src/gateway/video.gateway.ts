import { UseInterceptors, Logger } from '@nestjs/common';
import { SubscribeMessage, WebSocketGateway, WebSocketServer } from '@nestjs/websockets';
import { RedisPropagatorInterceptor } from '@app/shared/redis-propagator/redis-propagator.interceptor';
import { Socket, Server } from 'socket.io';
import { VideoService } from '@src/service/video.service';
import socketio from 'socket.io';
import { SocketStateService } from '@app/shared/socket-state/socket-state.service';
import { CONSTANT_MSG } from 'common-dto';
import { UserService } from '@src/service/user.service';

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

  constructor(private readonly videoService : VideoService, private readonly socketStateService : SocketStateService,
    private readonly userService : UserService){

  }

  @SubscribeMessage('createTokenForDoctor')
  async createTokenForDoctor(client: AuthenticatedSocket, data : string) {
    this.logger.log(`Socket request for create Token for Doctor from Doc-key => ${client.auth.data.doctor_key}`);
    const response : any = await this.videoService.videoDoctorSessionCreate(client.auth.data.doctor_key);
    console.log("response Doctor >>" + JSON.stringify(response));
    client.emit("videoTokenForDoctor", response);
    return response;
  }

  @SubscribeMessage('createTokenForPatientByDoctor')
  async createTokenForPatientByDoctor(client: AuthenticatedSocket, appointmentId : string) {
    this.logger.log(`Socket request for create Token for Patient from Doc-key => ${client.auth.data.doctor_key} and appointmentId => ${appointmentId}` );
    const response : any = await this.videoService.createTokenForPatientByDoctor(client.auth.data.doctor_key, appointmentId);
    console.log("response Patient >>" + JSON.stringify(response));
    let patientSocketList : Socket[] = this.socketStateService.get("CUSTOMER_"+response.patient);
    patientSocketList.forEach( (val : Socket) => {
      val.emit("videoTokenForPatient", response);
    });
  }

  @SubscribeMessage('getPatientTokenForDoctor')
  async getPatientToken(client: AuthenticatedSocket, appointmentId : string) {
    this.logger.log(`Socket request get patient token for Doctor from  PatientId => ${client.auth.data.patientId} and doc-key => ${appointmentId}`);
    const response : any = await this.videoService.getPatientTokenForDoctor(appointmentId, client.auth.data.patientId);
    client.emit("videoTokenForPatient", response);
  }

  @SubscribeMessage('removePatientTokenByDoctor')
  async removePatientTokenByDoctor(client: AuthenticatedSocket, data : any) {
    this.logger.log(`Socket request remove Patient Token By Doctor from Doc-key => ${client.auth.data.doctor_key} and appointmentId => ${data}` );
    const response:any = await this.videoService.removePatientTokenByDoctor(client.auth.data.doctor_key, data.appointmentId, data.status);
    console.log("response >>" + JSON.stringify(response));
    let patientSocketList : Socket[] = this.socketStateService.get("CUSTOMER_"+response.patient);
    patientSocketList.forEach( (val : Socket) => {
      val.emit("videoTokenRemoved", response);
    });
    const responseDoc : any = await this.videoService.getDoctorAppointments(client.auth.data.doctor_key);
    client.emit("getDoctorAppointments", responseDoc);
  }

  @SubscribeMessage('removeSessionAndTokenByDoctor')
  async removeSessionAndTokenByDoctor(client: AuthenticatedSocket, appointmentId : string) {
    this.logger.log(`Socket request remove Session And Token By Doctor from Doc-key => ${client.auth.data.doctor_key}` );
    const response:any = await this.videoService.removeSessionAndTokenByDoctor(client.auth.data.doctor_key,appointmentId);
    console.log("response >>" + JSON.stringify(response));
    let patientSocketList : Socket[] = this.socketStateService.get("CUSTOMER_"+response.patient);
    patientSocketList.forEach( (val : Socket) => {
      val.emit("videoSessionRemoved", response);
    });
  }

  @SubscribeMessage('getAppointmentListForDoctor')
  async getDoctorAppointments(client: AuthenticatedSocket) {
    this.logger.log(`Socket request get appointments for Doctor from doctorKey => ${client.auth.data.doctor_key}`);
    const response : any = await this.videoService.getDoctorAppointments(client.auth.data.doctor_key);
    client.emit("getDoctorAppointments", response);
  }

  @SubscribeMessage('updateLiveStatusOfUser')
  async updateLiveStatus(client: AuthenticatedSocket, data : {status : string}) {
   let userInfo = client.auth.data;
    if(userInfo.permission === "CUSTOMER"){
      this.logger.log(`Socket request update live status for ${CONSTANT_MSG.ROLES.PATIENT} => ${userInfo.patientId} and status => ${data.status}`);
      this.userService.updateDoctorAndPatient(CONSTANT_MSG.ROLES.PATIENT, userInfo.patientId, data.status);

      //patient related doc list - today's appoinmnet without doctor duplication
      const patientTodayApp : any = await this.videoService.patientUpcomingAppointments(userInfo.patientId, 0, 0);
      let doctorArr = [0];

      console.log('patientTodayApp = > ', patientTodayApp);

      patientTodayApp.forEach(element => {
      console.log(element);
        console.log('doctor = >', element.doctorId);
        if (element.doctorId && (doctorArr.length && !doctorArr.includes(element.doctodId))) {
          doctorArr.push(element.doctorId);
          // docList -> DOCTOR
          let patientDocSocketList : Socket[] = this.socketStateService.get("DOCTOR_"+ element.doctorId);

          // emiting response
          patientDocSocketList.forEach( async(val : Socket) => {
            const response : any = await this.videoService.getDoctorAppointments(element.doctorKey);
            client.emit("getDoctorAppointments", response);
            });
        }

      });

    }else {
      this.logger.log(`Socket request update live status for ${CONSTANT_MSG.ROLES.DOCTOR} => ${userInfo.doctor_key} and status => ${data.status}`);
      this.userService.updateDoctorAndPatient(CONSTANT_MSG.ROLES.DOCTOR, userInfo.doctor_key, data.status);
    }
  }

  // Updated consultation status for appoitment
  @SubscribeMessage('updateAppointmentStatus')
  async updateAppointmentStatus(client: AuthenticatedSocket, data :{appointmentId: string}) {

    this.logger.log(`Socket request to update consultationStatus By Doctor from Doc-key => ${client.auth.data.doctor_key}${data.appointmentId}`);
    const response: any = await this.videoService.updateConsultationStatus(client.auth.data.doctor_key, data.appointmentId);
    console.log("response >>" + JSON.stringify(response));

    // After successfull updatation emit to all patient to block appointment details change
    if (response && response.statusCode === 200) {
      let patientSocketList: Socket[] = this.socketStateService.get("CUSTOMER_" + response.data.patientId);
      patientSocketList.forEach((val: Socket) => {
        val.emit("updateConsultationStatus", {hasConsultation: true});
      });
    }
  
  }

  // Patient prescription data sent to patient in video consultation
  @SubscribeMessage('getPrescriptionList')
  async getPriscription(client: AuthenticatedSocket, appointmentId: any, patientId: any) {
    this.logger.log(
      `Socket request get appointments for Doctor from doctorKey => ${client.auth.data.doctor_key} ${ appointmentId.appointmentId} ${patientId.patientId}`,
    );
    
    let patientSocketprescripList: Socket[] = this.socketStateService.get("PATIENT_" + patientId.patientId);
    patientSocketprescripList.forEach((val: Socket) => {
      const response: any =  this.videoService.getPrescription(
        appointmentId.appointmentId,
      );
      client.emit('getPriscription', response);
    });
   
  }

   // doctor get report list from db to video conference
  @SubscribeMessage('getReportList')
  async getReport(client: AuthenticatedSocket, data:{patientId: number,appointmentId: number}) {
    this.logger.log(
      `Socket request get appointments for Doctor from patientKey => ${client.auth.data.doctor_key}${data.patientId, data.appointmentId}`,
    );
   
    let doctorRepSocketList : Socket[] = this.socketStateService.get("Doctor_"+ client.auth.data.doctor_key);
       doctorRepSocketList.forEach(async(val : Socket) => { 
      const response: any =  this.videoService.getReport( client.auth.data.doctor_key, data.patientId, data.appointmentId );
      val.emit('getReport', response);
      });
  
  }

  @SubscribeMessage('getPrescriptionDetails')
  async getPrescriptionDetails(data: {appointmentId: Number, patientId: Number}) {
    this.logger.log(
      `Socket request get prescription details for paitent from appointmentId => ${data.appointmentId}`
    )
    
    const getPrescriptionDetailsSocket: Socket [] = this.socketStateService.get(`CUSTOMER_${data.patientId}`)
    getPrescriptionDetailsSocket.forEach((i: Socket) => {
      const res: any = this.videoService.getPrescriptionDetails(data.appointmentId)
      i.emit('getPrescriptionDetails', res)
    })
  }

}