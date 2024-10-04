*** Settings ***
Library     Collections
Library     RPA.JSON
Library     RPA.Database
Library     RPA.HTTP

*** Variables ***
${API_URL}      http://103.106.72.182:8770
${BOOK_ID}      ${EMPTY}
${PASSWORD}     ${EMPTY}
${USERNAME}     root
${DB_NAME}      inlislite_v3
${DB_HOST}      localhost
${DB_PORT}      3309

*** Test Cases ***
Get JSON Data From API
    ${book_id}=    Set Variable    ${BOOK_ID}
    Create Session    mysession    ${API_URL}    verify=${False}
    ${response}=    GET On Session    mysession    /api/getBookSinopsis/6
    # Lakukan permintaan ke endpoint API
    Create Session    mysession    ${API_URL}    verify=${False}
    ${response}=    GET On Session    mysession    /api/getBookSinopsis/${book_id}
    ${json_data}=    Convert To Dictionary    ${response.content}
    Log To Console    Full JSON Response: ${json_data}

    # Pindahkan data ke variabel yang lebih spesifik
    ${JUDUL}=    Get From Dictionary    ${json_data}    judul
    ${PENGARANG}=    Get From Dictionary    ${json_data}    pengarang
    ${PENERBITAN}=    Get From Dictionary    ${json_data}    penerbitan
    ${DESC}=    Get From Dictionary    ${json_data}    deskripsi
    ${ISBN}=    Get From Dictionary    ${json_data}    isbn

    Log To Console    Judul: ${JUDUL}
    Log To Console    Pengarang: ${PENGARANG}
    Log To Console    Penerbitan: ${PENERBITAN}
    Log To Console    Deskripsi: ${DESC}
    Log To Console    ISBN: ${ISBN}

    # Simpan data ke database
    Conect To Database    pymysql    ${DB_NAME}    ${USERNAME}    ${PASSWORD}    ${DB_HOST}    ${DB_PORT}
    Insert Data To Database    ${JUDUL}    ${PENGARANG}    ${PENERBITAN}    ${DESC}    ${ISBN}
    # Select Data From Database    select title, author from catalogs;

    # Log untuk verifikasi
    # Log To Console    Judul: ${JUDUL}
    # Log To Console    Pengarang: ${PENGARANG}
    # Log To Console    Penerbitan: ${PENERBITAN}
    # Log To Console    Deskripsi: ${DESC}
    # Log To Console    ISBN: ${ISBN}
    # Log To Console    IP Address: ${ip_address}

*** Keywords ***
Convert To Dictionary
    [Arguments]    ${json_string}
    ${json_data}=    Evaluate    json.loads('''${json_string}''')    json
    RETURN    ${json_data}

Conect To Database
    [Arguments]    ${db_type}    ${db_name}    ${username}    ${password}    ${host}    ${port}
    Connect To Database    ${db_type}    ${db_name}    ${username}    ${password}    ${host}    ${port}
    Log To Console    message: Connected to database

Insert Data To Database
    [Arguments]    ${judul}    ${pengarang}    ${penerbitan}    ${desc}    ${isbn}
    ${query}=    Set Variable
    ...    insert into catalogs (ControlNumber, BIBID, Title, Author, Publikasi, PhysicalDescription, ISBN, Worksheet_ID) values ('INLIS000000000000004', '0010-0924000004', '${judul}', '${pengarang}', '${penerbitan}', '${desc}', '${isbn}', 1);
    Query    ${query}
    Log To Console    message: Data inserted to database

# Select Data From Database
#    [Arguments]    ${query}
#    ${result}=    Query    select title, author from catalogs;
#    Log To Console    message: ${result}
#    [Return]    ${result}
