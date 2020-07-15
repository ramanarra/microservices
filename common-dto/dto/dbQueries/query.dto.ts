export const queries = {
    sampleQuery: 'sample text',
    getRolesPermission: 'SELECT "roleId", "permissionId", p."name" from role_permissions rp join permissions p on p."id" = rp."permissionId" where rp."roleId" = $1',
    getWorkSchedule: 'SELECT schDay."dayOfWeek", schDay."id" as scheduleDayId,schIntr."id" as scheduleTimeId,  schIntr."startTime", schIntr."endTime" from doc_config_schedule_day schDay left  join doc_config_schedule_interval schIntr on schIntr."docConfigScheduleDayId" = schDay."id" where schDay."doctor_id" = $1',
    getDoctorScheduleInterval: 'select dcday."doctor_id", dcday."dayOfWeek", dcday."doctor_key", dcint."startTime", dcint."endTime" from doc_config_schedule_day dcday join doc_config_schedule_interval dcint on dcday."id" = dcint."docConfigScheduleDayId" where dcday."doctor_key" = $1 and dcday."id" = $2',
    insertIntoDocConfigScheduleInterval: 'insert into doc_config_schedule_interval ("startTime", "endTime", "docConfigScheduleDayId") values ( $1, $2, $3)',
    updateIntoDocConfigScheduleInterval: 'update  doc_config_schedule_interval set "startTime" = $1, "endTime" = $2  where "id" = $3',
    deleteDocConfigScheduleInterval: 'delete from doc_config_schedule_interval where "id" = $1 and "docConfigScheduleDayId" = $2',
    getDocDetails: 'SELECT * from doctor d join doc_config dc on dc."doctor_key"=d."doctor_key" where d."doctor_key" = $1',
    getDocListDetails: 'SELECT * from doctor d join doc_config dc on dc."doctor_key"=d."doctor_key" where d."account_key" = $1',
    getConfig: 'SELECT "consultationSessionTimings","overBookingType","overBookingCount","overBookingEnabled" from doc_config where "doctor_key" = $1',
    getAppointment: 'SELECT * FROM appointment WHERE $1 <= "appointment_date" AND "appointment_date" <= $2 AND "doctorId" = $3 order by appointment_date',
    getAppointmentOnDate: 'SELECT * FROM appointment WHERE "appointment_date" = $1 order by appointment_date',
    getPastAppointment: 'SELECT * FROM appointment WHERE "patient_id" = $1 AND "appointment_date" <= $2 order by appointment_date',
    getUpcomingAppointment: 'SELECT * FROM appointment WHERE "patient_id" = $1 AND "appointment_date" >= $2 order by appointment_date',
    getAppointmentForDoctor: 'SELECT * FROM appointment WHERE "appointment_date" = $1 AND "doctorId" = $2',
    getPossibleListAppointmentDatesFor7Days: 'select appointment_date from appointment  where "doctorId" = $1 and appointment_date >= current_date group by appointment_date limit 7',
    getListOfAppointmentFromDates : 'select * from appointment where "doctorId" = $1 and  appointment_date in $2 order by appointment_date',
    getPatientList:'SELECT "firstName","lastName","email","phone","dateOfBirth" FROM patient_details'

}