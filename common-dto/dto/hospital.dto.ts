import {IsEmail,IsNumber,IsPhoneNumber,IsOptional } from 'class-validator';

export class HospitalDto {
    @IsOptional ()
    @IsNumber()
    id: number;
    accountKey: string;
    hospitalName: string;
    street1: string;
    street2: string;
    city: string;
    state: string;
    pincode: string;
    @IsOptional ()
    @IsEmail()
    supportEmail: string;
    hospitalPhoto: string;
    @IsOptional ()
    @IsPhoneNumber('IN')
    phone: string;
}