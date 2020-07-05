import {Injectable, HttpStatus, UnauthorizedException} from '@nestjs/common';
import {InjectRepository} from '@nestjs/typeorm';
import {UserRepository} from './user.repository';
import {UserDto,PatientDto,CONSTANT_MSG} from 'common-dto';
import {JwtPayLoad} from 'src/common/jwt/jwt-payload.interface';
import {JwtPatientLoad} from 'src/common/jwt/jwt-patientload.interface';
import {JwtService} from '@nestjs/jwt';
import {AccountRepository} from './account.repository';
import {RolesRepository} from './roles.repository';
import {RolePermissionRepository} from "./rolesPermission/role_permissions.repository";
import {PermissionRepository} from "./permissions/permission.repository";
import {queries} from "../config/query";
import {UserRoleRepository} from './user_role.repository';
import {PatientRepository} from './patient.repository';

@Injectable()
export class UserService {

    constructor(
        @InjectRepository(UserRepository) private userRepository: UserRepository, private accountRepository: AccountRepository,
        private rolesRepository: RolesRepository, private rolePersmissionRepository: RolePermissionRepository,
        private permissionRepository: PermissionRepository,private userRoleRepository: UserRoleRepository,
        private patientRepository: PatientRepository,
        private readonly jwtService: JwtService
    ) {
    }

    async signUp(userDto: UserDto): Promise<any> {
        return await this.userRepository.signUP(userDto);
    }


    async validateEmailPassword(userDto: UserDto): Promise<any> {
        const user = await this.userRepository.validateEmailPassword(userDto);
        if (!user)
            throw new UnauthorizedException("Invalid Credentials");

        const jwtUserInfo: JwtPayLoad = {email: user.email, userId: user.id, account_key: '', doctor_key: '', role: ''};
        const accessToken = this.jwtService.sign(jwtUserInfo);
        user.accessToken = accessToken;
        return user;
    }

    async findByEmail(email: string): Promise<any> {
        return await this.userRepository.findOne({email});
    }

    async findByPhone(phone: string): Promise<any> {
        return await this.patientRepository.findOne({phone});
    }


    async doctor_Login(email, password): Promise<any> {

            const user = await this.userRepository.validateEmailAndPassword(email, password);
            if (!user)
                throw new UnauthorizedException("Invalid Credentials");

            var accountId = user.account_id;
            var accountData = await this.accountKey(accountId);
            user.account_key = accountData.account_key;
            var roleId = await this.roleId(user.id);
            var roles = await this.role(roleId.role_id);
            if (!roles)
                throw  new UnauthorizedException('Content Not Available');
            var rolesPermission = await this.getRolesPermissionId(roleId.role_id);
            const jwtUserInfo: JwtPayLoad = {
                email: user.email,
                userId: user.id,
                account_key: accountData.account_key,
                doctor_key: user.doctor_key,
                role: roles.roles
            };
            console.log("=======jwtUserInfo", jwtUserInfo)
            const accessToken = this.jwtService.sign(jwtUserInfo);
            user.accessToken = accessToken;
            user.rolesPermission = rolesPermission;
            user.role = roles.roles;
            return user;
    }


    async accountKey(accountId: number): Promise<any> {
        return await this.accountRepository.findOne({account_id: accountId});
    }

    async role(id: number): Promise<any> {
        return await this.rolesRepository.findOne({roles_id: id});
    }

    async roleId(userId: number): Promise<any> {
        return await this.userRoleRepository.findOne({user_id: userId});
    }

    async getRolesPermissionId(roleId: number): Promise<any> {
        return await this.rolePersmissionRepository.query(queries.getRolesPermission, [roleId]);
    }

    async patientLogin(email, password): Promise<any> {

        const user = await this.patientRepository.validatePhoneAndPassword(email, password);
        if (!user)
            throw new UnauthorizedException("Invalid Credentials");
        const jwtUserInfo: JwtPatientLoad = {
            phone: user.phone,
            patientId: user.patient_id
        };
        console.log("=======jwtUserInfo", jwtUserInfo)
        const accessToken = this.jwtService.sign(jwtUserInfo);
        user.accessToken = accessToken;
        return user;
    }


    async patientRegistration(patientDto: PatientDto): Promise<any> {
        const pat = await this.findByPhone(patientDto.phone);
        if(pat){
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.ALREADY_PRESENT
            }
        }
        return await this.patientRepository.patientRegistration(patientDto);
    }

    async getRolesPermisssion(role: string): Promise<any> {
        const roleid = await this.rolesRepository.findOne({roles: role});
        var rolesPermission = await this.getRolesPermissionId(roleid.roles_id);
        return rolesPermission;
    }



}
