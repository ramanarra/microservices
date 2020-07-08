export interface JwtPayLoad {
    email : string,
    userId : number,
    doctor_key : string,
    account_key: string,
    role: string,
    permissions: any
}