import {IsEmail,IsNumber,IsPhoneNumber,IsOptional,IsPostalCode, isPostalCode } from 'class-validator';

export class PatientDto {
    @IsOptional ()
    @IsNumber()
    id: number;
    name: string;
    landmark: string;
    country: string;
    registrationNumber: string;
    address: string;
    state: string;
    @IsOptional()
    @IsPostalCode('IN')
    pincode: string;
    @IsOptional ()
    @IsEmail()
    email: string;
    photo: string;
    @IsOptional ()
    @IsPhoneNumber('IN')
    phone: string;
    @IsOptional ()
    @IsNumber()
    patientId: number;
    password: string;
    firstName: string;
    lastName: string;
    dateOfBirth: string;
    alternateContact: string;
    age: number;
    paymentOption:string;
    consultationMode:string;
    preconsultation:string;
    appointmentDate:Date;
    startTime:string;
    endTime:string;
    createdBy:string;
    salt:string;
    paginationNumber:number;
    doctorKey:string;
}