*- DICIONARIO DE DADOS

FUNCTION ATUALIZA_DBF
   PARAMETER MNOMEDBF

// Se existe, atualiza
IF FILE (MNOMEDBF + ".DBF")
   USE (MNOMEDBF+"2")
   APPEND FROM (MNOMEDBF)
            
   USE (MNOMEDBF)
   COPY TO (MNOMEDBF+"3")
   USE
            
   DELETE FILE (MNOMEDBF+".DBF")
            
   USE (MNOMEDBF+"2")
   COPY TO (MNOMEDBF)
   USE
// Se não existe, cria
ELSE
   USE (MNOMEDBF+"2")
   COPY TO (MNOMEDBF)
ENDIF
   
RETURN

FUNCTION INIDBF
   
         DELETE FILE PARM2.DBF
   
         IF !NEW_FILE ("PARM2.DBF")
            NEW_FIELD ("RS", "C", 80, 0)
            NEW_FIELD ("PASS", "C", 100, 0)
            NEW_FIELD ("QTD", "N", 4, 0)
            NEW_FILE ("PARM2.DBF")
            ATUALIZA_DBF("PARM")
         ENDIF
         
         IF !NEW_FILE ("SYSPSS2.DBF")
            NEW_FIELD ("CODUSR", "C", 24, 0)
            NEW_FIELD ("PASS", "C", 40, 0)
            NEW_FIELD ("CORCAB", "C", 10, 0)
            NEW_FIELD ("PAPPAR", "C", 10, 0)
            NEW_FIELD ("PAPPAR1", "C", 10, 0)
            NEW_FIELD ("CORMEN", "C", 10, 0)
            NEW_FIELD ("COREDT", "C", 10, 0)
            NEW_FIELD ("CORGET", "C", 10, 0)
            NEW_FIELD ("GETATV", "C", 10, 0)
            NEW_FIELD ("NOMUSR", "C", 50, 0)
            NEW_FIELD ("DATCRI", "D", 8, 0) // DATA DA CRIAÇÃO DO USUÁRIO
            NEW_FIELD ("DATSEN", "D", 8, 0) // DATA DA CRIAÇÃO OU ATUALIZAÇÃO DA SENHA
            NEW_FIELD ("PASS2", "C", 40, 0)
            NEW_FIELD ("PASS3", "C", 40, 0)
            NEW_FIELD ("PASS4", "C", 40, 0)
            NEW_FIELD ("PASS5", "C", 40, 0)
            NEW_FIELD ("PASS6", "C", 40, 0)
            NEW_FIELD ("PASS7", "C", 40, 0)
            NEW_FIELD ("COROPC", "C", 10, 0)
            NEW_FIELD ("COREDT", "C", 10, 0)
            NEW_FILE("SYSPSS2.DBF")
            ATUALIZA_DBF("SYSPSS")
         ENDIF
         
         IF !NEW_FILE ("EXPFEMAUX.DBF")
            NEW_FIELD ("N1", "C", 5, 0)
            NEW_FIELD ("N2", "C", 2, 0)
            NEW_FIELD ("N3", "C", 4, 0)
            NEW_FIELD ("N4", "C", 50, 0)
            NEW_FIELD ("N5", "C", 5, 0)
            NEW_FIELD ("N6", "N", 18, 2)
            NEW_FIELD ("N7", "C", 10)
            NEW_FILE ("EXPFEMAUX.DBF")
         ENDIF
         
         IF !NEW_FILE ("RELXXX2.DBF") // Faltas, Devolucao, Perda
            NEW_FIELD ("CODREP", "C", 03, 0)
            NEW_FIELD ("CODPRO", "C", 08, 0)
            NEW_FIELD ("QTDXXX", "N", 08, 2)
            NEW_FIELD ("DATPED", "D", 08, 0)
            NEW_FIELD ("CODREV", "C", 06, 0)
            NEW_FILE ("RELXXX2.DBF")
            ATUALIZA_DBF("RELXXX")
         ENDIF

         IF !NEW_FILE ("PLACON2.DBF")
            NEW_FIELD ("CODCON", "C", 08, 0)
            NEW_FIELD ("DESCON", "C", 80, 0)
            NEW_FILE  ("PLACON2.DBF")
            ATUALIZA_DBF ("PLACON")
         ENDIF

         IF !NEW_FILE ("LANCON2.DBF")
            NEW_FIELD ("CODCON", "C", 08, 0)
            NEW_FIELD ("CODREP", "C", 03, 0)
            NEW_FIELD ("VALCON", "C", 30, 0)
            NEW_FIELD ("DATCON", "D", 08, 0) // DATA DE COMPETENCIA DO EXERCICIO
            NEW_FILE  ("LANCON2.DBF")
            ATUALIZA_DBF ("LANCON")
         ENDIF

         IF !NEW_FILE ("MOVFIN2.DBF")
            NEW_FIELD ("CODREV", "C", 06, 0)
            NEW_FIELD ("DATDEB", "D", 08, 0)
            NEW_FIELD ("VALDEB", "N", 18, 2)
            NEW_FIELD ("MOVFIN", "C", 01, 0)
            NEW_FILE  ("MOVFIN2.DBF")
            ATUALIZA_DBF ("MOVFIN")
         ENDIF

         IF !NEW_FILE ("CADSUP2.DBF")
            NEW_FIELD ("CODSUP", "C", 06, 0)
            NEW_FIELD ("NOMSUP", "C", 60, 0)
            NEW_FIELD ("ENDCLI", "C", 60, 0)
            NEW_FIELD ("BAICLI", "C", 60, 0)
            NEW_FIELD ("CIDCLI", "C", 60, 0)
            NEW_FIELD ("CEPCLI", "C", 09, 0)
            NEW_FIELD ("RG_CLI", "C", 20, 0)
            NEW_FIELD ("CPFCLI", "C", 15, 0)
            NEW_FIELD ("TELCLI", "C", 60, 0)
            NEW_FIELD ("DATNAS", "D", 08, 0)
            NEW_FIELD ("TELCLI", "C", 80, 0)
            NEW_FIELD ("EMAIL", "C", 80, 0)
            NEW_FILE ("CADSUP2.DBF")
            ATUALIZA_DBF("CADSUP")
         ENDIF
         
         IF !NEW_FILE ("CADMOT2.DBF")
            NEW_FIELD ("CODMOT", "C", 06, 0)
            NEW_FIELD ("NOMMOT", "C", 50, 0)
            NEW_FIELD ("ENDCLI", "C", 50, 0)
            NEW_FIELD ("BAICLI", "C", 60, 0)
            NEW_FIELD ("CIDCLI", "C", 60, 0)
            NEW_FIELD ("CEPCLI", "C", 09, 0)
            NEW_FIELD ("RG_CLI", "C", 30, 0)
            NEW_FIELD ("CPFCLI", "C", 30, 0)
            NEW_FIELD ("TELCLI", "C", 80, 0)
            NEW_FIELD ("DATNAS", "D", 10, 0)
            NEW_FIELD ("TELCLI", "C", 80, 0)
            NEW_FIELD ("EMAIL",  "C", 60, 0)
            NEW_FILE  ("CADMOT2.DBF")
            ATUALIZA_DBF ("CADMOT")
         ENDIF

         IF !NEW_FILE ("CADCON2.DBF")
            NEW_FIELD ("CODCON", "C", 08, 0)
            NEW_FIELD ("DESCON", "C", 50, 0)
            NEW_FILE  ("CADCON2.DBF")
            ATUALIZA_DBF ("CADCON")
         ENDIF

         IF !NEW_FILE ("CADPRO2.DBF")
            NEW_FIELD ("CODPRO", "C",  09, 0)
            NEW_FIELD ("DESPRO", "C",  30, 0)
            NEW_FIELD ("TIPPRO", "C",  01, 0)
            NEW_FIELD ("PREREV", "N",  18, 2)
            NEW_FIELD ("CODREA", "C",  01, 0)
            NEW_FIELD ("QTDEST", "N",  08, 2)
            NEW_FIELD ("VALIDO", "C",  01, 0)
            NEW_FIELD ("BARCODE", "C", 30, 0)
            NEW_FIELD ("VALIDO2", "C", 01, 0)
            NEW_FIELD ("DESCRIC", "C", 80, 0)
            NEW_FIELD ("TAMANHO", "C", 04, 0)
            NEW_FILE ("CADPRO2.DBF")
            ATUALIZA_DBF("CADPRO")
         ENDIF         
         

         IF !NEW_FILE ("CADFOR2.DBF")
            NEW_FIELD ("CODFOR", "C", 02, 0)
            NEW_FIELD ("NOMFOR", "C", 15, 0)
            NEW_FIELD ("DESNOV", "N", 05, 2)
            NEW_FIELD ("DESNOR", "N", 05, 2)
            NEW_FIELD ("DESDEV", "N", 05, 2)
            NEW_FIELD ("DESDER", "N", 05, 2)
            NEW_FIELD ("ENDFOR", "C", 60, 0)
            NEW_FIELD ("BAIFOR", "C", 60, 0)
            NEW_FIELD ("CIDFOR", "C", 60, 0)
            NEW_FIELD ("CEPFOR", "C", 09, 0)
            NEW_FIELD ("EMAIL", "C", 60, 0)
            NEW_FIELD ("TELFOR", "C", 60, 0)
            NEW_FIELD ("CNPJ", "C", 18, 0)
            NEW_FIELD ("IE", "C", 25, 0)
            NEW_FIELD ("CODDIST", "C", 20, 0)
            NEW_FIELD ("TELFAX", "C", 20, 0)
            NEW_FIELD ("CONTATO", "C", 60, 0)
            NEW_FIELD ("ESTFOR", "C", 02, 0)
            NEW_FILE ("CADFOR2.DBF")
            ATUALIZA_DBF("CADFOR")
         ENDIF
       
         IF !NEW_FILE ("CADPED2.DBF")
            NEW_FIELD ("CODREV", "C", 08, 0)
            NEW_FIELD ("DATPED", "D", 08, 0)
            NEW_FIELD ("NROSEQ", "C", 03, 0)
            NEW_FIELD ("CODPRO", "C", 09, 0)
            NEW_FIELD ("QTDUNI", "N", 06, 0)
            NEW_FIELD ("PREVEN", "N", 18, 2)
            NEW_FIELD ("CODMOT", "C", 06, 0)
            NEW_FIELD ("CODSUP", "C", 06, 0)
            NEW_FIELD ("CODREP", "C", 06, 0)
            NEW_FIELD ("QTDFAL", "N", 06, 0)
            NEW_FIELD ("QTDDEV", "N", 06, 0)
            NEW_FIELD ("QTDPER", "N", 06, 0)
            NEW_FIELD ("QTDDES", "N", 06, 0)
            NEW_FIELD ("PREDES", "N", 18, 2)
            NEW_FIELD ("NOMUSR", "C", 50, 0)
            NEW_FIELD ("SUSPENSO", "C", 01, 0)
            NEW_FIELD ("DTSACOLA", "D", 08, 0)
            NEW_FIELD ("DTENTREGA", "D", 08, 0)
            NEW_FIELD ("DESPRO", "C", 30, 0)
            NEW_FILE  ("CADPED2.DBF")
            ATUALIZA_DBF("CADPED")
         ENDIF
         
         IF !NEW_FILE ("CADCLI2.DBF") // CADASTRO DE CLIENTES       
            NEW_FIELD ("CARCLI", "C", 10, 0)
            NEW_FIELD ("CEPCLI", "C", 09, 0)
            NEW_FIELD ("CGCCLI", "C", 18, 0)
            NEW_FIELD ("CIDCLI", "C", 40, 0)
            NEW_FIELD ("CODATI", "C", 03, 0)
            NEW_FIELD ("CODCLI", "C", 08, 0)
            NEW_FIELD ("CONCLI", "C", 50, 0)
            NEW_FIELD ("ENDCLI", "C", 50, 0)
            NEW_FIELD ("ESTCLI", "C", 02, 0)
            NEW_FIELD ("FAXCLI", "C", 15, 0)
            NEW_FIELD ("CODSET", "C", 03, 0)
            NEW_FIELD ("NOMCLI", "C", 50, 0)
            NEW_FIELD ("OBS001", "C", 70, 0)
            NEW_FIELD ("OBS002", "C", 70, 0)
            NEW_FIELD ("OBS003", "C", 70, 0)
            NEW_FIELD ("OBS004", "C", 70, 0)
            NEW_FIELD ("OBS005", "C", 70, 0)            
            NEW_FIELD ("PAISCL", "C", 12, 0)
            NEW_FIELD ("TELCLI", "C", 60, 0)
            NEW_FIELD ("TLXCLI", "C", 15, 0)
            NEW_FIELD ("CODRES", "C", 10, 0)
            NEW_FIELD ("DATRES", "C", 10, 0)
            NEW_FIELD ("NRORES", "C", 10, 0)
            NEW_FIELD ("ULTDAT", "D", 08, 0)
            NEW_FIELD ("VALRES", "N", 18, 2)
            NEW_FIELD ("PONTOREF", "C", 100, 0)
            NEW_FIELD ("CODREP", "C", 06, 0)
            NEW_FIELD ("CODSUP", "C", 06, 0)
            NEW_FIELD ("CODMOT", "C", 06, 0)
            NEW_FIELD ("DATCAD", "D", 08, 0)
            new_field ("EMAIL", "C", 80, 0)
            NEW_FIELD ("DATNAS", "D", 08, 0)
            NEW_FILE ("CADCLI2.DBF")
            ATUALIZA_DBF("CADCLI")
         ENDIF
         
         IF !NEW_FILE ("SYSUSR2.DBF") // Tabela de acesso por usuário e opção
            NEW_FIELD ("CODMEN", "C", 05, 0)
            NEW_FIELD ("CODUSR", "C", 24, 0)
            NEW_FIELD ("CODACE", "C", 09, 0)
            NEW_FILE ("SYSUSR2.DBF")
            ATUALIZA_DBF("SYSUSR")
         ENDIF         
         
         IF !NEW_FILE ("TAB830002.DBF") // Tabela auxiliar para relatório
            NEW_FIELD ("CODPRO", "C", 09, 0)
            NEW_FIELD ("QTDPRO", "N", 10, 0)
            NEW_FILE ("TAB830002.DBF")
            ATUALIZA_DBF("TAB83000")
         ENDIF         
         
RETURN ("")

FUNCTION INDEXTAG
   PARAMETER _area, _indexorder

   _indextag := ""

   if     _area == 1
      _indextag = "CADCLI"
   elseif _area == 2
      _indextag = "CADFOR"
   elseif _area == 3
      _indextag = "CADSUP"
   elseif _area == 4
      _indextag = "CADPRO"
   elseif _area == 5
      _indextag = "CADPED"
   elseif _area == 6
      _indextag = "CADCON"
   elseif _area == 7
      _indextag = "MOVFIN"
   elseif _area == 13
      _indextag = "PLACON"
   elseif _area = 14
      _indextag = "LANCON"
   elseif _area = 15
      _indextag = "CADREP"
   elseif _area = 16
      _indextag = "CADMOT"
   elseif _area = 17
      _indextag = "CADFAL"
   elseif _area = 18
      _indextag = "RELXXX"
   elseif _area = 25
      _indextag = "ETICLI"
   elseif _area = 26
      _indextag = "EXPFEM"
   elseif _area = 27
      _indextag = "NATU"
   elseif _area = 28
      _indextag = "LUZON"
   elseif _area = 29
      _indextag = "MATUSA"
   elseif _area = 30
      _indextag = "TABPRO"
   elseif _area = 31
      _indextag = "PARM"
   elseif _area = 32
      _indextag = "JOIA"
   elseif _area = 33
      _indextag = "PERFIL"
   elseif _area = 34
      _indextag = "VITORIA"
   elseif _area = 35
      _indextag = "MIRO"
   elseif _area = 36
      _indextag = "DUO"
   elseif _area = 37
      _indextag = "TAB83000"
   elseif _area = 248
      _indextag = "SYSUSR"
   elseif _area = 249
      _indextag = "SYSOPC"
   elseif _area = 250
      _indextag = "SYSMEN"
      
   endif 
   
return _indextag + ZERO(STR(_indexorder),2)


FUNCTION ININTX
         PARAMETER _NOMDBF

         _NOMDBF = UPPER (_NOMDBF)

         IF TYPE ("_NOMDBF") != "C"
            _NOMDBF = "ALL"
         ENDIF
         
         _MAXIMOINDICES := 27

         IF _NOMDBF == "CADFAL" .OR. _NOMDBF == "ALL"
            NET_USE ("CADFAL.DBF", .T.)
            PACK
            NEW_NTX ("CADFAL01", "CODREV+DTOS(DATPED)+CODPRO", 01, _MAXIMOINDICES)
            SET INDEX TO
            USE
         ENDIF
         
         
         IF _NOMDBF == "MOVFIN" .OR. _NOMDBF == "ALL"
            NET_USE ("MOVFIN.DBF", .T.)
            PACK
            NEW_NTX ("MOVFIN01", "CODREV+DTOS(DATDEB)+DEBCRE", 01, _MAXIMOINDICES)
            NEW_NTX ("MOVFIN02", "LEFT(CODREV, 3)", 02, _MAXIMOINDICES)
            new_ntx ("MOVFIN03", "CODREP+CODREV+DTOS(DATDEB)+DEBCRE", 02, _MAXIMOINDICES)
            new_ntx ("MOVFIN04", "CODSUP+CODREV+DTOS(DATDEB)+DEBCRE", 02, _MAXIMOINDICES)
            NEW_NTX ("MOVFIN05", "CODMOT+CODREV+DTOS(DATDEB)+DEBCRE", 02, _MAXIMOINDICES)
            SET INDEX TO
            USE
         ENDIF

         IF _NOMDBF == "CADCLI" .OR. _NOMDBF == "ALL"
            NET_USE ("CADCLI.DBF", .T.)
            PACK
            NEW_NTX ("CADCLI01", "CODCLI", 03, _MAXIMOINDICES)
            NEW_NTX ("CADCLI02", "NOMCLI", 04, _MAXIMOINDICES)
            NEW_NTX ("CADCLI03", "ENDCLI", 05, _MAXIMOINDICES)
            NEW_NTX ("CADCLI04", "CGCCLI+NOMCLI", 06, _MAXIMOINDICES)
            NEW_NTX ("CADCLI05", "CIDCLI+NOMCLI", 07, _MAXIMOINDICES)
            NEW_NTX ("CADCLI06", "CONCLI+NOMCLI", 08, _MAXIMOINDICES)
            SET INDEX TO
            USE
         ENDIF

         IF _NOMDBF == "CADCON" .OR. _NOMDBF == "ALL"
            NET_USE ("CADCON.DBF", .T.)
            PACK
            NEW_NTX ("CADCON01", "CODCON", 07, _MAXIMOINDICES)
            NEW_NTX ("CADCON02", "DESCON", 08, _MAXIMOINDICES)
            SET INDEX TO
            USE
         ENDIF

         IF _NOMDBF == "CADSUP" .OR. _NOMDBF == "ALL"
            NET_USE ("CADSUP.DBF", .T.)
            PACK
            NEW_NTX ("CADSUP01", "CODSUP", 09, _MAXIMOINDICES)
            NEW_NTX ("CADSUP02", "NOMSUP", 09, _MAXIMOINDICES)
            SET INDEX TO
            USE
         ENDIF

         IF _NOMDBF == "CADPRO" .OR. _NOMDBF == "ALL"
            NET_USE ("CADPRO.DBF", .T.)
            PACK
            NEW_NTX ("CADPRO01", "CODPRO+TAMANHO", 11, _MAXIMOINDICES)
            NEW_NTX ("CADPRO02", "DESPRO", 12, _MAXIMOINDICES)
            SET INDEX TO
            USE
         ENDIF

         IF _NOMDBF == "CADFOR" .OR. _NOMDBF == "ALL"
            NET_USE ("CADFOR.DBF", .T.)
            PACK
            NEW_NTX ("CADFOR01", "CODFOR", 13, _MAXIMOINDICES)
            SET INDEX TO
            USE
         ENDIF
       
         IF _NOMDBF == "CADPED" .OR. _NOMDBF == "ALL"
            NET_USE ("CADPED.DBF", .T.)
            PACK
            NEW_NTX ("CADPED01", "DTOS(DATPED)+CODREV+NROSEQ", 14, _MAXIMOINDICES)
            NEW_NTX ("CADPED02", "DTOS(DATPED)+CODREV+CODPRO+ALLTRIM(UPPER(TAMANHO))", 15, _MAXIMOINDICES)
            NEW_NTX ("CADPED03", "CODPRO+DTOS(DATPED)",        16, _MAXIMOINDICES)
            NEW_NTX ("CADPED04", "CODREV+DTOS(DATPED)+CODPRO", 17, _MAXIMOINDICES)
            NEW_NTX ("CADPED05", "CODREP+DTOS(DATPED)+CODREV", 18, _MAXIMOINDICES)
            SET INDEX TO
            USE
         ENDIF

         IF _NOMDBF == "PLACON" .OR. _NOMDBF == "ALL"
            NET_USE ("PLACON.DBF", .T.)
            PACK
            NEW_NTX ("PLACON01", "CODCON", 23, _MAXIMOINDICES)
            SET INDEX TO
            USE
         ENDIF

         IF _NOMDBF == "LANCON" .OR. _NOMDBF == "ALL"
            NET_USE ("LANCON.DBF", .T.)
            PACK
            NEW_NTX ("LANCON01", "CODREP + DTOS(DATCON) + CODCON", 24, _MAXIMOINDICES)
            SET INDEX TO
            USE
         ENDIF

         IF _NOMDBF == "CADREP" .OR. _NOMDBF == "ALL"
            NET_USE ("CADREP.DBF", .T.)
            PACK
            NEW_NTX ("CADREP01", "CODREP", 25, _MAXIMOINDICES)
            NEW_NTX ("CADREP02", "NOMREP", 25, _MAXIMOINDICES)
            SET INDEX TO
            USE
         ENDIF

         IF _NOMDBF == "CADMOT" .OR. _NOMDBF == "ALL"
            NET_USE ("CADMOT.DBF", .T.)
            PACK
            NEW_NTX ("CADMOT01", "CODMOT", 25, _MAXIMOINDICES)
            SET INDEX TO
            USE
         ENDIF
         
         IF _NOMDBF == "SYSPSS" .OR. _NOMDBF == "ALL"
            NET_USE ("SYSPSS.DBF", .T.)
            PACK
            NEW_NTX ("SYSPSS01", "CODUSR", 26, _MAXIMOINDICES)
            SET INDEX TO
            USE
         ENDIF
         
         IF _NOMDBF == "TAB83000" .OR. _NOMDBF == "ALL"
            NET_USE ("TAB83000.DBF", .T.)
            PACK
            NEW_NTX ("TAB8300001", "CODPRO", 27, _MAXIMOINDICES)
            SET INDEX TO
            USE
         ENDIF
         
         _SYSDIR = GETE ("SYSDIR")

         SET PATH TO &_SYSDIR.

         SELECT 250
         NET_USE ("SYSEMP", .T.)
         PACK
         NEW_NTX ("SYSEMP01", "CODEMP", 07, 11)
         USE

         SELECT 250
         NET_USE ("SYSMEN", .T.)
         PACK
         NEW_NTX ("SYSMEN01", "CODMEN", 08, 11)
         USE
         USE SYSMEN ALIAS A250

         SELECT 249
         NET_USE ("SYSOPC", .T.)
         PACK
         NEW_NTX ("SYSOPC01", "CODMEN + CODOPC", 09, 11)
         USE
         USE SYSOPC ALIAS A249

         SELECT 248
         NET_USE ("SYSUSR", .T.)
         PACK
         NEW_NTX ("SYSUSR01", "CODMEN + CODUSR", 10, 11)
         USE
         USE SYSUSR ALIAS A248

         SELECT 247
         NET_USE ("SYSHLP", .T.)
         PACK
         NEW_NTX ("SYSHLP01", "CODMEN", 11, 11)
         USE
         USE SYSHLP ALIAS A247

         ? "Pressione alguma tecla para continuar ..."
         inkey(0)

RETURN ("")

FUNCTION NETUSE
         PARAMETER _NOMDBF, _EXONOF, _QTDTEM

         MENSAGEM ("ABRINDO " + _NOMDBF)

         _nomdbf = upper(_nomdbf)

         IF _NOMDBF == "CADCLI"
            PUBLIC CADCLI := 01
            SELECT 01
            IF NET_USE ("CADCLI", _EXONOF, _QTDTEM)
               SET INDEX TO CADCLI
               RETURN .T.
            ELSE
               ERRO ("CADCLI NAO DISPONIVEL")
            ENDIF
         ENDIF

         IF _NOMDBF == "CADFOR"
            PUBLIC CADFOR := 02
            SELECT 02
            IF NET_USE ("CADFOR", _EXONOF, _QTDTEM)
               SET INDEX TO CADFOR
              RETURN .T.
            ELSE
              ERRO ("CADFOR NAO DISPONIVEL")
            ENDIF
          ENDIF

         IF _NOMDBF == "CADSUP"
            PUBLIC CADSUP := 03
            SELECT 03
            IF NET_USE ("CADSUP", _EXONOF, _QTDTEM)
              SET INDEX TO CADSUP
              RETURN .T.
            ELSE
              ERRO ("CADSUP NAO DISPONIVEL")
            ENDIF
          ENDIF
        
          IF _NOMDBF == "CADPRO"
            PUBLIC CADPRO := 04
            SELECT 04
            IF NET_USE ("CADPRO", _EXONOF, _QTDTEM)
               SET INDEX TO CADPRO
              RETURN .T.
            ELSE
              ERRO ("CADPRO NAO DISPONIVEL")
            ENDIF
          ENDIF
        
          IF _NOMDBF == "CADPED"
            PUBLIC CADPED := 05
            SELECT 05
            IF NET_USE ("CADPED", _EXONOF, _QTDTEM)
               SET INDEX TO CADPED
              RETURN .T.
            ELSE
              ERRO ("CADPED NAO DISPONIVEL")
            ENDIF
          ENDIF
        
          IF _NOMDBF == "CADCON"
            PUBLIC CADCON := 06
            SELECT 06
            IF NET_USE ("CADCON", _EXONOF, _QTDTEM)
               SET INDEX TO CADCON
              RETURN .T.
            ELSE
              ERRO ("CADCON NAO DISPONIVEL")
            ENDIF
          ENDIF

          IF _NOMDBF == "MOVFIN"
            PUBLIC MOVFIN := 07
            SELECT 07
            IF NET_USE ("MOVFIN", _EXONOF, _QTDTEM)
               SET INDEX TO MOVFIN
               RETURN .T.
            ELSE
               ERRO ("MOVFIN NAO DISPONIVEL")
            ENDIF
          ENDIF

          IF _NOMDBF == "PLACON"
            PUBLIC PLACON := 13
            SELECT 13
            IF NET_USE ("PLACON", _EXONOF, _QTDTEM)
               SET INDEX TO PLACON
               RETURN .T.
            ELSE
               ERRO ("PLACON NAO DISPONIVEL")
            ENDIF
          ENDIF

          IF _NOMDBF == "LANCON"
            PUBLIC LANCON := 14
            SELECT 14
            IF NET_USE ("LANCON", _EXONOF, _QTDTEM)
               SET INDEX TO LANCON
               RETURN .T.
            ELSE
               ERRO ("LANCON NAO DISPONIVEL")
            ENDIF
          ENDIF

          IF _NOMDBF == "CADREP"
            PUBLIC CADREP := 15
            SELECT 15
            IF NET_USE ("CADREP", _EXONOF, _QTDTEM)
               SET INDEX TO CADREP
               RETURN .T.
            ELSE
               ERRO ("CADREP NAO DISPONIVEL")
            ENDIF
          ENDIF

          IF _NOMDBF == "CADMOT"
            PUBLIC CADMOT := 16
            SELECT 16
            IF NET_USE ("CADMOT", _EXONOF, _QTDTEM)
               SET INDEX TO CADMOT
               RETURN .T.
            ELSE
               ERRO ("CADMOT NAO DISPONIVEL")
            ENDIF
          ENDIF
          
          IF _NOMDBF == "CADFAL"
            PUBLIC CADFAL := 17
            SELECT 17
            IF NET_USE ("CADFAL", _EXONOF, _QTDTEM)
               SET INDEX TO CADFAL
               RETURN .T.
            ELSE
               ERRO ("CADFAL NAO DISPONIVEL")
            ENDIF
          ENDIF

          IF _NOMDBF == "RELXXX"
            PUBLIC RELXXX := 18
            SELECT 18
            IF NET_USE ("RELXXX", _EXONOF,_QTDTEM)
               SET INDEX TO
               RETURN .T.
            ELSE
               ERRO ("RELXXX NAO DISPONIVEL")
            ENDIF
          END IF
          
          IF _NOMDBF == "ETICLI"
            PUBLIC ETICLI := 25
            SELECT 25
            IF NET_USE ("ETICLI", _EXONOF,_QTDTEM)
               SET INDEX TO
               RETURN .T.
            ELSE
               ERRO ("ETICLI NAO DISPONIVEL")
            ENDIF
          END IF          
          
          IF _NOMDBF == "EXPFEM"
            PUBLIC EXPFEM := 26
            SELECT (EXPFEM)
            IF NET_USE ("EXPFEM", _EXONOF,_QTDTEM)
               SET INDEX TO
               RETURN .T.
            ELSE
               ERRO ("EXPFEM NAO DISPONIVEL")
            ENDIF
          END IF
          
          IF _NOMDBF == "NATU"
            PUBLIC NATU := 27
            SELECT (NATU)
            IF NET_USE ("NATU", _EXONOF,_QTDTEM)
               SET INDEX TO
               RETURN .T.
            ELSE
               ERRO ("NATU NAO DISPONIVEL")
            ENDIF
          END IF          
          
          IF _NOMDBF == "LUZON"
            PUBLIC LUZON := 28
            SELECT (LUZON)
            IF NET_USE ("LUZON", _EXONOF,_QTDTEM)
               SET INDEX TO
               RETURN .T.
            ELSE
               ERRO ("LUZON NAO DISPONIVEL")
            ENDIF
          END IF
          
          IF _NOMDBF == "MATUSA"
            PUBLIC MATUSA := 29
            SELECT (MATUSA)
            IF NET_USE ("MATUSA", _EXONOF,_QTDTEM)
               SET INDEX TO
               RETURN .T.
            ELSE
               ERRO ("MATUSA NAO DISPONIVEL")
            ENDIF
          END IF
          
          IF _NOMDBF == "TABPRO"
            PUBLIC TABPRO := 30
            SELECT (TABPRO)
            IF NET_USE ("TABPRO", _EXONOF,_QTDTEM)
               SET INDEX TO
               RETURN .T.
            ELSE
               ERRO ("TABPRO NAO DISPONIVEL")
            ENDIF
          END IF
          
          IF _NOMDBF == "PARM"
            PUBLIC PARM := 31
            SELECT 31
            IF NET_USE ("PARM", _EXONOF,_QTDTEM)
               RETURN .T.
            ELSE
               ERRO ("PARM NAO DISPONIVEL")
            ENDIF
          END IF
          
          IF _NOMDBF == "JOIA"
            PUBLIC JOIA := 32
            SELECT 32
            IF NET_USE ("JOIA", _EXONOF,_QTDTEM)
               RETURN .T.
            ELSE
               ERRO ("JOIA NAO DISPONIVEL")
            ENDIF
          END IF

          IF _NOMDBF == "PERFIL"
            PUBLIC PERFIL := 33
            SELECT 33
            IF NET_USE ("PERFIL", _EXONOF,_QTDTEM)
               RETURN .T.
            ELSE
               ERRO ("PERFIL NAO DISPONIVEL")
            ENDIF
          END IF 
          
          IF _NOMDBF == "VITORIA"
            PUBLIC VITORIA := 34
            SELECT 34
            IF NET_USE ("VITORIA", _EXONOF,_QTDTEM)
               RETURN .T.
            ELSE
               ERRO ("VITORIA NAO DISPONIVEL")
            ENDIF
          END IF 
          
          IF _NOMDBF == "MIRO"
            PUBLIC MIRO := 35
            SELECT 35
            IF NET_USE ("MIRO", _EXONOF,_QTDTEM)
               RETURN .T.
            ELSE
               ERRO ("MIRO NAO DISPONIVEL")
            ENDIF
          END IF           
          IF _NOMDBF == "DUO"
            PUBLIC DUO := 36
            SELECT 36
            IF NET_USE ("DUO", _EXONOF,_QTDTEM)
               RETURN .T.
            ELSE
               ERRO ("DUO NAO DISPONIVEL")
            ENDIF
          END IF 
          
          IF _NOMDBF == "TAB83000"
            PUBLIC TAB83000 := 37
            SELECT 37
            IF NET_USE ("TAB83000", _EXONOF,_QTDTEM)
               SET INDEX TO TAB83000
               RETURN .T.
            ELSE
               ERRO ("TAB83000 NAO DISPONIVEL")
            ENDIF
          END IF
          
          RETURN .F.