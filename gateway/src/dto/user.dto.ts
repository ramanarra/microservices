import { ApiProperty, OmitType } from "@nestjs/swagger";

export class UserDto {

  id: number;
  
  @ApiProperty({
    description: 'User name',
    type : String
  })
  name: string;

  @ApiProperty({
    description: 'User Email',
    type : String
  })
  email: string;
  
  @ApiProperty({
    description: 'User password',
    type: String,
    minLength : 5
  })
  password: string;

  @ApiProperty({
    description: 'Role Should be DOCTOR/PATIENT',
    type: String
  })
  role:string;
  
  }


  export class LoginDto extends OmitType(UserDto, ['name'] as const) {}