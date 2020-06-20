export const queries: any = {
 updateDoctorConfig :'update doc_config set ',
 getWorkSchedule:'SELECT rp."day_of_week", rp."id" as scheduleDayId,p."id" as scheduleTimeId,  p."start_time", p."end_time" from doc_config_schedule_day rp join doc_config_schedule_interval p on p."doc_config_schedule_day_id" = rp."id" where rp."doctor_id" = $1'
}
