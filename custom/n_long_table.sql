@utlspon n_long_tab

DROP TABLE TEMP_LONG_TAB;

CREATE TABLE TEMP_LONG_TAB
(
  MEDIA_ID NUMBER,
  CLDATA  CLOB
);

DELETE FROM TEMP_LONG_TAB;

COMMIT;

INSERT INTO temp_long_tab
   (SELECT media_id, TO_LOB (nb.long_text)
      FROM APPLSYS.FND_DOCUMENTS_LONG_TEXT nb);

COMMIT;

@utlspoff