export const queries = {
    sampleQuery: 'sample text',
    getRolesPermission: 'SELECT "roleId", "permissionId", p."name" from role_permissions rp join permissions p on p."id" = rp."permissionId" where rp."roleId" = $1',
    getWorkSchedule: 'SELECT schDay."dayOfWeek", schDay."id" as scheduleDayId,schIntr."id" as scheduleTimeId,  schIntr."startTime", schIntr."endTime" from doc_config_schedule_day schDay left  join doc_config_schedule_interval schIntr on schIntr."docConfigScheduleDayId" = schDay."id" where schDay."doctor_id" = $1',
    getDoctorScheduleInterval: 'select dcday."doctor_id", dcday."dayOfWeek", dcday."doctor_key", dcint."startTime", dcint."endTime" from doc_config_schedule_day dcday join doc_config_schedule_interval dcint on dcday."id" = dcint."docConfigScheduleDayId" where dcday."doctor_key" = $1 and dcday."id" = $2  and dcint.id not in ($3)',
    insertIntoDocConfigScheduleInterval: 'insert into doc_config_schedule_interval ("startTime", "endTime", "docConfigScheduleDayId") values ( $1, $2, $3)',
    updateIntoDocConfigScheduleInterval: 'update  doc_config_schedule_interval set "startTime" = $1, "endTime" = $2  where "id" = $3',
    deleteDocConfigScheduleInterval: 'delete from doc_config_schedule_interval where "id" = $1 and "docConfigScheduleDayId" = $2',
    getDocDetails: 'SELECT * from doctor d join doc_config dc on dc."doctor_key"=d."doctor_key" where d."doctor_key" = $1',
    getDocListDetails: 'SELECT * from doctor d join doc_config dc on dc."doctor_key"=d."doctor_key" where d."account_key" = $1',
    getConfig: 'SELECT "consultationSessionTimings","overBookingType","overBookingCount","overBookingEnabled" from doc_config where "doctor_key" = $1',
    getAppointment: 'SELECT * FROM appointment WHERE $1 <= "appointment_date" AND "appointment_date" <= $2 AND "doctorId" = $3 order by appointment_date',
    getAppointmentOnDate: 'SELECT * FROM appointment WHERE "appointment_date" = $1 order by appointment_date',
    getPastAppointmentsWithPagination: 'SELECT * FROM appointment WHERE "patient_id" = $1 AND "appointment_date" <= $2 order by appointment_date limit 10 offset $3',
    getUpcomingAppointmentsWithPagination: 'SELECT * FROM appointment WHERE "patient_id" = $1 AND "appointment_date" >= $2 order by appointment_date limit 10 offset $3',
    getAppointmentForDoctor: 'SELECT * FROM appointment WHERE "appointment_date" = $1 AND "doctorId" = $2',
    getPossibleListAppointmentDatesFor7Days: 'select appointment_date from appointment  where "doctorId" = $1 and appointment_date >=  $2 group by appointment_date limit 7',
    getListOfAppointmentFromDates : 'select * from appointment where "doctorId" = $1 and  appointment_date in $2 order by appointment_date',
    getPatientList:'SELECT patient."firstName", patient."lastName", patient."email", patient."dateOfBirth", patient."phone" , app.* from appointment app left join patient_details patient on app."patient_id" = patient."patient_id" where app."doctorId" = $1 order by appointment_date',
    getAppointments:'SELECT * from appointment where "doctorId" = $1 and "appointment_date" = $2',
    //getAppList:'select * from appointment  where "doctorId" = $1 and appointment_date >= $2 group by appointment_date limit 7',
    getAppList:'SELECT * from appointment WHERE "doctorId" = $1 AND current_date <= "appointment_date" order by appointment_date',
    getAppListForPatient:'SELECT * from appointment WHERE "patient_id" = $1 AND current_date <= "appointment_date" order by appointment_date',
    getPaginationAppList:'SELECT * from appointment WHERE "doctorId" = $1 AND  "appointment_date" >= $2  AND "appointment_date" <= $3 order by appointment_date',
    getScheduleIntervalDays: 'select "docConfigScheduleDayId" from doc_config_schedule_interval  where doctorkey  =  $1 group by "docConfigScheduleDayId"',
   // getAppointByDocId: 'select * from appointment where "doctorId" = $1 and appointment_date >= $2  order by appointment_date limit 7 ',
    //getAppointByDocId:'SELECT app.* , patient."id" as patientId, patient."name" as patientName, payment."id" as paymentId, payment."is_paid" as isPaid, payment."refund" FROM appointment app left join patient_details patient on patient."id" = app."patient_id" left join payment_details payment on payment."appointment_id" = app."id" WHERE app."doctorId"= $1 and app."appointment_date" >= $2  order by appointment_date limit 7 ',
    getAppointByDocId:'SELECT app.* , patient."id" as patientId, patient."name" as patientName, payment."id" as paymentId, payment."is_paid" as isPaid, payment."refund" FROM appointment app left join patient_details patient on patient."id" = app."patient_id" left join payment_details payment on payment."appointment_id" = app."id" WHERE app."doctorId"= $1 and appointment_date >= $2  order by appointment_date ',
    getSlots: 'SELECT schIntr."startTime", schIntr."endTime" from doc_config_schedule_day schDay left  join doc_config_schedule_interval schIntr on schIntr."docConfigScheduleDayId" = schDay."id" where schDay."dayOfWeek" = $1 and schDay."doctor_key" = $2',
    getPatient:'SELECT * FROM patient_details WHERE phone LIKE $1',
    getPatientDetails:'SELECT "patient_id", "firstName","lastName","email","dateOfBirth","email", "phone" from patient_details where patient_id = $1',
    getReports:'SELECT doc."doctor_name" as doctorName, config."consultation_cost" as consultationFee, app."slotTiming" as slotTime, patient."name" as patientName, patient."phone" as phone from doctor doc left join appointment app on app."doctorId"=doc."doctorId" left join patient_details patient on patient."patient_id"=app."patient_id" left join doc_config config on config."doctor_key" = doc."doctor_key" where doc."account_key" = $1',
    getDoctorScheduleIntervalAndDay: 'select * from doc_config_schedule_day dcsd   join doc_config_schedule_interval dcsi on dcsd.id = dcsi."docConfigScheduleDayId" where dcsd.doctor_key = $1;'
}