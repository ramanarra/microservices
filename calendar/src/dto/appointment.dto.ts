import { isString } from "util";

export class AppointmentDto {
  id : number;
  doctorId : number;
  patientId : number;
  appointmentDate : Date;
  startTime : string;
  endTime : string;    
  }