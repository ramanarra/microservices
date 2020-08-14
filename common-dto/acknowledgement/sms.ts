import { CONSTANT_MSG } from '../config';
import * as config from '../config';
var request = require('request');
//const textLocalConfig = config.get('textLocal');

export class Sms {
    sendSms (params:any) {        
        try {
            // Construct data
            //let apiKey:string = "apikey=" + textLocalConfig.apiKey;
            let apiKey = params.apiKey;
            let message:string = "&message=" + params.message;
            let sender:string = "&sender=" + params.sender;
            let numbers:string = "&numbers=" + params.number;
            
            // Send data   
            var txt = 'https://api.textlocal.in/send/';        
            let data:string = apiKey + numbers + message + sender;
            var path = txt + data;
            request.post(
                path,
                { json: { key: apiKey} },
                function (error:any, response:any, body:any) {
                    if (!error && response.statusCode == 200) {
                        console.log(body);
                    }
                }
            );

        } catch (e) {
            console.log(e)
            return {
                statusCode:'200',
                message:  CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
            
    }

}
