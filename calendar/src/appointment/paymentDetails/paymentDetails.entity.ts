import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';
import { Exclude } from 'class-transformer';

@Entity()
export class PaymentDetails extends BaseEntity{

    @PrimaryGeneratedColumn({
        name : 'id'
    })
    id : number;

    @Column({
        name : 'appointment_id'
    })
    appointmentId : number;

  //  @Exclude()
    @Column({
        name : 'refund'
    })
    refund : string;

    @Column({
        name : 'is_paid'
    })
    isPaid : boolean;

}