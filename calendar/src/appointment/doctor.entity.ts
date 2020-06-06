import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';

@Entity()
export class Doctor extends BaseEntity{

    @PrimaryGeneratedColumn({
        name : 'doctor_id'
    })
    doctor_id : number;

    @Column({
        name : 'doctor_name'
    })
    doctorName : string;

    @Column({
        name : 'account_key'
    })
    accountKey : string;

    @Column({
        name : 'doctor_key'
    })
    doctorKey : string;

    @Column({
        name : 'experience'
    })
    experience : number;

    @Column({
        name : 'speciality'
    })
    speciality : string;

    @Column({
        name : 'qualification'
    })
    qualification : string;

    @Column({
        name : 'photo'
    })
    photo : string;

    @Column({
        name : 'number'
    })
    number : string;

    @Column({
        name : 'signature'
    })
    signature : string;

}