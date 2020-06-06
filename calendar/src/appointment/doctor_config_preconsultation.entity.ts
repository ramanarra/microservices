import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';

@Entity()
export class DoctorConfigPreConsultation extends BaseEntity{

    @PrimaryGeneratedColumn({
        name : 'doctor_config_id'
    })
    doctorConfigId : number;

    @Column({
        name : 'doctor_key'
    })
    doctorKey : string;

    @Column({
        name : 'consultation_cost'
    })
    consultationCost : string;

    @Column({
        name : 'is_preconsultation_allowed'
    })
    isPreconsultationAllowed : string;

    @Column({
        name : 'preconsultation_hours'
    })
    preconsultationHours : number;

    @Column({
        name : 'preconsultation_minutes'
    })
    preconsultationMinutes : string;

    @Column({
        name : 'is_active'
    })
    isActive : string;

    @Column({
        name : 'created_on'
    })
    createdOn : string;

    @Column({
        name : 'modified_on'
    })
    modifiedOn : string;

}