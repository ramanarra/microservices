export const queries: any = {
 getWorkSchedule:'SELECT rp."day_of_week", rp."id" as scheduleDayId,p."id" as scheduleTimeId,  p."start_time", p."end_time" from doc_config_schedule_day rp join' +
     ' doc_config_schedule_interval p on p."doc_config_schedule_day_id" = rp."id" where rp."doctor_id" = $1',
 getDoctorScheduleInterval: 'select dcday."doctor_id", dcday."day_of_week", dcday."doctor_key", dcint."start_time", dcint."end_time" from doc_config_schedule_day dcday join doc_config_schedule_interval dcint on' +
     ' dcday."id" = dcint."doc_config_schedule_day_id" where dcday."doctor_key" = $1 and dcday."day_of_week" = $2',
 insertIntoDocConfigScheduleInterval: 'insert into doc_config_schedule_interval ("start_time", "end_time", "doc_config_schedule_day_id") values ( $1, $2, $3)',
 updateIntoDocConfigScheduleInterval: 'update  doc_config_schedule_interval set "start_time" = $1, "end_time" = $2  where "id" = $3'

}
