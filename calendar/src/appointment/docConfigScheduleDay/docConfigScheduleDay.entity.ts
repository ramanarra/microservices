import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';

@Entity()
export class DocConfigScheduleDay extends BaseEntity{

    @PrimaryGeneratedColumn({
        name : 'id'
    })
    docConfigScheduleDayId : number;

    @Column({
        name : 'doctor_id'
    })
    doctorId : number;

    @Column({
        name : 'day_of_week'
    })
    dayOfWeek : string;

    @Column({
        name : 'doctor_key'
    })
    doctorKey : string;


}