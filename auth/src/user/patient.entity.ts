import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique, Timestamp } from 'typeorm';

@Entity()
export class Patient extends BaseEntity{

    @PrimaryGeneratedColumn()
    patient_id : number;

    @Column()
    phone : string;

    @Column()
    password : string;

    @Column()
    salt : string;


}