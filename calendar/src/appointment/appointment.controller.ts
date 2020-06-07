import { Controller, Logger } from '@nestjs/common';
import { AppointmentService } from './appointment.service';
import { MessagePattern } from '@nestjs/microservices';
import { AppointmentDto } from 'common-dto';

@Controller('appointment')
export class AppointmentController {

    private logger = new Logger('AppointmentController');

    constructor(private readonly appointmentService: AppointmentService) {

    }

    @MessagePattern({ cmd: 'calendar_appointment_get_list' })
    async getList(userDto : any): Promise<any> {
        console.log("asdasd");
        const appointment = await this.appointmentService.getAppointmentList(userDto);
        this.logger.log("asfn >>> " + appointment);
        return appointment;
    }

    @MessagePattern({ cmd: 'calendar_appointment_create' })
    async createAppointment(appointmentDetails: any): Promise<any> {
        this.logger.log("appointmentDetails >>> " + appointmentDetails);
        const appointment = await this.appointmentService.createAppointment(appointmentDetails);
        
        return appointment;
    }

    
    @MessagePattern({ cmd: 'auth_doctor_details' })
    async doctor_Login(doctorKey) : Promise<any> {
        const doctor = await this.appointmentService.doctorDetails(doctorKey);
        var doc=[];
        doc[0]=doctor;
        var accountKey = doctor.accountKey;
        const account = await this.appointmentService.accountDetails(accountKey);
        doc[1]=account;
        return doc;
       
    }

    @MessagePattern({ cmd: 'app_doctor_list' })
    async doctorList(arr) : Promise<any> {
        if(arr[0]=="Doctor"){
            var doctorKey = arr[1];
            const doctor = await this.appointmentService.doctorDetails(doctorKey);
            var accountKey = doctor.accountKey;
            const account = await this.appointmentService.doctor_List(accountKey);
            return {
                doctorList:account
            }
        }else if(arr[0]=='Admin'){
            var accountKey = arr[1];
            const account = await this.appointmentService.accountDetails(accountKey);
            const doctor = await this.appointmentService.doctor_List(accountKey);
            return {
                accountDetails:account,
                doctorList:doctor
            }


        }
       
    }


    @MessagePattern({ cmd: 'app_doctor_view' })
    async doctorView(key) : Promise<any> {
            const doctor = await this.appointmentService.doctorDetails(key);
            var accountKey = doctor.accountKey;
            const account = await this.appointmentService.accountDetails(accountKey);
            return {
                doctorDetails: doctor,
                accountDetails:account
            }
        }

        
    @MessagePattern({ cmd: 'app_doctor_preconsultation' })
    async doctorPreconsultation(doctorConfigPreConsultationDto:any) : Promise<any> {
        //    const preconsultation = await this.appointmentService.doctorPreconsultation(doctorConfigPreConsultationDto);
          //  return preconsultation;
        }

    



}
