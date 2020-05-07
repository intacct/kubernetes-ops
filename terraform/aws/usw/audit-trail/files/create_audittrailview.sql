CREATE VIEW audittrailview AS
SELECT
 audittrail.cny,
 audittrail.type,
 audittrail.dt,
 audittrail.recordid,
 audittrail.objecttype,
 audittrail.objectkey,
 audittrail.objectdesc,
 audittrail.userid,
 audittrail.accesstime,
 audittrail.accessmode,
 audittrail.ipaddress,
 audittrail.source,
 audittrail.workflowaction,
 audittrailfields.fieldname,
 audittrailfields.fieldtype,
 audittrailfields.oldval,
 audittrailfields.newval,
 audittrailfields.oldstrval,
 audittrailfields.newstrval,
 audittrailfields.oldintval,
 audittrailfields.newintval,
 audittrailfields.oldnumval,
 audittrailfields.newnumval,
 audittrailfields.olddateval,
 audittrailfields.newdateval
FROM audittrail LEFT JOIN audittrailfields 
ON audittrail.recordid = audittrailfields.recordid

