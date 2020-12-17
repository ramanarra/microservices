import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';

@Entity()
export class Prescription extends BaseEntity{

    @PrimaryGeneratedColumn({
        name : 'id'
    })
    id : number;

    @Column({
        name : 'appointment_id'
    })
    appointmentId : number;

    @Column({
        name : 'appointment_date'
    })
    appointmentDate : Date;

    @Column({
        name : 'hospital_logo'
    })
    hospitalLogo : string;

    @Column({
        name : 'hospital_name'
    })
    hospitalName : string;

    @Column({
        name : 'name_of_medicine'
    })
    nameOfMedicine : string;

    @Column({
        name : 'frequency_of_each_dose'
    })
    frequencyOfEachDose : string;

    @Column({
        name : 'type_of_medicine'
    })
    typeOfMedicine : string;

    @Column({
        name : 'count_of_days'
    })
    countOfDays : string;

    @Column({
        name : 'doctor_name'
    })
    doctorName : string;

    @Column({
        name : 'doctor_signature'
    })
    doctorSignature : string;

    @Column({
        name : 'patient_name'
    })
    patientName : string;

    @Column({
        name : 'dose_of_medicine'
    })
    doseOfMedicine : string;
}