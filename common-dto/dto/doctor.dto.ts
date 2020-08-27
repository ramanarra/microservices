import {IsEmail,IsNumber,IsPhoneNumber,IsOptional } from 'class-validator';
export class DoctorDto {
    @IsOptional()
    @IsNumber()
    doctorId: number;
    doctorKey:string;
    @IsOptional()
    @IsEmail()
    email: string;
    password: string;
    accountKey: string;
    @IsOptional()
    @IsNumber()
    accountId: number;
    doctorName: string;
    doctorExperience: number;
    speciality: string;
    registrationNumber:string;  
    photo:string;
    confirmation:boolean;
    appointmentDate:Date;
  }