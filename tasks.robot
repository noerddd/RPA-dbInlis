* Settings *
Library     Collections
Library     RPA.JSON
Library     RPA.Database
Library     RPA.HTTP

* Variables *
${API_URL}      http://103.106.72.182:8770
${BOOK_ID}      ${EMPTY}
${PASSWORD}     otobook1234
${USERNAME}     phpmyadmin
${DB_NAME}      inlislite_v3
${DB_HOST}      localhost
${DB_PORT}      3306

* Test Cases *
Get JSON Data From API
    ${book_id}=    Set Variable    ${BOOK_ID}
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
    ${KOTA}=    Get From Dictionary    ${json_data}    kota
    ${TAHUN}=    Get From Dictionary    ${json_data}    tahun
    ${EDITOR}=    Get From Dictionary    ${json_data}    editor
    ${ILUSTRATOR}=    Get From Dictionary    ${json_data}    ilustrator
    ${SINOPSIS}=    Get From Dictionary    ${json_data}    sinopsis
    ${KEYWORD}=    Get From Dictionary    ${json_data}    keyword

    # Log To Console    Judul: ${JUDUL}

    # Simpan data ke database
    Conect To Database    pymysql    ${DB_NAME}    ${USERNAME}    ${PASSWORD}    ${DB_HOST}    ${DB_PORT}
    Insert Data To Database    ${JUDUL}    ${PENGARANG}    ${PENERBITAN}    ${DESC}    ${ISBN}    ${KOTA}    ${TAHUN}    ${EDITOR}    ${ILUSTRATOR}    ${SINOPSIS}    ${KEYWORD}
    # Select Data From Database    select title, author from catalogs;

    # Log untuk verifikasi
    # Log To Console    Judul: ${JUDUL}   

* Keywords *
Convert To Dictionary
    [Arguments]    ${json_string}
    ${json_data}=    Evaluate    json.loads('''${json_string}''')    json
    RETURN    ${json_data}

Conect To Database
    [Arguments]    ${db_type}    ${db_name}    ${username}    ${password}    ${host}    ${port}
    Connect To Database    ${db_type}    ${db_name}    ${username}    ${password}    ${host}    ${port}
    Log To Console    message: Connected to database

Insert Data To Database
    [Arguments]    ${judul}    ${pengarang}    ${penerbitan}    ${desc}   ${isbn}   ${kota}   ${tahun}   ${editor}   ${ilustrator}   ${sinopsis}   ${keyword}
    ${query}=    Set Variable
    ...    insert into Otobook_db (Title, Author, Publikasi, PhysicalDescription, ISBN, Kota, tahun, Editor, Ilustrator, Sinopsis, Keyword) values ('${judul}', '${pengarang}', '${penerbitan}', '${desc}', '${isbn}', '${kota}', '${tahun}', '${editor}', '${ilustrator}', '${sinopsis}', '${keyword}');
    Query    ${query}
    Log To Console    message: Data inserted to database