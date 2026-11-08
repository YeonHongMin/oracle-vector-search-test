-- Access privilege for the GPU embedding server (host and port are example values)
BEGIN
  DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
    host => '<dgx spark>:11444',
    ace  => xs$ace_type(
              privilege_list => xs$name_list('connect'),
              principal_name => 'SOE',
              principal_type => xs_acl.ptype_db
            ));
END;
/
