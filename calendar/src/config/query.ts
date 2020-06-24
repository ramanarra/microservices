export const queries: any = {
 getWorkSchedule:'SELECT schDay."day_of_week", schDay."id" as scheduleDayId,schIntr."id" as scheduleTimeId,  schIntr."start_time", schIntr."end_time" from ' +
     'doc_config_schedule_day schDay left  join doc_config_schedule_interval schIntr on schIntr."doc_config_schedule_day_id" = schDay."id" where schDay."doctor_id" = $1',
 getDoctorScheduleInterval: 'select dcday."doctor_id", dcday."day_of_week", dcday."doctor_key", dcint."start_time", dcint."end_time" from doc_config_schedule_day dcday join doc_config_schedule_interval dcint on' +
     ' dcday."id" = dcint."doc_config_schedule_day_id" where dcday."doctor_key" = $1 and dcday."day_of_week" = $2',
 insertIntoDocConfigScheduleInterval: 'insert into doc_config_schedule_interval ("start_time", "end_time", "doc_config_schedule_day_id") values ( $1, $2, $3)',
 updateIntoDocConfigScheduleInterval: 'update  doc_config_schedule_interval set "start_time" = $1, "end_time" = $2  where "id" = $3',
 deleteDocConfigScheduleInterval: 'delete from doc_config_schedule_interval where "id" = $1 and "doc_config_schedule_day_id" = $2',
 getDocDetails:'SELECT * from doctor d join doc_config dc on dc."doctor_key"=d."doctor_key" where d."doctor_key" = $1',
 getDocListDetails:'SELECT * from doctor d join doc_config dc on dc."doctor_key"=d."doctor_key" where d."account_key" = $1'

}
