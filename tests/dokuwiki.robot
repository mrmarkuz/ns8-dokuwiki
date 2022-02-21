*** Settings ***
Library    SSHLibrary

*** Test Cases ***
Check if dokuwiki is installed correctly
    ${output}  ${rc} =    Execute Command    add-module ${IMAGE_URL} 1
    ...    return_rc=True
    Should Be Equal As Integers    ${rc}  0
    &{output} =    Evaluate    ${output}
    Set Suite Variable    ${module_id}    ${output.module_id}

Check if dokuwiki can be configured
    ${rc} =    Execute Command    api-cli run module/${module_id}/configure-module --data '{"wiki_name": "mywiki","username":"admin","password":"admin","email":"admin@test.local","user_full_name":"Admin","host":"dokuwiki.test.local","http2https": true,"lets_encrypt": false}'
    ...    return_rc=True  return_stdout=False
    Should Be Equal As Integers    ${rc}  0

Setup local name resolution
    ${rc} =    Execute Command    echo 127.0.0.1 dokuwiki.test.local >> /etc/hosts
    ...    return_rc=True  return_stdout=False
    Should Be Equal As Integers    ${rc}  0

Check if dokuwiki works as expected
    ${output}  ${rc} =    Execute Command    sleep 30 && curl -fkL http://dokuwiki.test.local/
    ...    return_rc=True  return_stdout=True
    Should Be Equal As Integers    ${rc}  0

Check if dokuwiki is removed correctly
    ${rc} =    Execute Command    remove-module --no-preserve ${module_id}
    ...    return_rc=True  return_stdout=False
    Should Be Equal As Integers    ${rc}  0
