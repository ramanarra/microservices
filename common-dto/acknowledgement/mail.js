"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Email = void 0;
const nodemailer = require("nodemailer");
const config_1 = require("../config");
class Email {
    
    constructor() {
    }
    sendEmail(params) {
        var smtpUser = "rohitsachin311@gmail.com";
        var smtpPass = "rohit311";
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
            from: smtpUser,
            to: params.recipient,
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
