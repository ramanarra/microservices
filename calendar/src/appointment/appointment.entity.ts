import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';

@Entity()
export class Appointment extends BaseEntity{

    @PrimaryGeneratedColumn()
    id : number;

    @Column({
        name : 'doctor_id'
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

}