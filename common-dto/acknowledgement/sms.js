"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Sms = void 0;
const config_1 = require("../config");
// import * as config from '../config';
//import * as cconfig from '../../auth/config';
var request = require('request');
//const textLocalConfig = cconfig.get('textLocal');
class Sms {
    constructor() {
    }
    sendSms(params) {
        try {
            // Construct data
            let apiKey = params.apiKey;
            let message = "&message=" + params.message;
            let sender = "&sender=" + params.sender;
            let numbers = "&numbers=" + params.number;
            // Send data   
            var txt = 'https://api.textlocal.in/send/';
            let data = apiKey + numbers + message + sender;
            var path = txt + data;
            request.post(path, { json: { key: apiKey } }, function (error, response, body) {
                if (!error && response.statusCode == 200) {
                    console.log(body);
                }
            });
        }
        catch (e) {
            console.log(e);
            return {
                statusCode: '200',
                message: config_1.CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            };
        }
    }
}
exports.Sms = Sms;
