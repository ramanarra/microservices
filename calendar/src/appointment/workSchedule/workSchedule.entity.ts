import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';

@Entity()
export class WorkSchedule extends BaseEntity{

    @PrimaryGeneratedColumn({
        name : 'work_schedule_id'
    })
    workScheduleId : number;

    @Column({
        name : 'doctor_id'
    })
    doctorId : number;

    @Column({
        name : 'date'
    })
    date : Date;

}