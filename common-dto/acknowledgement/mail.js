"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Email = void 0;
const nodemailer = require("nodemailer");
const config_1 = require("../config");
// import {HttpStatus} from '@nestjs/common';
class Email {
    // constructor(private params: any) {
    //     this.smtpUser = params.smtpUser;
    //     this.smtpPass = params.smtpPass;
    //     this.smtpHost = params.smtpHost;
    //     this.smtpPort = params.smtpPort;
    //  }
    constructor() {
    }
    sendEmail(params) {
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
                return {
                    statusCode: 501,
                    message: config_1.CONSTANT_MSG.MAIL_ERROR
                };
            }
            else {
                return {
                    statusCode: 200,
                    message: config_1.CONSTANT_MSG.MAIL_OK
                };
            }
        });
    }
}
exports.Email = Email;
