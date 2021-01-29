import * as nodemailer from 'nodemailer';
import { CONSTANT_MSG } from '../config';
// import {HttpStatus} from '@nestjs/common';
export class Email {
    smtpUser:any;
    smtpPass:any;
    smtpHost:any;
    smtpPort:any;

    constructor(){}

    async sendEmail(params:any): Promise<any> {
        var smtpUser = "support@virujh.com";
        var smtpPass = "Virujh!2Yda";
        var smtpHost = "smtp.gmail.com";
        var smtpPort = 465;

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
            from: '"notification@virujh.com" <support@virujh.com>',
            to: params.recipient,
            // cc: params.cc,
            // bcc: params.bcc,
            subject: params.subject,
            html: params.template,
        };

        transporter.sendMail(mailOptions, async(err, info) => {
            if (err) {
                console.log("line ==> 55", err);
                return{
                    statusCode: 501,
                    message: CONSTANT_MSG.MAIL_ERROR
                }
            } else {
                return{
                    statusCode: 200,
                    message: CONSTANT_MSG.MAIL_OK
                }
            }
        });
    }

}
