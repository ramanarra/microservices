import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';
import { Timestamp } from 'rxjs';

@Entity()
export class Appointment extends BaseEntity{

    @PrimaryGeneratedColumn()
    id : number;

    @Column({
        name : 'doctorId'
    })
    doctorId : number;

    @Column({
        name : 'patient_id'
    })
    patientId : number;

    @Column({
        name : 'appointment_date'
    })
    appointmentDate : Date;

    @Column({
        name : 'start_time'
    })
    startTime : string;

    @Column({
        name : 'end_time'
    })
    endTime : string;

    @Column({
        name : 'payment_status'
    })
    paymentStatus : boolean;

    @Column({
        name : 'is_active'
    })
    isActive : boolean;

    @Column({
        name : 'is_cancel'
    })
    isCancel : boolean;

    @Column({
        name : 'created_by'
    })
    createdBy : string;

    @Column({
        name : 'created_id'
    })
    createdId : number; 
    
    @Column({
        name : 'cancelled_by'
    })
    cancelledBy : string;

    @Column({
        name : 'cancelled_id'
    })
    cancelledId : number;  

}