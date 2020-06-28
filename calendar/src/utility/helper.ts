export class Helper {

    static getTimeInMilliSeconds(time: any) {
        let splitStartTime = time.split(':');
        let startTimeMilliSeconds = (splitStartTime[0] * (60000 * 60)) + (splitStartTime[1] * 60000);
        return startTimeMilliSeconds;
    }


}