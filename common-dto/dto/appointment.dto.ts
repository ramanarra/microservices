import {IsEmail,IsNumber,IsPhoneNumber,IsOptional,IsMilitaryTime,IsDate } from 'class-validator';

export class AppointmentDto {
  @IsOptional()
  @IsNumber()
  id : number;
  @IsOptional()
  @IsNumber()
  doctorId : number;
  @IsOptional()
  @IsNumber()
  patientId : number;
  @IsOptional()
  appointmentDate : Date;
  @IsOptional()
  @IsMilitaryTime()
  startTime : string;
  endTime : string;   
  paymentStatus : boolean;
  isActive : boolean; 
  isCancel : boolean;
  createdBy : string;
  createdId : number;
  cancelledBy : string;
  cancelledId : number;
}