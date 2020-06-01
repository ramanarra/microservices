// import { IsInt, IsNotEmpty } from 'class-validator';

export class AppointmentDto {
  id : number;
  
  // @IsInt({message:"doctorId must be a number"})
  // @IsNotEmpty()
  doctorId : number;

  // @IsInt({message:"patientId must be a number"})
  // @IsNotEmpty()
  patientId : number;

  // @IsNotEmpty({message:"Appointment Date is required"})
  appointmentDate : Date;

  // @IsNotEmpty({message:"Please mention start time"})
  startTime : string;

  // @IsNotEmpty({message:"please mention end time"})
  endTime : string;    
}