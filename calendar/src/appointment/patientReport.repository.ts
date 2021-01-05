import { Repository, EntityRepository } from "typeorm";
import { ConflictException, InternalServerErrorException, Logger } from "@nestjs/common";
import {PatientReport} from "./patientReport.entity";

@EntityRepository(PatientReport)
export class PatientReportRepository extends Repository<PatientReport> {
     
    private logger = new Logger('PatientReportRepository');
    async patientReportInsertion(patientReportDto : any) :Promise<any>{

           const patienReport = new PatientReport();
           patienReport.id = patientReportDto.id;
           patienReport.patientId = patientReportDto.patientId
           patienReport.appointmentId = patientReportDto.appointmentId ? patientReportDto.appointmentId : null ;
           patienReport.fileName = patientReportDto.fileName ? patientReportDto.fileName : null ;
           patienReport.fileType = patientReportDto.fileType ? patientReportDto.fileType : null ;
           patienReport.reportURL = patientReportDto.reportURL ? patientReportDto.reportURL : null ;
           patienReport.reportURL = patientReportDto.reportURL ? patientReportDto.reportURL : null ;
           patienReport.reportDate = patientReportDto.reportDate ? patientReportDto.reportDate : null ;
           patienReport.comments = patientReportDto.comments ? patientReportDto.comments : null ;


           try {
            const acc = await patienReport.save();
            return acc;
            } catch (error) {
            this.logger.error(`Unexpected patientReport save error` + error.message);
            throw new InternalServerErrorException();
        }

    }

}