export const queries = {
    sampleQuery: 'sample text',
    getRolesPermission: 'SELECT "roleId", "permissionId", p."name" from role_permissions rp join permissions p on p."id" = rp."permissionId" where rp."roleId" = $1',
    getWorkSchedule: 'SELECT schDay."dayOfWeek", schDay."id" as scheduleDayId,schIntr."id" as scheduleTimeId,  schIntr."startTime", schIntr."endTime" from doc_config_schedule_day schDay left  join doc_config_schedule_interval schIntr on schIntr."docConfigScheduleDayId" = schDay."id" where schDay."doctor_id" = $1',
    getDoctorScheduleInterval: 'select dcday."doctor_id", dcday."dayOfWeek", dcday."doctor_key", dcint."startTime", dcint."endTime" from doc_config_schedule_day dcday join doc_config_schedule_interval dcint on dcday."id" = dcint."docConfigScheduleDayId" where dcday."doctor_key" = $1 and dcday."id" = $2  and dcint.id not in ($3)',
    insertIntoDocConfigScheduleInterval: 'insert into doc_config_schedule_interval ("startTime", "endTime", "docConfigScheduleDayId") values ( $1, $2, $3)',
    updateIntoDocConfigScheduleInterval: 'update  doc_config_schedule_interval set "startTime" = $1, "endTime" = $2  where "id" = $3',
    deleteDocConfigScheduleInterval: 'delete from doc_config_schedule_interval where "id" = $1 and "docConfigScheduleDayId" = $2',
    getDocDetails: 'SELECT * from doctor d join doc_config dc on dc."doctor_key"=d."doctor_key" where d."doctor_key" = $1',
    getDocListDetails: 'SELECT * from doctor d join doc_config dc on dc."doctor_key"=d."doctor_key" join account_details ad on ad."account_key" = d."account_key" where d."account_key" = $1',
    getConfig: 'SELECT "consultationSessionTimings","overBookingType","overBookingCount","overBookingEnabled" from doc_config where "doctor_key" = $1',
    getAppointment: 'SELECT * FROM appointment WHERE $1 <= "appointment_date" AND "appointment_date" <= $2 AND "doctorId" = $3 order by appointment_date',
    getAppointmentOnDate: 'SELECT * FROM appointment WHERE "appointment_date" = $1 order by appointment_date',
    getPastAppointmentsWithPagination: 'SELECT * FROM appointment WHERE "patient_id" = $1 AND "appointment_date" <= $2 AND "is_cancel"=false order by appointment_date limit $4 offset $3',
    getUpcomingAppointmentsWithPagination: 'SELECT * FROM appointment WHERE "patient_id" = $1 AND "appointment_date" >= $2 AND "is_cancel"=false order by appointment_date limit $4 offset $3',
    getAppointmentForDoctor: 'SELECT * FROM appointment WHERE "appointment_date" = $1 AND "doctorId" = $2',
    getAppointmentForDoctorAlongWithPatient: 'SELECT a."id" as "appointmentId",a."startTime",a."endTime",pd."patient_id" as "patientId",pd."firstName",pd."lastName",pd."photo",a."payment_status",a."paymentoption",a."consultationmode",a."status" FROM appointment a  join patient_details pd on pd."patient_id"=a."patient_id" WHERE a."appointment_date" = $1 AND a."doctorId" = $2 AND a."status"= $3 OR a."status"= $4 AND a."consultationmode"= $5',
    getPossibleListAppointmentDatesFor7Days: 'select appointment_date from appointment  where "doctorId" = $1 and appointment_date >=  $2 group by appointment_date limit 7',
    getListOfAppointmentFromDates : 'select * from appointment where "doctorId" = $1 and  appointment_date in $2 order by appointment_date',
    getPatientList:'SELECT patient."firstName", patient."lastName", patient."email", patient."dateOfBirth", patient."phone" , app.* from appointment app left join patient_details patient on app."patient_id" = patient."patient_id" where app."doctorId" = $1 order by appointment_date',
    getAppointments:'SELECT * from appointment where "doctorId" = $1 and "appointment_date" = $2 and "is_cancel"=false',
    //getAppList:'select * from appointment  where "doctorId" = $1 and appointment_date >= $2 group by appointment_date limit 7',
    getAppList:'SELECT * from appointment WHERE "doctorId" = $1 AND current_date <= "appointment_date" order by appointment_date',
    getAppListForPatient:'SELECT * from appointment WHERE "patient_id" = $1 AND current_date <= "appointment_date" order by appointment_date',
    getPaginationAppList:'SELECT * from appointment WHERE "doctorId" = $1 AND  "appointment_date" >= $2  AND "appointment_date" <= $3 order by appointment_date',
    getScheduleIntervalDays: 'select "docConfigScheduleDayId" from doc_config_schedule_interval  where doctorkey  =  $1 group by "docConfigScheduleDayId"',
   // getAppointByDocId: 'select * from appointment where "doctorId" = $1 and appointment_date >= $2  order by appointment_date limit 7 ',
    //getAppointByDocId:'SELECT app.* , patient."id" as patientId, patient."name" as patientName, payment."id" as paymentId, payment."is_paid" as isPaid, payment."refund" FROM appointment app left join patient_details patient on patient."id" = app."patient_id" left join payment_details payment on payment."appointment_id" = app."id" WHERE app."doctorId"= $1 and app."appointment_date" >= $2  order by appointment_date limit 7 ',
    getAppointByDocId:'SELECT app.* , patient."id" as patientId, patient."firstName" as "patientFirstName", patient."lastName" as "patientLastName", payment."id" as paymentId, payment."is_paid" as isPaid, payment."refund" FROM appointment app left join patient_details patient on patient."patient_id" = app."patient_id" left join payment_details payment on payment."appointment_id" = app."id" WHERE app."doctorId"= $1 and appointment_date >= $2 and app."is_cancel"=false  order by appointment_date ',
    getSlots: 'SELECT schIntr."startTime", schIntr."endTime" from doc_config_schedule_day schDay left  join doc_config_schedule_interval schIntr on schIntr."docConfigScheduleDayId" = schDay."id" where schDay."dayOfWeek" = $1 and schDay."doctor_key" = $2',
    getPatient:'SELECT * FROM patient_details WHERE phone LIKE $1',
    getPatientDetails:'SELECT "patient_id", "firstName","lastName","email","dateOfBirth","email", "phone" from patient_details where patient_id = $1',
    getReports:'SELECT doc."doctor_name" as "doctorName", config."consultation_cost" as "consultationFee", app."slotTiming" as "slotTime", app."appointment_date" as "appointmentDate", app."startTime", app."endTime", app."consultationmode" as "consultationType", patient."name" as "patientName", patient."phone" as phone from doctor doc left join appointment app on app."doctorId"=doc."doctorId" left join patient_details patient on patient."patient_id"=app."patient_id" left join doc_config config on config."doctor_key" = doc."doctor_key" where doc."account_key" = $1 order by appointment_date limit 10 offset $2',
    getDoctorScheduleIntervalAndDay: 'select * from doc_config_schedule_day dcsd   join doc_config_schedule_interval dcsi on dcsd.id = dcsi."docConfigScheduleDayId" where dcsd.doctor_key = $1;',
    getDoctorByName:'SELECT d."doctorId", d."account_key" as "accountKey", d."doctor_key" as "doctorKey", d."speciality", d."photo",d."signature",d."number",d."first_name" as "firstName", d."last_name" as "lastName", d."registration_number" as "registrationNumber", config."consultation_cost" as fee , config."consultationSessionTimings" as sessionTiming, ac."city" as location, ac."hospital_name" as "hospitalName" FROM doctor d left join doc_config config on config."doctor_key"=d."doctor_key" left join account_details ac on ac."account_key"=d."account_key" WHERE doctor_name ~* $1 or registration_number ~* $1',
    getHospitalByName:'select "hospital_name" as "hospitalName", "phone" as "number", "city" as location, "account_key" as "accountKey" ,"hospital_photo" as photo from account_details WHERE hospital_name ~* $1',
    getDocListForPatient: 'SELECT * from  appointment a join doctor d on a."doctorId"= d."doctorId" join doc_config dc on dc."doctor_key"=d."doctor_key" join account_details ad on ad."account_key" = d."account_key" where a."patient_id" = $1',
    getPastAppointments:'SELECT * FROM appointment WHERE "patient_id" = $1 AND "appointment_date" <= $2 AND "is_cancel"=false',
    getUpcomingAppointments:'SELECT * FROM appointment WHERE "patient_id" = $1 AND "appointment_date" >= $2 AND "is_cancel"=false',
    getExistAppointment:'SELECT * FROM appointment WHERE "doctorId"=$1 AND "patient_id"=$2 AND "appointment_date"=$3',
    getUpcomingAppointmentsForPatient: 'SELECT * FROM appointment WHERE "patient_id" = $1 AND "doctorId" = $4 AND "appointment_date" >= $2 AND "is_cancel"=false AND status= $5 OR status=$6 order by appointment_date limit 10 offset $3',
    getAppDoctorList:'SELECT * FROM appointment WHERE "doctorId" = $1 AND "patient_id" = $2 AND appointment_date >= $3 AND status= $4 OR status = $5 order by appointment_date',
    getPastAppointmentsForPatient: 'SELECT * FROM appointment WHERE "patient_id" = $1 AND "doctorId" = $4 AND "appointment_date" <= $2 AND "is_cancel"=false AND status= $5 order by appointment_date limit 10 offset $3',
    getPastAppDoctorList:'SELECT * FROM appointment WHERE "doctorId" = $1 AND "patient_id" = $2 AND appointment_date <= $3 AND status= $4 order by appointment_date',
    getPatientDoctorApps:'SELECT * from appointment a join patient_details pd ON a."patient_id" = pd."patient_id" WHERE a."doctorId" = $1 AND a."appointment_date" >= current_date AND a."is_cancel"=false AND pd.name ~* $2 OR pd.email ~* $2 OR pd.phone ~* $2',
}