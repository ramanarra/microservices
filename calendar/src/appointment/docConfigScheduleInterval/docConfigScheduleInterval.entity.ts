import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';

@Entity()
export class DocConfigScheduleInterval extends BaseEntity{

    @PrimaryGeneratedColumn({
        name : 'id'
    })
    docConfigScheduleIntervalId : number;

    @Column({
        name : 'doc_config_schedule_day_id'
    })
    docConfigScheduleDayId : number;

    @Column({
        name : 'start_time'
    })
    startTime : string;

    @Column({
        name : 'end_time'
    })
    endTime : string;


}