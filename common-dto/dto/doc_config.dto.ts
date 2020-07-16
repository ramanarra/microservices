import {IsEmail,IsNumber,IsPhoneNumber,IsOptional, Min, Max } from 'class-validator';

export declare class DocConfigDto {
    @IsNumber()
    @IsOptional()
    id : number;
    doctorKey: string;
    consultationCost: string;
    isPreconsultationAllowed: boolean;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(23)
    preconsultationHours: number;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(59)
    preconsultationMins : number;
    isPatientCancellationAllowed : boolean;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(31)
    cancellationDays : string;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(23)
    cancellationHours : string;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(59)
    cancellationMins : string;
    isPatientRescheduleAllowed : boolean;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(31)
    rescheduleDays : string;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(23)
    rescheduleHours : string;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(59)
    rescheduleMins : string;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(31)
    autoCancelDays : string;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(23)
    autoCancelHours : string;
    @IsNumber()
    @IsOptional()
    @Min(0)
    @Max(59)
    autoCancelMins : string;
    isActive: boolean;
    createdOn: Date;
    modifiedOn: Date;
}
