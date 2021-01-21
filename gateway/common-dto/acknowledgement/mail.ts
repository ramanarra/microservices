import * as nodemailer from 'nodemailer';
import { CONSTANT_MSG } from '../config';
// import {HttpStatus} from '@nestjs/common';
export class Email {
    smtpUser:any;
    smtpPass:any;
    smtpHost:any;
    smtpPort:any;
    // constructor(private params: any) {
    //     this.smtpUser = params.smtpUser;
    //     this.smtpPass = params.smtpPass;
    //     this.smtpHost = params.smtpHost;
    //     this.smtpPort = params.smtpPort;
    //  }
    constructor(){
        
    }
    sendEmail (params:any) {
        var smtpUser = "dharani@softsuave.com";
        var smtpPass = "softsuave@123";
        var smtpHost = "smtp.gmail.com";
        var smtpPort = 465;
        // var smtpUser = params.smtpUser;
        // var smtpPass = params.smtpPass;
        // var smtpHost = "smtp.gmail.com";
        // var smtpPort = 465;

        //const nodemailer = MailerModule;
        //const nodemailer = require('nodemailer')

        let transporter = nodemailer.createTransport({
            host: smtpHost,
            port: smtpPort,
            secure: true,
            auth: {
                user: smtpUser,
                pass: smtpPass
            },
            tls: {
                rejectUnauthorized: false
            }
        });

        let mailOptions = {
            from: smtpUser,
            to: params.recipient,
            // cc: params.cc,
            // bcc: params.bcc,
            subject: params.subject,
            html: params.template,
        };

        transporter.sendMail(mailOptions, async (error, info) => {
            if (error) {
                console.log(error);
                return{
                    statusCode:501,
                    message: CONSTANT_MSG.MAIL_ERROR
                }
            } else {
                return{
                    statusCode:200,
                    message: CONSTANT_MSG.MAIL_OK
                }
            }
        });
    }

}
