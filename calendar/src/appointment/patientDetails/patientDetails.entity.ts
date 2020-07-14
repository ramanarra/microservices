import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';
import { Exclude } from 'class-transformer';

@Entity()
export class PatientDetails extends BaseEntity{

    @PrimaryGeneratedColumn({
        name : 'id'
    })
    id : number;

    @Column({
        name : 'name'
    })
    name : string;

  //  @Exclude()
    @Column({
        name : 'landmark'
    })
    landmark : string;

    @Column({
        name : 'country'
    })
    country : string;

    @Column({
        name : 'registration_number'
    })
    registrationNumber : string;

    @Column({
        name : 'address'
    })
    address : string;

    @Column({
        name : 'state'
    })
    state : string;

    @Column({
        name : 'pincode'
    })
    pincode : string;

    @Column({
        name : 'email'
    })
    email : string;

    @Column({
        name : 'photo'
    })
    photo : string;

    @Column({
        name : 'phone'
    })
    phone : string;

    @Column({
        name : 'patient_id'
    })
    patientId : number;

    @Column({
        name : 'firstName'
    })
    firstName : string;

    @Column({
        name : 'lastName'
    })
    lastName : string;

    @Column({
        name : 'dateOfBirth'
    })
    dateOfBirth : string;

    @Column({
        name : 'alternateContact'
    })
    alternateContact : string;

    @Column({
        name : 'age'
    })
    age : number;

}