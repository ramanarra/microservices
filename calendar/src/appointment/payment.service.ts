import { Injectable, HttpStatus } from '@nestjs/common';
import { CONSTANT_MSG } from 'common-dto'
import {AppointmentRepository} from './appointment.repository';
import  * as RazorPay from 'razorpay'
import { json } from 'express';
const shortid = require('shortid');
const crypto = require('crypto');
var instance = new RazorPay({
    key_id:'rzp_test_7aIsTw8qZyCQOy',
    key_secret:'Oec8MS34qSS2BVhGMND0ym3L'
})


@Injectable()
export class PaymentService {

    constructor(private appointmentRepository:AppointmentRepository){
       
    }
 
    async paymentOrder(req): Promise<any> {
        const options = {
            amount:req.amount,
            currency:'INR',
            receipt:shortid.generate(),
            payment_capture:1
        }
       const response = await instance.orders.create(options);
       console.log(response);
       return response;
    }

    async paymentVerification(req): Promise<any> {
        const secret = 'Oec8MS34qSS2BVhGMND0ym3L';
        console.log(req);
        let data = req.razorpay_order_id+"|"+req.razorpay_payment_id;
        const digest = crypto.createHmac('SHA256', secret).update(data).digest('hex');
        console.log(digest,req.razorpay_signature)
        if(digest === req.razorpay_signature){
            return{
                statusCode:HttpStatus.OK,
                message:CONSTANT_MSG.SIGNATURE_VERIFIED
            }
        }else{
            return{
                statusCode:HttpStatus.BAD_REQUEST,
                message:CONSTANT_MSG.SIGNATURE_NOT_MATCHED
            }
        }
    }


}