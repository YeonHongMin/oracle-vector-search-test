-- GPU 임베딩 서버에 대한 접속 권한 (호스트와 포트는 예시 값)
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
