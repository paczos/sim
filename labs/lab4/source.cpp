#include <iostream>
#include <stdlib.h>
#include <sql.h>
#include <sqlext.h>
#include <string.h>
#include "imebra/imebra.h"

#define CHECK_ERROR(code, str, h, env) if (code!=SQL_SUCCESS) {extract_error(str, h, env); return 0;}
#define PERSONID_LEN 4
#define LASTNAME_LEN 256
#define FIRSTNAME_LEN 256
#define ADDRESS_LEN 256
#define CITY_LEN 256

using namespace std;

void extract_error(
      string fn,
      SQLHANDLE handle,
      SQLSMALLINT type)
  {
    SQLINTEGER i = 0;
    SQLINTEGER native;
    SQLCHAR state[ 7 ];
    SQLCHAR text[256];
    SQLSMALLINT len;
    SQLRETURN ret;
    printf("\nThe driver reported the following diagnostics whilst running %s\n\n", fn.c_str());

    do
    {
      ret = SQLGetDiagRec(type, handle, ++i, state, &native, text, sizeof(text), &len );
      printf("\nSQLGetDiagRec returned %d\n\r", ret);
      if (SQL_SUCCEEDED(ret))
      printf("%s:%d:%d:%s\n", state, i, native, text);
    }
    while( ret == SQL_SUCCESS );
  }




int select () {
	
	SQLHENV henv = SQL_NULL_HENV;
	SQLHDBC hdbc = SQL_NULL_HDBC;
	SQLHSTMT hstmt = SQL_NULL_HSTMT;

	
	SQLRETURN retcode;
	SQLCHAR strFirstName[LASTNAME_LEN], strLastName[FIRSTNAME_LEN];//legacy
	SQLCHAR strAddress[ADDRESS_LEN], strCity[CITY_LEN];            //legacy
	SQLCHAR strKomentarz[40];
	SQLLEN id, rzad, miejsce, cena=0;
	SQLLEN lenFirstName=0, lenLastName=0, lenAddress=0, lenCity=0;
	SQLLEN cPersonId=0, lenPersonId=0;

	int i=0;

	retcode = SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, &henv);
	CHECK_ERROR(retcode, "SQLAllocHandle(SQL_HANDLE_ENV)", henv, SQL_HANDLE_ENV);

	retcode = SQLSetEnvAttr(henv, SQL_ATTR_ODBC_VERSION, (SQLPOINTER*)SQL_OV_ODBC3, 0);
	CHECK_ERROR(retcode, "SQLSetEnvAttr(SQL_ATTR_ODBC_VERSION)", henv, SQL_HANDLE_ENV);

	retcode = SQLAllocHandle(SQL_HANDLE_DBC, henv, &hdbc);
	CHECK_ERROR(retcode, "SQLAllocHandle(SQL_HANDLE_DBC)", hdbc, SQL_HANDLE_DBC);



	SQLSetConnectAttr(hdbc, SQL_LOGIN_TIMEOUT, (SQLPOINTER)5, 0);
	CHECK_ERROR(retcode, "SQLSetConnectAttr(SQL_LOGIN_TIMEOUT)", hdbc, SQL_HANDLE_DBC);

	retcode = SQLConnect(hdbc, (SQLCHAR*) "ODBC", SQL_NTS,
		(SQLCHAR*) "sim", SQL_NTS, (SQLCHAR*) "sim2019", SQL_NTS);
	CHECK_ERROR(retcode, "SQLConnect(DATASOURCE)", hdbc, SQL_HANDLE_DBC);

	retcode = SQLAllocHandle(SQL_HANDLE_STMT, hdbc, &hstmt);
	CHECK_ERROR(retcode, "SQLAllocHandle(SQL_HANDLE_STMT)", hstmt, SQL_HANDLE_STMT);

	//retcode = SQLExecDirect(hstmt,(SQLCHAR*) "USE sim", SQL_NTS);
	//CHECK_ERROR(retcode, "SQLExecDirect() USE", hstmt, SQL_HANDLE_STMT);

	retcode = SQLExecDirect(hstmt,(SQLCHAR*) "SELECT ID, cena, rzad, miejsce, komentarz FROM bilety", SQL_NTS);
	CHECK_ERROR(retcode, "SQLExecDirect() SELECT", hstmt, SQL_HANDLE_STMT);



	retcode = SQLBindCol(hstmt, 1, SQL_C_USHORT, &id,      2,   &lenPersonId);
	CHECK_ERROR(retcode, "SQLBindCol()", hstmt, SQL_HANDLE_STMT);	
	retcode = SQLBindCol(hstmt, 2, SQL_C_USHORT,   &cena,   2, &lenFirstName);
	retcode = SQLBindCol(hstmt, 3, SQL_C_USHORT,   &rzad,    2, &lenLastName);
	retcode = SQLBindCol(hstmt, 4, SQL_C_USHORT,   &miejsce,     2, &lenAddress);
	retcode = SQLBindCol(hstmt, 5, SQL_C_CHAR,   &strKomentarz, 	      40, &lenCity);

	for (i=0; i<3; i++) {
		retcode = SQLFetch(hstmt);
		
		if (retcode == SQL_SUCCESS || retcode == SQL_SUCCESS_WITH_INFO) {
			printf("Record %d: %d %d, %d, %d, %s\n", i+1, (int) id,
			(int)cena, (int)rzad, (int)miejsce, strKomentarz);
		} else {
			if (retcode != SQL_NO_DATA) {
				CHECK_ERROR(retcode, "SQLFetch()", hstmt, SQL_HANDLE_STMT);
			} else {
				break;
			}
		}
	}
		printf ("\nComplete.\n");

		if (hstmt != SQL_NULL_HSTMT)
			SQLFreeHandle(SQL_HANDLE_STMT, hstmt);

		if (hdbc != SQL_NULL_HDBC) {
			SQLDisconnect(hdbc);
			SQLFreeHandle(SQL_HANDLE_DBC, hdbc);
		}

		if (henv != SQL_NULL_HENV)
			SQLFreeHandle(SQL_HANDLE_ENV, henv);
	
	return 0;
}





int insert (string patientName) {
	
	SQLHENV henv = SQL_NULL_HENV;
	SQLHDBC hdbc = SQL_NULL_HDBC;
	SQLHSTMT hstmt = SQL_NULL_HSTMT;

	
	SQLRETURN retcode;


	retcode = SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, &henv);
	CHECK_ERROR(retcode, "SQLAllocHandle(SQL_HANDLE_ENV)", henv, SQL_HANDLE_ENV);

	retcode = SQLSetEnvAttr(henv, SQL_ATTR_ODBC_VERSION, (SQLPOINTER*)SQL_OV_ODBC3, 0);
	CHECK_ERROR(retcode, "SQLSetEnvAttr(SQL_ATTR_ODBC_VERSION)", henv, SQL_HANDLE_ENV);

	retcode = SQLAllocHandle(SQL_HANDLE_DBC, henv, &hdbc);
	CHECK_ERROR(retcode, "SQLAllocHandle(SQL_HANDLE_DBC)", hdbc, SQL_HANDLE_DBC);



	SQLSetConnectAttr(hdbc, SQL_LOGIN_TIMEOUT, (SQLPOINTER)5, 0);
	CHECK_ERROR(retcode, "SQLSetConnectAttr(SQL_LOGIN_TIMEOUT)", hdbc, SQL_HANDLE_DBC);

	retcode = SQLConnect(hdbc, (SQLCHAR*) "ODBC", SQL_NTS,
		(SQLCHAR*) "sim", SQL_NTS, (SQLCHAR*) "sim2019", SQL_NTS);
	CHECK_ERROR(retcode, "SQLConnect(DATASOURCE)", hdbc, SQL_HANDLE_DBC);

	retcode = SQLAllocHandle(SQL_HANDLE_STMT, hdbc, &hstmt);
	CHECK_ERROR(retcode, "SQLAllocHandle(SQL_HANDLE_STMT)", hstmt, SQL_HANDLE_STMT);
	string query = "INSERT INTO bilety (cena, rzad, miejsce, komentarz) VALUES ( 88, 666, 997, '"+patientName+"')";
	retcode = SQLExecDirect(hstmt, (SQLCHAR*) query.c_str(), SQL_NTS);
	CHECK_ERROR(retcode, "SQLExecDirect() INSERT", hstmt, SQL_HANDLE_STMT);

		printf ("\nComplete.\n");

		if (hstmt != SQL_NULL_HSTMT)
			SQLFreeHandle(SQL_HANDLE_STMT, hstmt);

		if (hdbc != SQL_NULL_HDBC) {
			SQLDisconnect(hdbc);
			SQLFreeHandle(SQL_HANDLE_DBC, hdbc);
		}

		if (henv != SQL_NULL_HENV)
			SQLFreeHandle(SQL_HANDLE_ENV, henv);
	
	return 0;
}




int main()
{

unique_ptr<imebra::DataSet> loadedDataSet(imebra::CodecFactory::load("IM1"));
wstring patientNameCharacter = loadedDataSet->getUnicodeString(imebra::TagId(imebra::tagId_t::PatientName_0010_0010), 0);

string str(begin( patientNameCharacter), end(patientNameCharacter) );

cout<<str<<endl;
select();
insert(str);
select();

  return 0;
}
