import {
  Controller,
  HttpStatus,
  Body,
  Param,
  Query,
  Post,
  Get,
  Put,
  UseGuards,
  UseFilters,
  Logger,
  Request,
  Response,
  ValidationPipe, UsePipes
} from '@nestjs/common';
import { UserService } from 'src/service/user.service';
import {CalendarService} from 'src/service/calendar.service';
import { UserDto, DoctorDto, PatientDto,CONSTANT_MSG } from 'common-dto';
import { AllExceptionsFilter } from 'src/common/filter/all-exceptions.filter';
import {
  ApiCreatedResponse,
  ApiOkResponse,
  ApiUnauthorizedResponse,
  ApiBody, ApiBearerAuth,
  ApiResponse,
  ApiTags
} from '@nestjs/swagger';
import { defaultMaxListeners } from 'stream';
import {AuthGuard} from '@nestjs/passport';
import { JwtStrategy } from 'src/common/jwt/jwt.strategy';
import {JwtService} from '@nestjs/jwt';
import { toNamespacedPath } from 'path';
import {reports} from "../common/decorator/reports.decorator";
import {patient} from "../common/decorator/patientPermission.decorator";
import {selfUserSettingRead} from "../common/decorator/selfUserSettingRead.decorator";
import {accountUsersSettingsRead} from "../common/decorator/accountUsersSettingsRead.decorator";


@Controller('api/auth')
@UseFilters(AllExceptionsFilter)
export class AuthController {

  private logger = new Logger('AuthController');

  constructor(private readonly userService: UserService, private readonly calendarService: CalendarService,  private readonly jwtService: JwtService) { }

    @Post('doctorLogin')
    @ApiOkResponse({ description: 'requestBody example :   {\n' +
          '"email":"test@apollo.com",\n' +
          '"password": "123456" \n' +
          '}' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBody({ type: UserDto })
    @ApiTags('Doctors')
    async doctorsLogin(@Body() userDto : UserDto) {
      if(!userDto.email){
        console.log("Provide email");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide email"}
      }else if(!userDto.password){
        console.log("Provide password");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide password"}
      }
      this.logger.log(`Doctor Login  Api -> Request data ${JSON.stringify(userDto)}`);
      const doc:any =await this.userService.doctorsLogin(userDto);
      console.log('returning doc login 0 ', doc);

      if(doc.role == CONSTANT_MSG.ROLES.DOCTOR){
        const status = await this.calendarService.updateDocOnline(doc.doctorKey);
        console.log('returning doc login 2 status ', status);
      }
      console.log('returning doc login 1', doc);
      return doc;
    }

    @Post('patientLogin')
    @ApiOkResponse({ description: 'requestBody example :   {\n' +
          '"phone":"9999999996",\n' +
          '"password": "123456" \n' +
          '}' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBody({ type: PatientDto })
    @ApiTags('Patient')
    async patientLogin(@Body() patientDto : PatientDto) {
      if(!patientDto.phone || !(patientDto.phone.length == 10)){
        console.log("Provide Valid Phone");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide Valid Phone"}
      }else if(!patientDto.password){
        console.log("Provide password");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide password"}
      }
      this.logger.log(`Patient Login  Api -> Request data ${JSON.stringify(patientDto)}`);
      const patient = await this.userService.patientLogin(patientDto);
      if(patient.patientId){
        const details = await this.calendarService.getPatientDetails(patient.patientId);
        patient.firstName = details.firstName;
        patient.lastName = details.lastName;
        patient.photo = details.photo;
        const status = await this.calendarService.updatePatOnline(patient.patientId);
      }     
      return patient;
    }

    @Post('patientRegistration')
    @ApiOkResponse({ description: 'requestBody example :   {\n' +
          '"phone":"9999999992",\n' +
          '"email":"nirmala@gmail.com",\n' +
          '"password": "123456", \n' +
          '"firstName":"firstName", \n' +
          '"lastName":"lastName", \n' +
          '"dateOfBirth":"DOB", \n' +
          '"landmark":"landmark", \n' +
          '"country":"country", \n' +
          '"address":"address", \n' +
          '"state":"state", \n' +
          '"pincode":"12346", \n' +
          '"alternateContact":"alternateContact", \n' +
          '"age":21, \n' +
          '"photo":"https://homepages.cae.wisc.edu/~ece533/images/airplane.png" \n' +
          '}' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBody({ type: PatientDto })
    @ApiTags('Patient')
    @UsePipes(new ValidationPipe({ transform: true }))
    async patientRegistration(@Body() patientDto : PatientDto) {
      if(patientDto.phone && patientDto.phone.length == 10){
        if(patientDto.password){
          let regDto:any ={
            phone:patientDto.phone,
            password:patientDto.password,
            createdBy:CONSTANT_MSG.ROLES.PATIENT
          }
          this.logger.log(`Patient Registration  Api -> Request data ${JSON.stringify(regDto)}`);
          const patient = await this.userService.patientRegistration(regDto);
          if(patient.message){
            return patient;
          }else if(patient.update){
              patientDto.patientId = patient.patientId;
              let patDto:any = {
                phone:patientDto.phone,
                email:patientDto.email,
                patientId:patient.patientId,
                firstName:patientDto.firstName,
                lastName:patientDto.lastName,
                name:patientDto.firstName+" "+patientDto.lastName,
                dateOfBirth:patientDto.dateOfBirth,
                landmark:patientDto.landmark,
                country:patientDto.country,
                address:patientDto.address,
                state:patientDto.state,
                pincode:patientDto.pincode,
                alternateContact:patientDto.alternateContact,
                age:patientDto.age,
                photo:patientDto.photo

              }
              const details = await this.calendarService.patientDetailsEdit(patDto);
              return {
                patient:patient,
                details:details
              }
          }else {
            const details = await this.calendarService.patientInsertion(patientDto,patient.patientId);
            const status = await this.calendarService.updatePatOnline(patient.patientId);
            return {
              patient:patient,
              details:details
            }
          }
        }else{
          return {
            statusCode: HttpStatus.BAD_REQUEST,
            message: "Provide password"
          }
        }
        
      }else{
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: "Provide valid phone"
        }
      }
    }


    @Get('logout')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiOkResponse({description: 'logOut API'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    async logOut(@Request() req,@Response() res) {
      if(req.user.role == CONSTANT_MSG.ROLES.DOCTOR){
        const status = await this.calendarService.updateDocOffline(req.user.doctor_key);
        const lastActive = await this.calendarService.updateDocLastActive(req.user.doctor_key);
      }else if(req.user.role == CONSTANT_MSG.ROLES.PATIENT){
        const status = await this.calendarService.updatePatOffline(req.user.patientId);
        const lastActive = await this.calendarService.updatePatLastActive(req.user.patientId);
      }
      req.logOut();
      return res.json({message: "sucessfully loggedout"})
    }

    @Get('refreshToken')
    @ApiBearerAuth('JWT')
    @ApiOkResponse({description: 'refreshToken API'})
    @ApiUnauthorizedResponse({description: 'Invalid credentials'})
    async refreshToken(@Request() req,@Response() res) {
      var token2 = req.headers.authorization;
      token2 = token2.replace("Bearer", "").trim();
      var token1 = this.jwtService.decode(token2); 
      let token:any = token1;
      delete token.exp;
      delete token.iat;
      try{
        const newToken = this.jwtService.sign(token);
        return res.json({newToken:newToken,statusCode:HttpStatus.OK, message: "Token updated successfully"})
      } catch(e){
        console.log(e);
      }      
    }

    @Post('doctor/resetPassword')
    @ApiOkResponse({ description: '{ "password": "123456" ,"confirmPassword": "123456", "passcode":"k7noVjmL", "email":"test22@gmail.com"}' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBody({ type: UserDto })
    @ApiTags('Doctors')
    async doctorsResetPassword(@Request() req, @Body() userDto : UserDto) {
      if(!userDto.password){
        console.log("Provide password");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide password"}
      }else if(!userDto.confirmPassword){
        console.log("Provide confirmPassword");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide confirmPassword"}
      } else if(!userDto.passcode){
        console.log("Provide passcode");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide passcode"}
      } else if(!userDto.email){
        console.log("Provide email");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide email"}
      }
      if(userDto.password != userDto.confirmPassword){
        console.log("password and confirmPassword are not matching");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"password and confirmPassword are not matching"}
      }
      this.logger.log(`Doctor Login  Api -> Request data ${JSON.stringify(userDto)}`);
      const doc:any =await this.userService.doctorsResetPassword(userDto);
      return doc;
    }

    @Post('doctorRegistration')
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiTags('Admin')
    @ApiBody({type: DoctorDto})
    @ApiOkResponse({ description: 'requestBody example :{"isNewAccount":false,"email":"dharani@gmail.com","firstName":"Dharani","lastName":"Antharvedi","accountId":1, "qualification": "MBBS", "speciality": "ENT", "experience": "5", "password": "123456", "consultationCost" : "100", "number":"7845127845", "consultationSessionTimings":10}' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    async doctorRegistration(@Request() req, @reports() check:boolean, @Body() doctorDto : DoctorDto) {

      if (doctorDto['isNewAccount']) {
        return {
          statusCode: HttpStatus.NO_CONTENT,
          message: "Under development"
        }

      } else if (req.user.account_key !== 'Acc_' + doctorDto.accountId) {

        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: CONSTANT_MSG.DOC_REG_HOS_RES,
        }

      } else if (!doctorDto.email) {
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: "Provide email"
        }
      } else {
        const email = await this.userService.findDoctorByEmail(doctorDto.email);
        if (email) {
          return {
            statusCode: HttpStatus.BAD_REQUEST,
            message: CONSTANT_MSG.ALREADY_PRESENT
          }
        } else {

          const signUp = await this.userService.doctorRegistration(doctorDto, req.user);

          if (signUp && !signUp.statusCode) {
            doctorDto.accountKey = signUp.accountKey;
            doctorDto.doctorKey = signUp.doctorKey;

            const doctor = await this.calendarService.doctorInsertion(doctorDto);
            return doctor;
          } else {

            return  {
              signUp
            };

          }
        }
      }

    }

    @Post('accountRegistration')
    @ApiOkResponse({description: 'accountRegistration API'})
    @ApiUnauthorizedResponse({description: '{"isNewAccount":true,"hospitalName":"Lakshmi Hospitals","adminEmail":"lakshmi6@gmail.com","name":"Dharani","password":"123456", "state":"Andhra Pradesh","pincode":"533274","phone":"9999999999"}'})
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({type: DoctorDto})
    async accountRegistration(@Request() req, @Body() doctorDto: DoctorDto) {
      if (doctorDto.isNewAccount) {
        const accountreg = await this.userService.accountRegistration(doctorDto,req.user);
        if(accountreg.accountKey){
          doctorDto.accountKey = accountreg.accountKey;
          const accDetails = await this. calendarService.accountdetailsInsertion(doctorDto,req.user);
          return accDetails
        }
      }

    }


    @Post('doctor/forgotPassword')
    @ApiOkResponse({ description: ' { "email": "dharani@softsuave.com"}' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBody({ type: UserDto })
    @ApiTags('Doctors')
    async doctorForgotPassword(@Body() userDto : UserDto) {
      if(!userDto.email){
        console.log("Provide email");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide email"}
      }
      this.logger.log(`Doctor forgot password  Api -> Request data ${JSON.stringify(userDto)}`);
      const doc:any =await this.userService.doctorForgotPassword(userDto);
      return doc;
    }

    @Post('patient/forgotPassword')
    @ApiOkResponse({ description: ' { "phone": "9999999994"}' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBody({ type: UserDto })
    @ApiTags('Patient')
    async patientForgotPassword(@Body() patientDto : PatientDto) {
      if(!patientDto.phone){
        console.log("Provide phone");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide phone"}
      }
      this.logger.log(`Patient forgot password  Api -> Request data ${JSON.stringify(patientDto)}`);
      const pat:any =await this.userService.patientForgotPassword(patientDto);
      return pat;
    }

    @Post('patient/resetPassword')
    @ApiOkResponse({ description: '{ "password": "1234" ,"confirmPassword": "1234", "passcode":"syxT6KMr", "phone":"9999999994"}' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBody({ type: UserDto })
    @ApiTags('Patient')
    async patientResetPassword(@Body() patientDto : PatientDto) {
      if(!patientDto.password){
        console.log("Provide password");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide password"}
      }else if(!patientDto.confirmPassword){
        console.log("Provide confirmPassword");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide confirmPassword"}
      } else if(!patientDto.passcode){
        console.log("Provide passcode");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide passcode"}
      } else if(!patientDto.phone){
        console.log("Provide phone");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide phone"}
      }
      if(patientDto.password != patientDto.confirmPassword){
        console.log("password and confirmPassword are not matching");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"password and confirmPassword are not matching"}
      }
      this.logger.log(`Patient forgot password  Api -> Request data ${JSON.stringify(patientDto)}`);
      const pat:any =await this.userService.patientResetPassword(patientDto);
      return pat;
    }

    @Post('patient/changePassword')
    @ApiOkResponse({ description: ' { "phone": "9999999994","oldPassword":"123456","newPassword":"123456","confirmNewPassword":"123456"}' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({ type: UserDto })
    @ApiTags('Patient')
    async patientChangePassword(@Request() req, @patient() check: boolean,  @Body() patientDto : PatientDto) {
      if (!check)
        return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
      if(!patientDto.phone){
        console.log("Provide phone");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide phone"}
      }else if(!patientDto.newPassword){
        console.log("Provide newPassword");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide newPassword"}
      }else if(!patientDto.oldPassword){
        console.log("Provide oldPassword");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide oldPassword"}
      }else if(!patientDto.confirmNewPassword){
        console.log("Provide confirmNewPassword");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide confirmNewPassword"}
      }
      if(patientDto.newPassword != patientDto.confirmNewPassword){
        console.log("newPassword and confirmNewPassword are not same");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"newPassword and confirmNewPassword are not same"}
      }
      this.logger.log(`Patient change password  Api -> Request data ${JSON.stringify(patientDto)}`);
      const pat:any =await this.userService.patientChangePassword(patientDto,req.user);
      return pat;
    }

    @Post('doctor/changePassword')
    @ApiOkResponse({ description: ' { "email": "test22@gmail.com","oldPassword":"123456","newPassword":"123456","confirmNewPassword":"123456"}' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @ApiBody({ type: UserDto })
    @ApiTags('Doctors')
    async doctorChangePassword(@selfUserSettingRead() check: boolean, @accountUsersSettingsRead() check2: boolean, @Request() req,  @Body() patientDto : PatientDto) {
      if (!check && !check2)
        return {statusCode:HttpStatus.BAD_REQUEST ,message: CONSTANT_MSG.NO_PERMISSION}
      if(!patientDto.email){
        console.log("Provide email");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide email"}
      }else if(!patientDto.newPassword){
        console.log("Provide newPassword");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide newPassword"}
      }else if(!patientDto.oldPassword){
        console.log("Provide oldPassword");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide oldPassword"}
      }else if(!patientDto.confirmNewPassword){
        console.log("Provide confirmNewPassword");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide confirmNewPassword"}
      }
      if(patientDto.newPassword != patientDto.confirmNewPassword){
        console.log("newPassword and confirmNewPassword are not same");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"newPassword and confirmNewPassword are not same"}
      }
      this.logger.log(`Doctor change password  Api -> Request data ${JSON.stringify(patientDto)}`);
      const pat:any =await this.userService.doctorChangePassword(patientDto,req.user);
      return pat;
    }

}
