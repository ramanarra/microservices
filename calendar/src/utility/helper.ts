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

    static getTimeinHrsMins(milliseconds: any) {
        //Get hours from milliseconds
        var hours = milliseconds / (1000*60*60);
        var absoluteHours = Math.floor(hours);
        var h = absoluteHours > 9 ? absoluteHours : '0' + absoluteHours;

        //Get remainder from hours and convert to minutes
        var minutes = (hours - absoluteHours) * 60;
        var absoluteMinutes = Math.floor(minutes);
        var m = absoluteMinutes > 9 ? absoluteMinutes : '0' +  absoluteMinutes;

        //Get remainder from minutes and convert to seconds
        var seconds = (minutes - absoluteMinutes) * 60;
        var absoluteSeconds = Math.floor(seconds);
        var s = absoluteSeconds > 9 ? absoluteSeconds : '0' + absoluteSeconds;

        return h + ':' + m + ':' + s;
     }
    
     static getMinInMilliSeconds(x: any) {
         let mi = x * 60000
          return (mi)
      }


}