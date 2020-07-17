export class Helper {

    static getTimeInMilliSeconds(time: any) {
        let splitStartTime = time.split(':');
        let startTimeMilliSeconds = (splitStartTime[0] * (60000 * 60)) + (splitStartTime[1] * 60000);
        return startTimeMilliSeconds;
    }

    static getConsultationTimeInMilliSeconds(time: any) {
        let startTimeMilliSeconds =(time * 60000);
        return startTimeMilliSeconds;
    }

    static getTimeinHrsMins(x: any) {
        let h = x / (60*60*1000)
         x = x - h*(60*60*1000)
        let  m = x / (60*1000)
         return (h+':'+m)
     }
 
     static getMinInMilliSeconds(x: any) {
         let mi = x * 60000
          return (mi)
      }


}