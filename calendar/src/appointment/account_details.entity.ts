import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';

@Entity()
export class AccountDetails extends BaseEntity{

    @PrimaryGeneratedColumn({
        name : 'account_details_id'
    })
    id : number;

    @Column({
        name : 'account_key'
    })
    accountKey : string;

    @Column({
        name : 'hospital_name'
    })
    hospitalName : string;

    @Column({
        name : 'street1'
    })
    street1 : string;

    @Column({
        name : 'street2'
    })
    street2 : string;

    @Column({
        name : 'city'
    })
    city : string;

    @Column({
        name : 'state'
    })
    state : string;

    @Column({
        name : 'pincode'
    })
    pincode : string;

    @Column({
        name : 'phone'
    })
    phone : string;

    @Column({
        name : 'support_email'
    })
    supportEmail : string;

}