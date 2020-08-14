import { Injectable, HttpStatus } from '@nestjs/common';
import { CONSTANT_MSG } from 'common-dto'
import {AppointmentRepository} from './appointment.repository';
import  * as RazorPay from 'razorpay';

var instance = new RazorPay({
    key_id:'rzp_test_7aIsTw8qZyCQOy',
    key_secret:'Oec8MS34qSS2BVhGMND0ym3L'
})


@Injectable()
export class PaymentService {

    constructor(private appointmentRepository:AppointmentRepository){
       
    }
 
   async paymentOrder(req): Promise<any> {
       let amount= req.amount;
       let currency = req.currency;
       let receipt = req.receipt;
       let payment_capture = req.payment_capture;
       return instance.orders.create(req, function(err, res) {
            console.log(res);
            //return res;
       });
   }


}
