import {IsEmail} from 'class-validator';

export class PatientDto {
    id: number;
    name: string;
    landmark: string;
    country: string;
    registrationNumber: string;
    address: string;
    state: string;
    pincode: string;
    @IsEmail()
    email: string;
    photo: string;
    phone: string;
    patientId: number;
    password: string;
    firstName: string;
    lastName: string;
    dateOfBirth: string;
    alternateContact: string;
    age: number;
}