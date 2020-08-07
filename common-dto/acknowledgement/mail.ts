import * as nodemailer from 'nodemailer';
export class Email {
    sendEmail (params:any) {
        var smtpUser = "dharani@softsuave.com";
        var smtpPass = "softsuave@123";
        var smtpHost = "smtp.gmail.com";
        var smtpPort = 465;

        //const nodemailer = MailerModule;
        //const nodemailer = require('nodemailer')

        let transporter = nodemailer.createTransport({
            host: smtpHost,
            port: smtpPort,
            secure: true,
            auth: {
                user: smtpUser,
                pass: smtpPass
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
            } else {
              return 1;
            }
        });
    }

}
