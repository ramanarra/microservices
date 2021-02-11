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
    getPastAppointmentsWithPagination: 'SELECT * FROM appointment WHERE "patient_id" = $1 AND "appointment_date" <= $2 AND "status"=$5 AND "is_cancel"=false order by appointment_date limit $4 offset $3',
    getUpcomingAppointmentsWithPagination: 'SELECT * FROM appointment WHERE "patient_id" = $1 AND "appointment_date" >= $2 AND ("status"= $5 OR "status" = $6) AND "is_cancel"=false order by appointment_date limit $4 offset $3',
    getAppointmentForDoctor: 'SELECT * FROM appointment WHERE "appointment_date" = $1 AND "doctorId" = $2 AND "is_cancel"=false',
    getAppointmentForDoctorAlongWithPatient: 'SELECT a."id" as "appointmentId",a."startTime",a."endTime",pd."patient_id" as "patientId",pd."firstName",pd."lastName",pd."photo",pd."live_status" as "patientLiveStatus", a."payment_status",a."paymentoption",a."consultationmode",a."status" FROM appointment a  join patient_details pd on pd."patient_id"=a."patient_id" WHERE a."appointment_date" = $1 AND a."doctorId" = $2 AND (a."status"= $3 OR a."status"= $4) AND a."consultationmode"= $5 AND a."is_cancel"=false',
    getPossibleListAppointmentDatesFor7Days: 'select appointment_date from appointment  where "doctorId" = $1 and appointment_date >=  $2 group by appointment_date limit 7',
    getListOfAppointmentFromDates : 'select * from appointment where "doctorId" = $1 and  appointment_date in $2 order by appointment_date',
    getPatientList:'SELECT patient."firstName", patient."lastName", patient."email", patient."dateOfBirth", patient."phone" , app.* from appointment app left join patient_details patient on app."patient_id" = patient."patient_id" where app."doctorId" = $1 order by appointment_date',

    //to retrive appointment with start & end times
    getAvailableTime: `SELECT dcsi."startTime", dcsi."endTime", doctor_id, "dayOfWeek", dcsi."docConfigScheduleDayId"
                            from doc_config_schedule_day dcsd 
                            left join doc_config_schedule_interval dcsi on dcsi."docConfigScheduleDayId" = dcsd.id
                        where dcsd.doctor_id = $1 
                            and dcsi."startTime" notnull 
                            and dcsi."endTime" notnull`,
    getActiveAppointment: `select app."doctorId", app.appointment_date, app."startTime", app."endTime", app.is_active 
                                from appointment app 
                                where app.is_active = true 
                                    and app."doctorId" = $1 
                                    and app.appointment_date >= $2 
                                    and app.appointment_date  <= $3`,

    getAppointments:'SELECT * from appointment where "doctorId" = $1 and "appointment_date" = $2 and "is_cancel"=false',
    //getAppList:'SELECT * from appointment WHERE "doctorId" = $1 AND current_date <= "appointment_date" order by appointment_date',
    getAppList:'SELECT * from appointment WHERE "doctorId" = $1 order by appointment_date',

    
    getReport: 'SELECT "file_name" as "fileName", "report_date" as "reportDate", "report_url" as "attachment" , comments FROM patient_report  WHERE patient_id = $1 Order by id DESC offset $2 limit $3',
    getReportWithoutLimit: 'SELECT * FROM patient_report  WHERE patient_id = $1 Order by id DESC',
    getReportWithoutLimitSearch: 'SELECT * FROM patient_report  WHERE patient_id = $1  AND (LOWER(comments) LIKE $2 OR LOWER(file_name) LIKE $2) Order by id DESC',
    getSearchReportByAppointmentId:'SELECT "file_name" as "fileName", "report_date" as "reportDate", comments FROM patient_report  WHERE appointment_id = $1 AND (LOWER(comments) LIKE $4 OR LOWER(file_name) LIKE $4) Order by id DESC offset $2 limit $3',
    getReportByAppointmentId:'SELECT "file_name" as "fileName", "report_date" as "reportDate", comments FROM patient_report  WHERE appointment_id = $1  Order by id DESC offset $2 limit $3',

    getReportWithoutLimitAppointmentIdSearch:'SELECT * FROM patient_report  WHERE appointment_id = $1 AND (LOWER(comments) LIKE $2 OR LOWER(file_name) LIKE $2) Order by id DESC',
    getReportWithAppointmentId: 'SELECT * FROM patient_report  WHERE appointment_id = $1 Order by id DESC',
    getSearchReport: 'SELECT "file_name" as "fileName", "report_url" as "attachment" , "report_date" as "reportDate", comments FROM patient_report  WHERE patient_id = $1 AND (LOWER(comments) LIKE $4 OR LOWER(file_name) LIKE $4) Order by id DESC offset $2 limit $3',

    getAppListForPatient:'SELECT * from appointment WHERE "patient_id" = $1 AND current_date <= "appointment_date" order by appointment_date',
    getPaginationAppList:'SELECT * from appointment WHERE "doctorId" = $1 AND  "appointment_date" >= $2  AND "appointment_date" <= $3 order by appointment_date',
    getScheduleIntervalDays: 'select "docConfigScheduleDayId" from doc_config_schedule_interval  where doctorkey  =  $1 group by "docConfigScheduleDayId"',
   // getAppointByDocId: 'select * from appointment where "doctorId" = $1 and appointment_date >= $2  order by appointment_date limit 7 ',
    //getAppointByDocId:'SELECT app.* , patient."id" as patientId, patient."name" as patientName, payment."id" as paymentId, payment."is_paid" as isPaid, payment."refund" FROM appointment app left join patient_details patient on patient."id" = app."patient_id" left join payment_details payment on payment."appointment_id" = app."id" WHERE app."doctorId"= $1 and app."appointment_date" >= $2  order by appointment_date limit 7 ',
    getAppointByDocId:'SELECT app.* , patient."id" as patientId, patient."firstName" as "patientFirstName", patient."lastName" as "patientLastName", payment."id" as paymentId, payment."payment_status" as "fullyPaid" FROM appointment app left join patient_details patient on patient."patient_id" = app."patient_id" left join payment_details payment on payment."appointment_id" = app."id" WHERE app."doctorId"= $1 and appointment_date >= $2 and app."is_cancel"=false  order by appointment_date ',
    getSlots: 'SELECT schIntr."startTime", schIntr."endTime" from doc_config_schedule_day schDay left  join doc_config_schedule_interval schIntr on schIntr."docConfigScheduleDayId" = schDay."id" where schDay."dayOfWeek" = $1 and schDay."doctor_key" = $2',
    getPatient:'SELECT * FROM patient_details WHERE phone LIKE $1',
    getPatientDetails:'SELECT "patient_id", "firstName","lastName","email","dateOfBirth","email", "phone" from patient_details where patient_id = $1',
    getReports:'SELECT doc."doctor_name" as "doctorName", config."consultation_cost" as "consultationFee", app."slotTiming" as "slotTime", app."appointment_date" as "appointmentDate", app."startTime", app."endTime", app."consultationmode" as "consultationType", patient."name" as "patientName", patient."phone" as phone from doctor doc left join appointment app on app."doctorId"=doc."doctorId" left join patient_details patient on patient."patient_id"=app."patient_id" left join doc_config config on config."doctor_key" = doc."doctor_key" where doc."account_key" = $1 order by appointment_date limit 10 offset $2',
    getDoctorScheduleIntervalAndDay: 'select * from doc_config_schedule_day dcsd   join doc_config_schedule_interval dcsi on dcsd.id = dcsi."docConfigScheduleDayId" where dcsd.doctor_key = $1;',
    getDoctorByName:'SELECT distinct d."doctorId", d."account_key" as "accountKey", d."doctor_key" as "doctorKey", d."speciality", d."photo",d."signature",d."number",d."first_name" as "firstName", d."last_name" as "lastName", d."registration_number" as "registrationNumber", config."consultation_cost" as fee , config."consultationSessionTimings" as sessionTiming, ac."city" as location, ac."hospital_name" as "hospitalName" FROM doctor d left join doc_config config on config."doctor_key"=d."doctor_key" left join account_details ac on ac."account_key"=d."account_key" WHERE LOWER(doctor_name) LIKE LOWER($1) or LOWER(registration_number)  LIKE LOWER($1) or LOWER(speciality)  LIKE LOWER($1) ',
    getHospitalByName:'select "hospital_name" as "hospitalName", "phone" as "number", "city" as location, "account_key" as "accountKey" ,"hospital_photo" as photo from account_details WHERE hospital_name ~* $1',
    getDocListForPatient: 'SELECT * from  appointment a join doctor d on a."doctorId"= d."doctorId" join doc_config dc on dc."doctor_key"=d."doctor_key" join account_details ad on ad."account_key" = d."account_key" where a."patient_id" = $1',
    getPastAppointments:'SELECT * FROM appointment WHERE "patient_id" = $1 AND "appointment_date" <= $2 AND "is_cancel"=false AND "status"=$3',
    getUpcomingAppointments:'SELECT * FROM appointment WHERE "patient_id" = $1 AND "appointment_date" >= $2 AND ("status"= $3 OR "status"=$4)  AND "is_cancel"=false',
    getExistAppointment:'SELECT * FROM appointment WHERE "doctorId"=$1 AND "patient_id"=$2 AND "appointment_date"=$3 AND "is_cancel"=false',
    getUpcomingAppointmentsForPatient: 'SELECT a."id" as "appointmentId", a."appointment_date" as "appointmentDate",a."startTime", a."endTime", a."doctorId", a."patient_id" as "patientId", adc."is_preconsultation_allowed",adc."pre_consultation_hours",adc."pre_consultation_mins", d."first_name" as "doctorFirstName",d."last_name" as "doctorLastName", ac."hospital_name" as "hospitalName" FROM appointment a join appointment_doc_config adc ON a."id" = adc."appointment_id" join doctor d ON a."doctorId" = d."doctorId" join account_details ac ON d."account_key" = ac."account_key" WHERE a."patient_id" = $1 AND a."doctorId" = $4 AND a."appointment_date" >= $2 AND a."is_cancel"=false AND (a.status= $5 OR a.status=$6) order by appointment_date limit 10 offset $3',
    getAppDoctorList:'SELECT a."id" as "appointmentId", a."appointment_date" as "appointmentDate",a."startTime", a."endTime", a."doctorId", a."patient_id" as "patientId", adc."is_preconsultation_allowed",adc."pre_consultation_hours",adc."pre_consultation_mins", d."first_name" as "doctorFirstName",d."last_name" as "doctorLastName", ac."hospital_name" as "hospitalName"  FROM appointment a join appointment_doc_config adc ON a."id" = adc."appointment_id" join doctor d ON a."doctorId" = d."doctorId" join account_details ac ON d."account_key" = ac."account_key"  WHERE a."doctorId" = $1 AND a."patient_id" = $2 AND a.appointment_date >= $3 AND a."is_cancel"=false AND (a.status= $4 OR a.status = $5) order by appointment_date',
    getPastAppointmentsForPatient: 'SELECT a."id" as "appointmentId", a."appointment_date" as "appointmentDate",a."startTime",a."endTime",a."patient_id" as "patientId", a."doctorId", d."first_name" as "doctorFirstName",d."last_name" as "doctorLastName", ac."hospital_name" as "hospitalName" FROM appointment a join  doctor d ON a."doctorId" = d."doctorId" join account_details ac ON d."account_key" = ac."account_key" WHERE a."patient_id" = $1 AND a."doctorId" = $4 AND a."appointment_date" <= $2 AND a."is_cancel"=false AND a.status= $5 order by a.appointment_date limit 10 offset $3',
    getPastAppDoctorList:'SELECT a."id" as "appointmentId", a."appointment_date" as "appointmentDate", a."startTime",a."endTime",a."patient_id" as "patientId", a."doctorId",d."first_name" as "doctorFirstName",d."last_name" as "doctorLastName", ac."hospital_name" as "hospitalName"  FROM appointment a join  doctor d ON a."doctorId" = d."doctorId" join account_details ac ON d."account_key" = ac."account_key" WHERE a."doctorId" = $1 AND a."patient_id" = $2 AND a.appointment_date <= $3 AND a.status= $4 order by a.appointment_date',
    getPatientDoctorApps:'SELECT * from appointment a join patient_details pd ON a."patient_id" = pd."patient_id" WHERE a."doctorId" = $1 AND a."appointment_date" >= current_date AND a."is_cancel"=false AND (pd.name ~* $2 OR pd.email ~* $2 OR pd.phone ~* $2)',
    getAccountAppList:'SELECT * from appointment WHERE "doctorId" = $1 order by appointment_date',
    sunday:'INSERT INTO public.doc_config_schedule_day(doctor_id, "dayOfWeek", doctor_key)VALUES ($1, $3, $2);',
    monday:'INSERT INTO public.doc_config_schedule_day(doctor_id, "dayOfWeek", doctor_key)VALUES ($1, $3, $2);',
    tuesday:'INSERT INTO public.doc_config_schedule_day(doctor_id, "dayOfWeek", doctor_key)VALUES ($1, $3, $2);',
    wednesday:'INSERT INTO public.doc_config_schedule_day(doctor_id, "dayOfWeek", doctor_key)VALUES ($1, $3, $2);',
    thursday:'INSERT INTO public.doc_config_schedule_day(doctor_id, "dayOfWeek", doctor_key)VALUES ($1, $3, $2);',
    friday:'INSERT INTO public.doc_config_schedule_day(doctor_id, "dayOfWeek", doctor_key)VALUES ($1, $3, $2);',
    saturday:'INSERT INTO public.doc_config_schedule_day(doctor_id, "dayOfWeek", doctor_key)VALUES ($1, $3, $2);',
    docConfig: 'INSERT INTO public.doc_config(doctor_key, consultation_cost) VALUES ($1, $2);',
    getDoctorKey:"SELECT replace(users.doctor_key, 'Doc_', '') AS maxDoc FROM users WHERE doctor_key notnull order by replace(users.doctor_key, 'Doc_', '')::int desc limit 1",
    getRegKey:"SELECT replace(doctor.registration_number, 'RegD_', '') AS maxReg FROM doctor WHERE doctor.registration_number notnull order by replace(doctor.registration_number, 'RegD_', '')::int desc limit 1",
    getUser:'SELECT users.id FROM users order by id desc limit 1',
    insertDoctor:'INSERT INTO public.users(id, name, email, password, salt, account_id, doctor_key)VALUES ($1, $2, $3, $4, $5, $6, $7);',
    getTodayAppointments:'SELECT * FROM appointment WHERE "patient_id" = $1 AND "appointment_date" = $2 AND ("status"= $3 OR "status"=$4)  AND "is_cancel"=false',
    getAccountKey:"SELECT replace(account.account_key, 'Acc_', '') AS maxAcc FROM account WHERE account_key notnull order by replace(account.account_key, 'Acc_', '')::int desc limit 1",
    getPrescription:'SELECT * FROM prescription WHERE "appointment_id" = $1',
    getTableData:'SELECT * FROM ',
    updateSignature:`UPDATE doctor SET "signature" = $2 WHERE "doctorId" = $1`,
    getPatientDetailLabReport:`SELECT  DISTINCT ON (appointment_id)report."appointment_id" as appointmentId , report."comments" as comment, report."file_type" as fileType, report."file_name" as fileName, report."report_url" as attachment, report."report_date" as reportDate from patient_report report  left join  appointment  on appointment."id" = report."appointment_id"  where report."patient_id" = $1 and (report."appointment_id" ! = NULL OR report."appointment_id"  IS not NULL)`,

    // Doctor report common fields 
    getDoctorReportField : `Select DISTINCT  appointment."appointment_date", appointment."patient_id" ,appointment."createdTime", 
                            patient."name" as "patientName" , patient."phone" , payment."amount" , appointment."slotTiming" ,
                            doctor."doctor_name" as "doctorName" `,
    getDoctorReportFromField : ` from doctor `,
    getDoctorReportWhereForDoctor: ` where doctor."doctor_key" = $1 `,
    getDoctorReportWhereForAdmin: ` where doctor."account_key" = $1 `,

    // Appointment list report
    getAppointmentListReportJoinField : ` left join appointment on appointment."doctorId" = doctor."doctorId" 
                                        left join patient_details patient on patient."patient_id"= appointment."patient_id" 
                                        left join payment_details payment on payment."appointment_id" = appointment."id" `,

    getAppointmentListReport: `  and appointment."appointment_date" =$2 order by appointment."appointment_date"  DESC `,
    getAppointmentListReportWithLimit: `  and appointment."appointment_date" =$4  order by appointment."appointment_date"  DESC offset $2 limit $3`,
    getAppointmentListReportWithSearch: `   AND (LOWER(name) LIKE LOWER($4) OR LOWER(doctor_name) LIKE LOWER($4) OR (phone) LIKE ($4) OR (amount) LIKE ($4) OR  CAST (appointment_date AS TEXT ) LIKE ($4) OR CAST ("createdTime" AS TEXT ) LIKE ($4)  OR  CAST ("slotTiming" AS TEXT ) LIKE ($4) OR  CAST (appointment.patient_id AS TEXT ) LIKE ($4)) and appointment."appointment_date" =$5 order by appointment."appointment_date"  DESC offset $2 limit $3`,
    getAppointmentListReportWithoutLimitSearch: `   AND (LOWER(name) LIKE LOWER($2) OR LOWER(doctor_name) LIKE LOWER($2) OR (phone) LIKE ($2) OR (amount) LIKE ($2) OR  CAST (appointment_date AS TEXT ) LIKE ($2) OR CAST ("createdTime" AS TEXT ) LIKE ($2)  OR  CAST ("slotTiming" AS TEXT ) LIKE ($2) OR  CAST (appointment.patient_id AS TEXT ) LIKE ($2))  and appointment."appointment_date" = $3 order by appointment."appointment_date"  DESC`,
    getAppointmentListReportWithFilterSearch: '  and appointment."appointment_date" BETWEEN $5 and $6  AND (LOWER(name) LIKE LOWER($4) OR LOWER(doctor_name) LIKE LOWER($4) OR (phone) LIKE ($4) OR (amount) LIKE ($4) OR  CAST (appointment_date AS TEXT ) LIKE ($4) OR CAST ("createdTime" AS TEXT ) LIKE ($4)  OR  CAST ("slotTiming" AS TEXT ) LIKE ($4) OR  CAST (appointment.patient_id AS TEXT ) LIKE ($4))  order by appointment."appointment_date"  DESC offset $2 limit $3',
    getAppointmentListReportWithoutLimitFilterSearch: '  and appointment."appointment_date" BETWEEN $3 and $4  AND (LOWER(name) LIKE LOWER($2) OR LOWER(doctor_name) LIKE LOWER($2) OR (phone) LIKE ($2) OR (amount) LIKE ($2) OR  CAST (appointment_date AS TEXT ) LIKE ($2) OR CAST ("createdTime" AS TEXT ) LIKE ($2)  OR  CAST ("slotTiming" AS TEXT ) LIKE ($2) OR  CAST (appointment.patient_id AS TEXT ) LIKE ($2)) order by appointment."appointment_date"  DESC',
    getAppointmentListReportWithFilter:'  and appointment."appointment_date" BETWEEN $4 and $5  order by appointment."appointment_date"  DESC offset $2 limit $3',
    getAppointmentListReportWithoutLimitFilter: '  and appointment."appointment_date" BETWEEN $2 and $3  order by appointment."appointment_date"  DESC',

    getReportVideoUsage: 'select app."doctorId", report.* FROM public.patient_report report left outer join public.appointment app on app.id = report.appointment_id left join public.doctor doc on doc."doctorId" = app."doctorId" where report.patient_id = $2 and (report.appointment_id = $3 or doc."doctorId" = $1 or report.appointment_id is null) Order by id DESC offset $4 limit $5',
    // Amount list report
    getAmountListReportJoinField: ` left join appointment on appointment."created_by" = 'PATIENT'
                                    left join patient_details patient on patient."patient_id"= appointment."patient_id" 
                                    left join payment_details payment on payment."appointment_id" = appointment."id" `,
    getAmountListReport: ` and appointment."appointment_date" =$2  order by appointment."appointment_date" DESC `,
    getAmountListReportWithLimit: `  and appointment."appointment_date" =$4 order by appointment."appointment_date" DESC offset $2 limit $3`,
    getAmountListReportWithSearch: `  where doctor."doctor_key" =  $1   AND  (LOWER(name) LIKE LOWER($4) OR LOWER(doctor_name) LIKE LOWER($4) OR (phone) LIKE ($4) OR (amount) LIKE ($4) OR  CAST (appointment_date AS TEXT ) LIKE ($4) OR CAST ("createdTime" AS TEXT ) LIKE ($4)  OR  CAST ("slotTiming" AS TEXT ) LIKE ($4) OR  CAST (appointment.patient_id AS TEXT ) LIKE ($4))  and appointment."appointment_date" =$5 order by appointment."appointment_date" DESC offset $2 limit $3`,
    getAmountListReportWithoutLimitSearch:`    AND  (LOWER(name) LIKE LOWER($2) OR LOWER(doctor_name) LIKE LOWER($2) OR (phone) LIKE ($2) OR (amount) LIKE ($2) OR  CAST (appointment_date AS TEXT ) LIKE ($2) OR CAST ("createdTime" AS TEXT ) LIKE ($2)  OR  CAST ("slotTiming" AS TEXT ) LIKE ($2) OR  CAST (appointment.patient_id AS TEXT ) LIKE ($2))  and appointment."appointment_date" = $3 order by appointment."appointment_date" DESC`,
    getAmountListReportWithFilterSearch:`  where doctor."doctor_key" =  $1  and appointment."appointment_date" BETWEEN $5 and $6 AND  (LOWER(name) LIKE LOWER($4) OR LOWER(doctor_name) LIKE LOWER($4) OR (phone) LIKE ($4) OR (amount) LIKE ($4) OR  CAST (appointment_date AS TEXT ) LIKE ($4) OR CAST ("createdTime" AS TEXT ) LIKE ($4)  OR  CAST ("slotTiming" AS TEXT ) LIKE ($4) OR  CAST (appointment.patient_id AS TEXT ) LIKE ($4))  order by appointment."appointment_date" DESC offset $2 limit $3`,
    getAmountListReportWithoutLimitFilterSearch:`   and appointment."appointment_date" BETWEEN $3 and $4 AND (LOWER(name) LIKE LOWER($2) OR LOWER(doctor_name) LIKE LOWER($2) OR (phone) LIKE ($2) OR (amount) LIKE ($2) OR  CAST (appointment_date AS TEXT ) LIKE ($2) OR CAST ("createdTime" AS TEXT ) LIKE ($2)  OR  CAST ("slotTiming" AS TEXT ) LIKE ($2) OR  CAST (appointment.patient_id AS TEXT ) LIKE ($2)) order by appointment."appointment_date" DESC`,
    getAmountListReportWithFilter:`  and appointment."appointment_date" BETWEEN $4 and $5  order by appointment."appointment_date" DESC offset $2 limit $3`,
    getAmountListReportWithoutLimitFilter:`  and appointment."appointment_date" BETWEEN $2 and $3 order by appointment."appointment_date" DESC`,

    getMessageTemplate: 'SELECT template.* FROM message_metadata meta JOIN message_template template ON template.id = meta.message_template_id JOIN message_type type ON type.id = meta.message_type_id JOIN communication_type com ON com.id = meta.communication_type_id WHERE type.name = $1 AND com.name = $2',
    getAdvertisementList:`SELECT * FROM advertisement`,

    // get prescription
    getPrescriptionDetails: `select med.name_of_medicine as medicine , med.dose_of_medicine as comment , med.count_of_days as dose, pres.prescription_url as attachment
                            from medicine med 
                            left join prescription pres on med.prescription_id = pres.id 
                        where pres.appointment_id = $1;`
}