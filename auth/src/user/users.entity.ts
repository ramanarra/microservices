import { PrimaryGeneratedColumn, Column, Entity, BaseEntity, Unique } from 'typeorm';
import * as bcrypt from "bcrypt";

@Entity()
@Unique(['email'])
export class Users extends BaseEntity{

    @PrimaryGeneratedColumn()
    id : number;

    @Column()
    name : string;

    @Column()
    email : string;

    @Column()
    password : string;

    @Column()
    salt : string;

    @Column()
    role : string;


    async validatePassword(password : string) : Promise<boolean> {
        const newPassword = await bcrypt.hash(password, this.salt);
        return newPassword === this.password;
    }

}