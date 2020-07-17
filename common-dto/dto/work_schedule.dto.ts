import {IsEmail,IsNumber,IsPhoneNumber,IsOptional, IsIn } from 'class-validator';
export class WorkScheduleDto {
    @IsOptional()
    @IsNumber()
    workScheduleId: number;
    @IsOptional()
    @IsNumber()
    doctorId: number;
    date: Date;
    startTime:string;
    endTime:string;
    doctorKey:string;
    @IsOptional()
    @IsIn(['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'])
    dayOfWeek:string;
  }