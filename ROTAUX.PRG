#include "vxh.ch"
//---------------------------------------- End of system code ----------------------------------------//

* Rotinas auxiliares

#INCLUDE "Inkey.ch"
#INCLUDE "fileio.ch"

#INCLUDE "hbclass.ch"
#INCLUDE "tip.ch"

#include "hbXml.ch"

**********************************************************************
Function CENTRA
**********************************************************************
Parameters AVISO,;   && MENSAGEM A SER EXIBIDA
           LINHA,;   && LINHA DO @ SAY
           COLUNAS   && NUMERO DE COLUNAS 80/132
Local VTAB
Local MsgErr

if TYPE ("COLUNAS") != "N"
   COLUNAS := 80
endif

VTAB := ROUND ((COLUNAS-LEN(AVISO))/2, 0)
@ LINHA, VTAB SAY AVISO

return (NIL)

*********************************************************************
Function ERRO
*********************************************************************
Parameters MSGERR && MENSAGEM DE ERRO
ALERT(HB_AnsiToOem(MSGERR))
Return (.F.)

*********************************************************************
Function MENSAGEM
*********************************************************************
Parameters MSG,; && MENSAGEM
           ESC   && SE DEFINIDA NAO MOSTRAR STATUS DE TECLAS
Local COR

COR = SETCOLOR()
MSG = MSG + SPACE (80)
SETCOLOR (SYS_CORMEN)
IF TYPE ("ESC") == "U"
   @ 24, 00 SAY " " + LEFT (SYS_STATUS + SPACE(56), 56)
ENDIF
SETCOLOR (SYS_CORCAB)
@ 24, 00 SAY LEFT (" " + HB_AnsiToOem(MSG) + space(80), 80)
SETCOLOR (COR)
RETURN .T.

*********************************************************************
Function CABPAD 
*********************************************************************
Parameters TITULO,;  && TITULO DO RELATORIO
           COLUNAS,; && NUMERO DE COLUNAS 80/132
           EMAIL     && RELATORIO COMO ANEXO PARA EMAIL
TITULO := UPPER (ALLTRIM (TITULO))
    
IF TYPE ("COLUNAS") = "U"
   COLUNAS := 80
ENDIF

__PAGINA := __PAGINA + 1

IF TYPE ("EMAIL") = "U"
   *UNCOMPACT()
   *@ 00, 00 SAY CHR (13)
ENDIF

@ 00, 00 SAY "Page "
@ 00, 06 SAY __PAGINA
@ 00, 20 SAY date()
@ 00, 30 SAY time()
@ 00, 40 SAY "CEU AZUL PEDIDOS"
@ 01, 00 SAY Titulo
LINE_FEED()

RETURN NIL

*********************************************************************
Function PRINT_CHAR
*********************************************************************
PARAMETERS CH && CARACTER A SER IMPRESSO NA IMPRESSORA
Local CH

@ PROW(), PCOL() SAY CH
RETURN NIL

*********************************************************************
Function START_PRINTER
*********************************************************************
Parameter RESTART
Local M_IMPNOM
Local Impressoras [Adir("*.PRN")]

Parameter mcompactar

__PAGINA := 0
__PRN_PORT = "PRN"

IF TYPE ("RESTART") == "U"
   TELPAD (__NUMMOD, "Escolha a impressora", 10, 10, 20, 69)
   ADir ("*.PRN", Impressoras)
   M_IMPNOM := AChoice (11,11,19,68,Impressoras)
   if M_IMPNOM = 0
      __PRN_COMP = "chr(15)"
      __PRN_UNCO = "chr(18)"
      __PRN_PORT = "PRN"
   else
      M_IMPNOM = Impressoras [M_IMPNOM]
   endif
   if file (M_IMPNOM)
      restore from (M_IMPNOM) additive
   endif
   __COMPACT := &__PRN_COMP
   __UNCOMPACT := &__PRN_UNCO
ENDIF

__PRN_PORT := UPPER(__PRN_PORT)
__PRN_PORT := ALLTRIM(__PRN_PORT)


TRY
   
IF __PRN_PORT == "LPT1:"
   SET PRINTER TO LPT1:
ENDIF

IF __PRN_PORT == "LPT2:"
   SET PRINTER TO LPT2:
ENDIF

IF __PRN_PORT == "LPT3:"
   SET PRINTER TO LPT3:
ENDIF

IF __PRN_PORT == "USB001"
   SET PRINTER TO USB001
ENDIF

IF __PRN_PORT == "USB002"
   SET PRINTER TO USB002
ENDIF

IF __PRN_PORT == "USB003"
   SET PRINTER TO USB003
ENDIF

IF __PRN_PORT == "USB004"
   SET PRINTER TO USB004
ENDIF

IF __PRN_PORT == "PRN"
    SET PRINTER TO PRN
ENDIF

BREAK

CATCH

END

SET DEVICE TO PRINTER
SET CONSOLE OFF
SET PRINTER ON

if type ("mcompactar") == "U"
   UNCOMPACT()
endif

RETURN NIL

*********************************************************************
Function TEMPFILENAME
*********************************************************************
Local NROARQ
Local _TEMPFILENAME
Local NOMARQ

NROARQ := 00 && NUMERO DO ARQUIVO
NOMARQ := "TMP"
    
DO WHILE .T.
   _TEMPFILENAME := NOMARQ + ZERO (ALLTRIM(STR(NROARQ)),3)
   IF !FILE (_TEMPFILENAME)
      RETURN _TEMPFILENAME
   ENDIF
   NROARQ++
ENDDO

RETURN NIL

*********************************************************************
Function STOP_PRINTER
*********************************************************************
PARAMETERS X
IF PROW() != 0 .AND. TYPE ("X") = "U"
   EJECT
ENDIF
UNCOMPACT()
SET DEVICE TO SCREEN
SET PRINT OFF
SET PRINTER TO
SET CONSOLE ON
RETURN NIL

*********************************************************************
Function LINE_FEED
*********************************************************************
 
PARAMETERS X && NUMERO DE LINHAS

Local i

IF TYPE ("X") = "U"
   X = 1
ENDIF

FOR I = 1 TO X
    @ PROW()+1, 00 SAY ""
NEXT

RETURN NIL

*********************************************************************
Function COMPACT
*********************************************************************
 
PARAMETERS MSG  && MENSAGEM A SER IMPRESSA DE FORMA COMPACTADA

IF TYPE ("MSG") != "U"
   RETURN __COMPACT + MSG + __UNCOMPACT
ELSE
   PRINT_CHAR (__COMPACT)
ENDIF

RETURN NIL

*********************************************************************
Function UNCOMPACT
*********************************************************************
 
PARAMETERS MSG  && MENSAGEM A SER IMPRESSA DE FORMA NAO COMPACTADA

IF TYPE ("MSG") != "U"
   RETURN __UNCOMPACT + MSG + __COMPACT
ELSE
   PRINT_CHAR (MSG)
ENDIF

RETURN NIL

*********************************************************************
Function SAVREG
*********************************************************************

Local mVAR1 := "__INIVAR"

COMMIT
UNLOCK
&mVAR1 := .T.

RETURN NIL

*********************************************************************
Function DELREG
*********************************************************************
TRVREG()
DELETE
SAVREG()
RETURN NIL

*********************************************************************
Function PEGVAR
*********************************************************************
PARAMETERS X,; && NOME DA VARIAVEL
           Y   && PRIMEIRA OU ULTIMA OCORRENCIA NO ARQUIVO
IF Y
   GOTO TOP
   RETURN &X.
ELSE
   GOTO BOTTOM
   RETURN &X.
ENDIF
RETURN NIL

*********************************************************************
Function CHKREC
*********************************************************************

PARAMETERS _1, _2

Local _1, _2, AREA, TEMPO

DO CASE
   CASE TYPE ("_2") = "C"
        AREA  :=_1
        TEMPO := VAL (_2)

   CASE TYPE ("_1") = "C"
        AREA  := SELECT()
        TEMPO := VAL (_1)

   CASE TYPE ("_1") = "N"
        AREA  := _1
        TEMPO := 0

   CASE TYPE ("_1") = "U"
        AREA  := SELECT()
        TEMPO := 0

ENDCASE

SELECT (AREA)
SET DELETE OFF
GOTO TOP

IF DELETED()
   IF TRVREG (TEMPO)
      RECALL
   ELSE
      RETURN .F.
   ENDIF
ELSE
   IF !NOVREG (TEMPO)
      RETURN .F.
   ENDIF
ENDIF

SET DELETE ON

RETURN .T.

*********************************************************************
Function NEW_FIELD  && USO INTERNO
*********************************************************************
 
PARAMETERS FIELD, TYPE0, LEN0, DEC0

     IF TYPE ("DEC0") = "U"
        DEC0 = 0
     ENDIF

     IF TYPE ("LEN0") = "U"
        LEN0 = 0
     ENDIF

     NOVREG()
     REPLACE FIELD_NAME WITH FIELD,;
              FIELD_TYPE WITH TYPE0,;
              FIELD_LEN  WITH LEN0,;
              FIELD_DEC  WITH DEC0
RETURN NIL

*********************************************************************
Function NEW_FILE && USO INTERNO
*********************************************************************

PARAMETERS mfilename

    IF FILE (mfilename)
       RETURN .T.
    ENDIF
    
    IF FILE ("criadbf.DBF")
       CREATE &mfilename FROM criadbf
       USE
       DELETE FILE criadbf.dbf
       ? mfilename + " criado com sucesso."
    ELSE
       CREATE criadbf
    ENDIF
RETURN .F.

*********************************************************************
Function NEW_NTX  && USO INTERNO
*********************************************************************
    PARAMETERS ARQUIVO, CHAVE, ARQCOR, ULTARQ

    IF FILE (ARQUIVO)
       DELETE FILE &ARQUIVO
    ENDIF
    ARQUIVO := LOWER(ARQUIVO)
    SETCOLOR("W/N")
    ? "Aguarde, criando indice " + ARQUIVO
    INDEX ON &CHAVE TAG &ARQUIVO
RETURN NIL


*********************************************************************
Function SHOWFIELDS && USO INTERNO, VER SHOW_FIELD
*********************************************************************

    PARAMETERS _VARMEN, _SHOWVAR, _VARDBF

    Local COLUNAS [2]
    Local RECORD
    Local CABECALHOS[2]
    Local PICTURES [2]
    Local COR

    IF TYPE ("COLUNAS") != "A"
       COLUNAS [1] := _VARDBF
       COLUNAS [2] := _SHOWVAR
    ENDIF

    IF TYPE ("CABECALHOS") != "A"
       CABECALHOS [1] := _VARDBF
       CABECALHOS [2] := _SHOWVAR
    ENDIF

    IF TYPE ("PICTURES") != "A"
       PICTURES [1] := ""
       PICTURES [2] := ""
    ENDIF
    RECORD = RECNO()
    SALTEL()
    COR = SETCOLOR()
    GO TOP
    #IFDEF _CLIPPER_
     TELPAD (__NUMMOD, ".", 06, 00, 20, 79)
     SETCOLOR (SYS_COREDT + "," + SYS_GETATV)
     DBEDIT (07, 01, 19, 78, COLUNAS, "ONLY_SEE", PICTURES, CABECALHOS) 
    #ELSE
     SETCOLOR (SYS_COREDT + "," + SYS_GETATV)
     DBEDIT (07, 00, 19, 79, COLUNAS, "ONLY_SEE", PICTURES, CABECALHOS)
    #ENDIF
    SET FILTER TO
    SET COLOR TO COR
    &_VARMEN. := &_VARDBF.
    GO RECORD
    RESTEL()
RETURN NIL

*********************************************************************
Function VIEW  && BROWSE
*********************************************************************

PARAMETERS LI,;     && LINHA INICIAL
           CI,;     && COLUNA INICIAL
           LF,;     && LINHA FINAL
           CF,;     && COLUNA FINAL
           CAMPOS,; && FIELDS
           TITULOS  && HEADING

Local M_COR, COLUNAS [10,2]
Local M_XXX
Local x, y, AUX, M_LEN, I, M_RECNO, M_LASTKEY, M_PROCNAME, M_ABC
Local ATUAL
Local HH

M_MIN := LI+3
M_MAX := LF

IF M_MAX - M_MIN < 1
   ERRO ("Erro na função view, numero de linhas insulficientes")
   FIMPRG(1)
ENDIF

M_COR := SETCOLOR()

SETCOLOR (SYS_CORMEN)
@ LI, CI CLEAR TO LF, CF
@ LI, CI TO LF, CF
@ LI+2, 00 SAY CHR (195) + REPLICATE (CHR(196), CF-CI-1) + CHR (180)

FOR X = 1 TO LEN (CAMPOS) -1
    AUX := CAMPOS[X]
    AUX := &AUX
    AUX := LEN (AUX)
    IF X == 1
       COLUNAS [01, 01] := 0
       COLUNAS [02, 01] := IF (LEN(TITULOS[1]) > AUX, LEN (TITULOS[1])+1, AUX+1)
       @ LI+1, 01 SAY HB_AnsiToOem(TITULOS [1])
       Y := COLUNAS [02, 01]
       LOOP
    ENDIF

    IF AUX > LEN (TITULOS[X])
       M_LEN := AUX+1 
    ELSE
       M_LEN := LEN (TITULOS[X]) +1
    ENDIF

    Y += M_LEN
    COLUNAS [X+1, 01] := Y

    @ LI+0, COLUNAS [X, 01] SAY CHR (194)
    @ LI+1, COLUNAS [X, 01] SAY CHR (179) + HB_AnsiToOem(TITULOS [X])
    @ LI+2, COLUNAS [X, 01] SAY CHR (197)

    FOR I = LI+3 TO LF-1
       @ I, COLUNAS [X, 01] SAY CHR (179)
    NEXT
    @ LF, COLUNAS [X, 01] SAY CHR (193)
NEXT

X := LEN(CAMPOS)
@ LI+0, COLUNAS [X, 01] SAY CHR (194)
@ LI+1, COLUNAS [X, 01] SAY CHR (179) + HB_AnsiToOem(TITULOS [X])
@ LI+2, COLUNAS [X, 01] SAY CHR (197)
FOR Y = LI+3 TO LF-1
   @ Y, COLUNAS [X, 01] SAY CHR (179)
NEXT
@ LF, COLUNAS [X, 01] SAY CHR (193)

M_RECNO := RECNO()

FOR X = 1 TO M_MAX - M_MIN
    FOR Y = 1 TO LEN(CAMPOS)
        AUX := CAMPOS[Y]
        @ X+LI+2, COLUNAS [Y, 01]+1 SAY HB_AnsiToOem(&AUX)
    NEXT
    IF EOF()
       EXIT
    ENDIF
    SKIP
NEXT

GO (M_RECNO)
@ LI+3, 00 SAY ""

DO WHILE .T.
   M_XXX := ROW()
   MENSAGEM ("Del=Apaga F2=Altera F3=Inclusão. F4=Localiza")
   @ M_XXX, 00 SAY ""
   
   SETCOLOR (SYS_COROPC)

   FOR X = 1 TO LEN(CAMPOS)
      AUX := CAMPOS[X]
      @ ROW(), COLUNAS [X, 01]+1 SAY &AUX
   NEXT

   SETCOLOR (SYS_CORMEN)   
   
   M_LASTKEY := INKEY (0)

   DO CASE
      CASE M_LASTKEY == K_UP 

            FOR X = 1 TO LEN(CAMPOS)
                AUX := CAMPOS[X]
                @ ROW(), COLUNAS [X, 01]+1 SAY &AUX
            NEXT

           IF ROW() > M_MIN
              SKIP -1
              IF BOF()
                 LOOP
              ENDIF
              @ ROW()-1, 00 SAY ""
           ELSE
              SKIP -1
           ENDIF
    
      CASE M_LASTKEY == K_DOWN
           FOR X = 1 TO LEN(CAMPOS)
                AUX := CAMPOS[X]
                @ ROW(), COLUNAS [X, 01]+1 SAY &AUX
           NEXT           
           
           IF ROW() < M_MAX-1
              SKIP
              IF EOF()
                 SKIP -1
                 LOOP
              ENDIF
              @ ROW()+1, 00 SAY ""
           ELSE
              SKIP
           ENDIF

      CASE M_LASTKEY == K_PGDN
           SKIP M_MAX - M_MIN

      CASE M_LASTKEY == K_PGUP
           SKIP (M_MAX - M_MIN) * -1

      CASE M_LASTKEY == K_ESC
           SETCOLOR (M_COR)
           RETURN NIL && EXIT

      CASE M_LASTKEY == K_F1 && HELP
           MODHLP()
            
      CASE M_LASTKEY == K_F2 && ALTERACAO
           
           M_PROCNAME := "APP_" + __NUMMOD 
           M_ABC := ROW()
           DO &M_PROCNAME WITH .F., ROW()            
           @ M_ABC, 00 SAY ""

      CASE M_LASTKEY == K_F3 && INCLUSAO
           M_PROCNAME := "APP_" + __NUMMOD 
           M_ABC      := ROW()
           DO &M_PROCNAME WITH .T., ROW()
           @ M_ABC, 00 SAY ""

      CASE M_LASTKEY == K_F4 && CONSULTA
           M_PROCNAME := "LOC_" + __NUMMOD
           DO &M_PROCNAME
         
      CASE M_LASTKEY == K_DEL .AND. TYPE ("_BROWSE_DEL_") != "U"
           M_PROCNAME := "DEL_" + __NUMMOD 
           M_XXX      := ROW()
           DO &M_PROCNAME
           @ M_XXX, 00 SAY ""
       
      OTHERWISE
           
   ENDCASE
   
   // Refresh View
   
   ATUAL := RECNO()
  
   @ M_MIN, 00 SAY ""

   FOR HH = M_MIN TO M_MAX-1
       FOR X = 1 TO LEN(CAMPOS)
           AUX := CAMPOS[X]
           @ ROW(), COLUNAS [X, 01]+1 SAY &AUX
       NEXT
       @ ROW()+1, 00 SAY ""
       SKIP    
   NEXT

   @ M_MIN, 00 SAY ""
   GO (ATUAL)
 
ENDDO

RETURN NIL

*********************************************************************
Function V_BROWSE  && USO INTERNO
*********************************************************************

PARAMETERS MODO, COLUNA

Local M_LASTKEY := LASTKEY()
Local M_LINHA   := ROW()
Local MODO
Local L_NUMMOD := "__NUMMOD"
Local M_PROCNAME

MENSAGEM ("Del=Apaga F2=Altera F3=InclusÆo.")         

IF MODO == 3 .OR. MODO == 5
   IF ASK ("Arquivo vazio, quer incluir")
      M_LASTKEY := K_F3
   ELSE
      M_LASTKEY := K_ESC
   ENDIF
ENDIF

    DO CASE
       CASE M_LASTKEY == K_ESC
       RETURN 0 && EXIT

       CASE M_LASTKEY == K_F2 && ALTERACAO
       M_PROCNAME := "APP_" + &L_NUMMOD
       DO &M_PROCNAME WITH .F., M_LINHA
       RETURN 7 && REFRESH
  
       CASE M_LASTKEY == K_F3 && INCLUSAO
       M_PROCNAME := "APP_" + &L_NUMMOD 
       DO &M_PROCNAME WITH .T., M_LINHA
       RETURN 7 && REFRESH

       CASE M_LASTKEY == K_DEL
       IF TYPE ("_BROWSE_DEL_") != "U"
          M_PROCNAME := "DEL_" + &L_NUMMOD 
          DO &M_PROCNAME
          RETURN 7 && REFRESH 
       ENDIF
    ENDCASE
RETURN 1

*********************************************************************
Function SHOW_FIELD
*********************************************************************
 
PARAMETERS AREA,;       && AREA DE PROCURA
           ORDEM,;      && NUMERO DO INDICE
           PROCURAR,;   && ARGUMENTO PARA O SEEK
           VARIAVEL,;   && O QUE SERA MOSTRADO NA TELA
           LINHA,;      && EM QUAL LINHA
           COLUNA,;     && EM QUAL COLUNA
           TAMANHOZ,;    && ZEROS A ESQUERDA. SE NAO STRING INFORMAR 0
           ERRO,;       && PARA .F. MOSTRA MENSAGEM DE ERRO, QUANDO NÇO ENCONTRAR A CHAVE
           VARDBF,;     && NOME DA VARIAVEL PARA ONDE DEVE SER COPIADO O VALOR DO "VARIAVEL" (PARAMETRO 4)
           ORD,;        && NUMERO DO INDICE PARA APRESENTACAO <NUMERICO>
           CONDICAO,;   && CONDICAO FILTRO <STRING>
           COLUNAS,;    && COLUNAS DO BROWSE <ARRAY>
           CABECALHOS,; && CABECALHOS DO BROWSE <ARRAY>
           PICTURES     && PICTURES DO BROWSE <ARRAY>

Local FILTRO
Local OLDAREA := SELECT()

IF TAMANHOZ != 0
   PROCURAR = ZERO (PROCURAR, TAMANHOZ)
ENDIF

IF TYPE ("VARDBF") != "C"
   VARDBF = ""
ENDIF

IF TYPE ("ORD") != "N"
   ORD = ORDEM
ENDIF

IF TYPE ("CONDICAO") == "C"
   IF ALLTRIM(CONDICAO) <> ".T."
      SELECT (AREA)
      SET FILTER TO &CONDICAO
      GO TOP
   ENDIF    
   FILTRO := .T.    
ELSE
   FILTRO := .F.            
ENDIF  

IF !FINDKEY (AREA, ORDEM, PROCURAR)
   IF !ERRO
      SET ORDER TO INDEXTAG(AREA, ORD)
      SHOWFIELDS (READVAR(), VARIAVEL, VARDBF)
      SET ORDER TO INDEXTAG(OLDAREA, ORDEM)
   ENDIF
   SELECT (OLDAREA)
   IF FILTRO 
      SET FILTER TO
   ENDIF
   RETURN .F.
ENDIF

SETCOLOR (SYS_COREDT)

@ LINHA, COLUNA SAY &VARIAVEL.

IF ERRO
   SHOWFIELDS (READVAR(), VARIAVEL, VARDBF)
   MENSAGEM (MSG_GET)
ENDIF

SELECT (OLDAREA)

IF FILTRO 
   SET FILTER TO
ENDIF       

RETURN .T.

*********************************************************************
Function ONLY_SEE
*********************************************************************

    PARAMETERS MODO, COLUNA
    
    Local M_LASTKEY, MODO, COLUNA

    M_LASTKEY := LASTKEY()

    IF M_LASTKEY == K_ESC .OR. MODO == 3 .OR. M_LASTKEY == K_CTRL_W
       KEYBOARD CHR (K_ENTER)
       RETURN 0 && EXIT
    ENDIF
    
RETURN 1 && CONTINUA O COMANDO NORMALMENTE

*********************************************************************
Function CPF  && USO INTERNO
*********************************************************************

PARAMETER NUMERO_DO_CPF

         Local N1, N2, N3, N4, N5, N6, N7, N8, N9, D1, D2, OK1, OK2

         n1=val(substr(numero_do_cpf,1,1))
         n2=val(substr(numero_do_cpf,2,1))
         n3=val(substr(numero_do_cpf,3,1))
         n4=val(substr(numero_do_cpf,5,1))
         n5=val(substr(numero_do_cpf,6,1))
         n6=val(substr(numero_do_cpf,7,1))
         n7=val(substr(numero_do_cpf,9,1))
         n8=val(substr(numero_do_cpf,10, 1))
         n9=val(substr(numero_do_cpf,11,1))
         d1=n9*2+n8*3+n7*4+n6*5+n5*6+n4*7+n3*8+n2*9+n1*10
         d1=11-(d1%11)
         if d1>=10
            d1=0
         endif
         d2=d1*2+n9*3+n8*4+n7*5+n6*6+n5*7+n4*8+n3*9+n2*10+n1*11
         d2=11-(d2%11)
         if d2>=10
            d2=0
         endif

         if val(substr(numero_do_cpf,13,1)) = d1
            ok1 = .t.
         else
            ok1 = .f.
         endif

         ** erro ("Digito 1 = " + str(d1))

         if val(substr(numero_do_cpf,14,1)) = d2
            ok2 = .t.
         else
            ok2 = .f.
         endif

         ** erro ("Digito 2 = " + str(d2))

RETURN (ok1) .and. (ok2)


*********************************************************************
Function FINDKEY
*********************************************************************
 
PARAMETERS _SELE,;    && AREA
           _ORDER,;   && NUMERO DO INDICE DE PROCURA
           _PROCURAR,;   && OQUE DEVE SER PROCURADO
           _RETORNO,; && OQUE DEVE SER RETORNADO
           _AREA      && MUDAR PARA A AREA "x". PARAMETRO OPCIONAL

LOCAL _OLD, R, _OLDAREA, _EXPR, X

      _OLD := SELECT()

    IF TYPE ("_RETORNO") = "C"
       IF _RETORNO = "SOFTSEEK"
          SET SOFT ON
       ENDIF
    ENDIF

    SELECT (_SELE)
    SET ORDER TO INDEXTAG(_SELE, _ORDER)
    SEEK _PROCURAR
    SET SOFT OFF
    R = FOUND()

    IF TYPE("_RETORNO") = "C"
       IF _RETORNO != "SOFTSEEK"
          R = &_RETORNO.
       ENDIF
    ENDIF

      IF TYPE ("_AREA") != "U"
         SELECT (_OLD)
      ENDIF
RETURN R

*********************************************************************
Function LOCREG
*********************************************************************
 
    PARAMETERS _AREA,; && AREA A SER PROCURADA
               _EXPR   && EXPRESSAO A SER PROCURADA

    LOCAL _OLDAREA, _AREA, _EXPR, X

    _OLDAREA = SELECT()

    IF TYPE("_EXPR") != "U"
       SELECT (_AREA)
    ENDIF

    GOTO TOP

    IF EOF()
       SELECT (_OLDAREA)
       RETURN .F.
    ENDIF

    LOCATE FOR &_EXPR.
    X = FOUND()
    SELECT (_OLDAREA)
RETURN X

*********************************************************************
Function WINDOW && INTERNO
*********************************************************************

     PARAMETERS LI, CI, LF, CF, SOMBRA
     LOCAL COR
     
     COR = SETCOLOR()

     IF LF < 20 .AND. TYPE ("SOMBRA") = "U"
        SETCOLOR (RIGHT (SYS_PAPPA1, 1) + "/" + LEFT (SYS_PAPPA1, 1))
        @ LI+1, CI+1 CLEAR TO LF+1, CF+2
        SETCOLOR (SYS_CORMEN)
        @ LI+1, CI+1 CLEAR TO LF, CF
     ENDIF

     SETCOLOR (SYS_CORMEN)
     @ LI, CI TO LF, CF
     SETCOLOR (COR)
RETURN NIL

*********************************************************************
Function SALTEL && SALVA A TELA
*********************************************************************
 
     PARAMETERS LI,; && LINHA INICIAL
                CI,; && COLUNA INICIAL
                LF,; && LINHA FINAL
                CF   && COLUNA FINAL
      
     LOCAL LI, CI, LF, CF, TELA, VARMACRO
     
     VARMACRO := "__QTDTEL"
     
     &VARMACRO := &VARMACRO + 1
     
     LI   = IF (TYPE ("LI") != "N", 00, LI)
     CI   = IF (TYPE ("CI") != "N", 00, CI)
     LF   = IF (TYPE ("LF") != "N", 24, LF)
     CF   = IF (TYPE ("CF") != "N", 79, CF)
     TELA = "__" + ALLTRIM (ZERO (STR (&VARMACRO), 2) )
     PUBLIC &TELA. 
     &TELA. = SAVESCREEN (LI, CI, LF, CF)
RETURN NIL

*********************************************************************
Function RESTEL
*********************************************************************

     PARAMETERS LI, CI, LF, CF
     
     Local VarMacro, LI, CI, LF, CF
     Local TELA
     
     VarMacro := "__QTDTEL"
     
     TELA = "__" + ALLTRIM (ZERO (STR (&VARMACRO), 2) )
     LI   = IF (TYPE ("LI") != "N", 00, LI)
     CI   = IF (TYPE ("CI") != "N", 00, CI)
     LF   = IF (TYPE ("LF") != "N", 24, LF)
     CF   = IF (TYPE ("CF") != "N", 79, CF)
     RESTSCREEN (LI, CI, LF, CF, &TELA)
     RELEASE &TELA.
     &VARMACRO := &VARMACRO - 1
RETURN NIL

*********************************************************************
Function TELPAD
*********************************************************************
 
PARAMETERS NUMMOD,;    && NUMERO DO MODULO
           CABECALHO,; && CABECALHO PARA A JANELA
           LI,;        && LINHA INICIAL
           CI,;        && COLUNA INICIAL
           LF,;        && LINHA FINAL
           CF,;        && COLUNA FINAL
           LIMPA       && SE DEFINIDO NAO LIMPA A TELA ABAIXO DA JANELA
           
Local VARMACRO

      __NUMMOD := ZERO (NUMMOD,5)

      IF TYPE ("LI") = "U"
         IF TYPE ("CABECALHO") = "U"
            LI = 02
            CI = 00
            LF = 21
            CF = 79
         ELSE
            FUNDO (02,00,SYS_LASTLINE-1,79)
            RETURN NIL
         ENDIF
      ENDIF
     IF TYPE ("LIMPA") == "U"
        FUNDO (LI, 00, SYS_LASTLINE-1, 79)
     ENDIF
     @ 00, 00 SAY HB_AnsiToOem(" Contrôle eletrônico de pedidos - Versão 05/2019")
     VARMACRO := "SYS_CORCAB"
     SETCOLOR (&VARMACRO)
     VARMACRO := "SYS_COREDT" + "," + "SYS_CORGET" + ",N/N," +  "SYS_GETATV"
     SETCOLOR (VARMACRO)
     IF TYPE ("CABECALHO") != "U"
        @ LI, CI CLEAR TO LF, CF
        @ LI, CI TO LF, CF
        IF CABECALHO != "."
           @ LI, CI+2 SAY " " + NUMMOD + " " + HB_AnsiToOem(ALLTRIM (CABECALHO)) + " "
        ENDIF
     ENDIF
RETURN NIL

*********************************************************************
Function ASK
*********************************************************************
    PARAMETERS PERG, ;  && PERGUNTA
               RESP     && OPCAO DEFAULT
               
    LOCAL OPCOES, IRESP, RETORNO
               
    IF TYPE ("RESP") == "U"
       RESP := 1
    ENDIF
    MENSAGEM ("Escolha sim ou não usando as setas do teclado.", 0)
    IF RESP == 1
       OPCOES := {"Sim", HB_AnsiToOem("Não")}
    ELSE
       OPCOES := {HB_AnsiToOem("Não"), "Sim"}
    ENDIF
    iResp := ALERT (HB_AnsiToOem(PERG) + " ?", OPCOES)
    
    IF iResp == 1
       RETORNO := .T.
    ELSE
       RETORNO := .F.
    ENDIF
    
RETURN RETORNO
    

*********************************************************************
Function FIMPRG  && FINALIZA O PROGRAMA
*********************************************************************

PARAMETERS _FIM && SE DEFINIDO, PEDE CONFIRMACAO

LOCAL VARMACRO

IF TYPE ("_FIM") = "U"
   IF !ASK ("Quer sair do sistema")
      RETURN NIL
   ENDIF
ENDIF

CLOSE ALL
SETCOLOR("W/N")
CLS
SET CURSOR ON

VARMACRO := "SYS_LASTLINE"

@ &VARMACRO, 00 SAY ""

Backup()

VARMACRO := "MULT_EMPRESAS"

IF &VARMACRO
   RUN CD ..
ENDIF
QUIT
RETURN NIL

Procedure Copiar(p1, p2)
   Local arq[1]
   
   if !FILE(p1+"\"+p2)
      if NETUSE(left(p2,len(p2)-4), .t., 05)
         ? "Copiando " + p2
         copy to (p1+"\"+p2)
         arq[1] = p2
         // Enviarparaftp(p2, p1)
         use
      endif
   endif
return

Procedure Enviarparaftp(pFileName, pPath)
   
   LOCAL cUSBStick, oFTP
   
   // ABRIR ARQUIVO DE CONFIGURAÇÃO
   
   oUrl := tURL():New("ftp://gilmar.facilitari.com:gilmar2015@ftp.facilitari.com" )
    
   IF Empty( oUrl )
      ? "Invalid url " + cUrl
      ?
      QUIT
   ENDIF

   IF oUrl:cProto != "ftp"
      ? 'This is a "DELE" test for ftp.'
      ? 'Use an ftp address with a file that you can delete.'
      ?
      QUIT
   END   

   oFtp := TIpClientFtp():new( oURL )
   oFtp:nConnTimeout := 10000000
   
   IF !oFtp:open()
      ? oFTP:lastErrorMessage()
      ? "Erro abrindo o site FTP"
   ELSE
      oFtp:mkd(pPath)
      oFtp:cwd(pPath)
      ? "Enviando " + pFileName
      oFtp:uploadFile(pFileName)
      oFtp:cwd("..")
      oFtp:close()
      ? oFTP:lastErrorMessage()
   ENDIF
return

Procedure Receberdoftp(pFileName, pPath)
   
   LOCAL cUSBStick, oFTP, aFiles
   
   // ABRIR ARQUIVO DE CONFIGURAÇÃO
   
   IF !NETUSE ("FTPC", .F., 05)
      ERRO("FTP NÃO TRANSMITIDO!")
   ELSE
      IF ALLTRIM(A027->USER) == ""
         erro ("FTP não está configurado.")
      ELSE
         cUSBStick := "ftp://" + ALLTRIM(A027->USER) + ":" + ALLTRIM(A027->PASS) + "@" + ALLTRIM(A027->SERVER)
      ENDIF
      SELECT (27)
      USE
      oFtp := TIpClientFtp():new( cUSBStick )
      IF !oFtp:open()
         MENSAGEM (oFTP:lastErrorMessage())
      ELSE            
         oFtp:cwd(pPath)
         DirMake("catalogos")
         DirMake(pPath)
         DirChange(pPath)
         aFiles := oFtp:listFiles("*.DBF")
         ? "Recebendo " + pFileName
         oFtp:downloadFile(pFileName)
         oFtp:close()
         DirChange("..\..")
      ENDIF
   ENDIF
return

Procedure Backup
   
   Local lData, lDirName
   
   lData := Date()
   lDirName := "BK" + AllTrim(Transform(Year(lData),"9999")) + Alltrim(Transform(Month(lData),"99")) + alltrim(Transform(Day(lData), "99"))
   ? lDirName
   MakeDir(lDirName)
   Copiar(lDirName,"cadcli.dbf")
   Copiar(lDirName,"cadcon.dbf")
   Copiar(lDirName,"cadfal.dbf")
   Copiar(lDirName,"cadfor.dbf")
   Copiar(lDirName,"cadmot.dbf")
   Copiar(lDirName,"cadped.dbf")
   Copiar(lDirName,"cadpro.dbf")
   Copiar(lDirName,"cadrep.dbf")
   Copiar(lDirName,"cadsup.dbf")
   Copiar(lDirName,"calc33200.dbf")
   Copiar(lDirName,"ec.dbf")
   Copiar(lDirName,"lancon.dbf")
   Copiar(lDirName,"movfin.dbf")
   Copiar(lDirName,"parm.dbf")
   Copiar(lDirName,"placon.dbf")
   Copiar(lDirName,"si_22000.dbf")
   Copiar(lDirName,"si_33200.dbf")
   Copiar(lDirName,"si_33300.dbf")
   copiar(lDirName,"si_34000.dbf")
   copiar(lDirName,"si_35000.dbf")
   copiar(lDirName,"si_36000.dbf")
   copiar(lDirName,"si_38000.dbf")
   copiar(lDirName,"sysdef.dbf")
   copiar(lDirName,"sysemp.dbf")
   copiar(lDirName,"syshlp.dbf")
   copiar(lDirName,"syslog.dbf")
   copiar(lDirName,"sysmen.dbf")
   copiar(lDirName,"sysopc.dbf")
   copiar(lDirName,"sysusr.dbf")
   copiar(lDirName,"tabcom.dbf")
   copiar(lDirName,"tabcomdt.dbf")
return

*********************************************************************
Function ESCKEY
*********************************************************************

     PARAMETERS X
     
     Local X

     IF TYPE ("X") != "U"
        X = INKEY() = 27
     ELSE
        X = IF (LASTKEY() = 27,.T.,.F.)
     ENDIF
RETURN X

*********************************************************************
Function PAUSA
*********************************************************************
 
     DO WHILE .T.
        INKEY (0)

        IF LASTKEY() = 32
           EXIT
        ENDIF

        TONE (800, 1)
     ENDDO
RETURN NIL

*********************************************************************
Function BOXMENU
*********************************************************************
   Local __OP
   Local _varaux
   Local _varaux2
   Local _QTDOPC
   Local _CODOPC, _DESOPC
   Local CI, CF 
   Local LI, LF

   OpenSysfiles()
   locate for crypt(alltrim(__NOMUSR), "7654321") == alltrim(CODUSR)
   
   IF EOF()
      ERRO ("Usuário não encontrado")
   ENDIF
   
   if !FINDKEY (249, 01, __MENU) && SYSOPC
      ERRO ("Usuário sem opções cadastradas")
   endif
   
   if !FINDKEY (250, 01, __MENU) && SYSMEN
      erro ("Usuário sem menu cadastrado")
   endif
   
   _QTDOPC := A250->QTDOPC
   FUNDO(02,00,SYS_LASTLINE-1,79)
   SELECT (250)
   LI := 1
   CI := 0
   CF := 79
   LF := 2 + _QTDOPC
   __LINHA := LI + 1
   __COLUNA := 1
   LF := LI + _QTDOPC + 4
   FUNDO(LI, CI, SYS_LASTLINE, 79)
   WINDOW(LI, CI, LF-3, CF, .T.)
   SET MESSAGE TO 24
   _varaux := 1
   SELECT(249)
   FAST_ULTIMA := 1
   setcolor(sys_cormen + "," + sys_getatv + ",," + sys_cormen)
   DO WHILE __MENU == CODMEN
       _varaux := A249->CODOPC
       _varaux := trocacaracter(_varaux, "\", "")
       _varaux := trocacaracter(_varaux, "<", "")
       @ __LINHA, __COLUNA PROMPT left(" " + _varaux+space(80), 78) MESSAGE left(" " + A249->DESOPC + space(80), 80)
       __LINHA++
       FAST_ULTIMA++
       SELECT (249)
       SKIP
   ENDDO
   
   MENU TO __OP
   
   if __OP == 0
      if __MENU == "00000"
         FIMPRG()
      else
         __MENU := "00000"
      endif
   endif
   
   return __OP

*********************************************************************
Function CONFIGSYS && USO INTERNO
*********************************************************************
   Local Papeis[10]
   Local VARMACRO, varmacro2
   Local X, Y, OPC, mfundo, COR
   Local CORES[15,9], PRI, XX, CH
   Local OPCCONFIGSYS
   
   SET DELETED ON
   
   GETUSR()
   
   IF ALLTRIM(UPPER(__NOMUSR)) <> "ADM" .AND. ALLTRIM(UPPER(__NOMUSR)) <> "HOST"
      SET COLOR TO
      CLEAR
      ? "ACESSO NEGADO"
      QUIT
   ENDIF
   
   SET COLOR TO
   CLEAR
   SET COLOR TO W+/B,W+/N
   WINDOW(03, 01, 11, 25, .F.)
   @ 4, 2  PROMPT " Configurar Terminal   " MESSAGE "Configura as cores."
   @ 5, 2  PROMPT " Impressoras           " MESSAGE "Impressoras."
   @ 6, 2  PROMPT " E-Mail                " MESSAGE "Configuração do email."
   @ 7, 2  PROMPT " Senha                 " MESSAGE "Configuração do senhas."
   @ 8, 2  PROMPT " Config.Empresa        " MESSAGE "Configuração da empresa."
   @ 9, 2  PROMPT " FTP                   " MESSAGE "Configuração do FTP."
   @ 10, 2 PROMPT " EDI PARM              " MESSAGE "EDI Parm."
   
   MENU TO OPCCONFIGSYS
   
   DO CASE
       CASE OPCCONFIGSYS == 1
            CONFIGTERM()
       
       CASE OPCCONFIGSYS == 2
            MANIMP()
            
       CASE OPCCONFIGSYS == 3
            EMAILCONFIG()
            
       CASE OPCCONFIGSYS == 4
            MANSEN()
               
       CASE OPCCONFIGSYS == 5
            EMPRESA_CONFIG()
            
       CASE OPCCONFIGSYS == 6
            FTPCONFIG()
            
       CASE OPCCONFIGSYS == 7
            EDIPARM()                   
            
       ENDCASE
       
RETURN .T.

Procedure CONFIGTERM
   
   Private aColor     := {"B","B+", "BG", "BG+", "G", "G+", "GR", "GR+", "I", "N+", "N", "R", "R+", "RB", "RB+", "U", "W", "W+", "X"}
   Private aColorBack := {"B", "BG", "G", "GR", "I", "N", "R", "RB", "U", "W", "X"}
   
   set color to
   clear screen
   
   @ 0, 0 say ""
   
   corletra := 0
   corfundo := 0
   
   @ 0, 0 SAY "  B   " + "  BG  " + "  G   " + "  GR   " + " I    " + "  N   " + "  R   " + "  RB  " + "  U   " + " W    " + "  X   "
   @ 1, 0 SAY ""
   
   for xcor := 1 to 19
      for ycor := 1 to 11
         corletra := xcor
         corfundo := ycor
         setcolor(aColor[corletra] + "/" + aColorBack[corfundo])
         @ row(), col() SAY left(aColor[corletra] + "      ", 6)
         if ycor == 11
            @ row()+1, 0 say ""
         endif
      next
   next
  
   set color to
   
   select(246)
   GO TOP
   locate for crypt(alltrim(__CODUSR), "7654321") == alltrim(CODUSR)
   
   SYS_CORCAB := CORCAB
   SYS_PAPPAR := PAPPAR
   SYS_PAPPAR1 := PAPPAR1
   SYS_CORMEN := CORMEN
   SYS_COREDT := COREDT
   SYS_CORGET := CORGET
   SYS_GETATV := GETATV
   SYS_COROPC := COROPC
   SYS_COREDT := COREDT
   
   @ 22, 00 SAY HB_AnsiToOem("Cabeçalho") GET SYS_CORCAB
   @ 22, 20 SAY "Papel    " GET SYS_PAPPAR1
   @ 22, 40 say "Menu     " GET SYS_CORMEN
   @ 22, 60 say "SAY      " GET sys_COREDT
   @ 23, 00 SAY "GET      " GET sys_CORGET
   @ 23, 20 SAY "GET ATIVO" GET sys_GETATV
   @ 23, 40 SAY HB_AnsiToOem("Opção    ") GET sys_COROPC
   @ 23, 60 say HB_AnsiToOem("Edição   ") GET sys_COREDT
   @ 24, 00 SAY "Caracter do papel de parede" GET SYS_PAPPAR
   read
   SELECT (246)
   TRVREG()
   REPLACE CORCAB WITH SYS_CORCAB,;
           PAPPAR WITH SYS_PAPPAR,;
           CORMEN WITH SYS_CORMEN,;
           COREDT WITH SYS_COREDT,;
           CORGET WITH SYS_CORGET,;
           GETATV WITH SYS_GETATV,;
           COROPC WITH SYS_COROPC,;
           COREDT WITH SYS_COREDT,;
           PAPPAR1 WITH SYS_PAPPAR1
   SAVREG()
   set color to
   clear screen
return

Procedure EDIPARM
   Local MCOD
   Local MPASS
   Local MEMAILDESTINO
   SAVE SCREEN
   TELPAD("EDIPARM", "EDI PARM", 02, 00, 04, 79)
   IF !NETUSE("EDIPARM", .F., 05)
   GO TOP
   IF EOF()
      CHKREC()
   ELSE
      TRVREG()
   ENDIF
   MPASS := SPACE(3)
   MPASS := GetSecret(MPASS, 3, 2, .T., "Digite senha com tres caracteres")
   MEMAILDESTINO := SPACE(50)
   MEMAILDESTINO := GetSecret(MEMAILDESTINO, 3, 2, .T., "Digite o email de destino da senha:")
  
   MCOD := Upper(CodigoRandomico(3))
   *REPLACE EDIPASS WITH Crypt(MCOD, MPASS)
   SAVREG()
   LOGUSR("Gerada a senha para transmissão de arquivos. Foi enviado para o email " + MEMAILDESTINO)
   *emailsender("Senha para envio de arquivos ", "Senha [" + MCOD + "]", "", MEMAILDESTINO)
   ERRO("Anote a senha gerada [" + MCOD + "]")
   RESTORE SCREEN
   USE
   ENDIF
return

Procedure Empresa_Config
   Local M_RS
   Local M_PASS
   SAVE SCREEN
   TELPAD("EMPRESACONFIG", "Configuração da Empresa", 02, 00, 07, 79)
   IF NETUSE("PARM", .F., 05)
      GO TOP
      IF EOF()
         CHKREC()
         SAVREG()
      ENDIF
      M_RS := A026->RS
      M_PASS := SPACE(14)
      @ 3, 2 SAY "Razao Social " + M_RS
      M_RS := GetSecret(M_RS, 3, 2, .T., "Razao Social")
      M_PASS := GetSecret(M_PASS, 4, 2, .T., "Entre a senha do administrador.")
      TRVREG()
      REPLACE RS   WITH M_RS,;
              PASS WITH ALLTRIM(Crypt(alltrim(m_pass), "777"))
      SAVREG()
      USE
   ENDIF
   RESTORE SCREEN
return

Function EmailConfig
   Local varmacro
   SAVE SCREEN
   TELPAD("EMAILCONFIG", "Configuração do email padrão", 02, 00, 07, 79)
   IF !NETUSE("ec", .T., 05)
   GO TOP
   IF EOF()
      CHKREC()
   ELSE
      TRVREG()
   ENDIF
   varmacro := "__EMAIL_PASS"
   &varmacro := PASS
   @ 03, 02 SAY "Email server" GET SERVER
   @ 04, 02 SAY "Port        " GET PORT
   @ 05, 02 SAY "USER        " GET USER
   @ 06, 02 SAY "Password    "
   if !LERGET()
      SAVREG()
      restore screen
      return
   endif
   &varmacro := GetSecret(__EMAIL_PASS, 06, 14, .T., "")
   REPLACE PASS WITH __EMAIL_PASS
   SAVREG()
   USE
   endif
   restore screen
return

Function FTPConfig
   SAVE SCREEN
   TELPAD("FTPCONFIG", "Configuração do ftp padrão", 02, 00, 07, 79)
   IF !NETUSE("ftpc", .T., 05)
      RETURN
   ENDIF
   GO TOP
   IF EOF()
      CHKREC()
   ELSE
      TRVREG()
   ENDIF
   __FTP_PASS = PASS
   @ 03, 02 SAY "FTP   server" GET SERVER
   @ 04, 02 SAY "Port        " GET PORT
   @ 05, 02 SAY "USER        " GET USER
   @ 06, 02 SAY "Password    "
   IF !LERGET()
      SAVREG()
      RESTORE SCREEN
      RETURN
   ENDIF
   __FTP_PASS := GetSecret(__FTP_PASS, 06, 14, .T., "")
   REPLACE PASS WITH __FTP_PASS
   SAVREG()
   USE
   RESTORE SCREEN
return

Function NUMFILES
return 0

*******************************************************************************
Function AMBIENTE
*******************************************************************************
         IF ALLTRIM(__NOMUSR) != "ADM"
            ERRO ("Acesso Negado")
            RETURN
         ENDIF
         SAVE SCREEN
         TELPAD ("04000", ".", 02, 00, 12, 79, .F.)
         WINDOW (02, 00, 12, 79, .F.)
         CENTRA (" Sobre o Ambiente ", 02)
         @ 02, 00 SAY ""
         DRIVE := DISKNAME() + ":"
         @ ROW()+1, 01 SAY "Data, Hora .........: " + DTOC(DATE()) + " " + TIME()
         @ ROW()+1, 01 SAY "DiretÓrio Corrente..: " + CURDIR()
         @ ROW()+1, 01 SAY "Nome da Estação.....: " + IF(NETNAME()=="", "(anonima)", NETNAME())
         @ ROW()+1, 01 SAY "Memória Disponível..: " + TRANSFORM (MEMORY(0), "@E 9,999,999,999 Bytes")
         
         CONFIG_SYS   := MEMOREAD (DRIVE + "\CONFIG.SYS")
         AUTOEXEC_BAT := MEMOREAD (DRIVE + "\AUTOEXEC.BAT")
         
         TELPAD ("00000", ".", 13, 00, 22, 79)
         SET CURSOR ON
         CENTRA (" Editando " + DRIVE + "\CONFIG.SYS ", 13)
         CONFIG_SYS := MEMOEDIT (CONFIG_SYS, 14, 01, 21, 78,,, 256)
         IF ASK ("Quer salvar estas mudancas " + ALLTRIM(__NOMUSR), 2)
            IF !MEMOWRIT (DRIVE + "\CONFIG.SYS", CONFIG_SYS)
               ERRO ("Não foi possível salvar o arquivo")
            ENDIF
         ENDIF

         TELPAD ("00000", ".", 13, 00, 22, 79)
         CENTRA (" Editando " + DRIVE + "\AUTOEXEC.BAT ", 13)
         SET CURSOR ON
         AUTOEXEC_BAT := MEMOEDIT (AUTOEXEC_BAT, 14, 01, 21, 78,,, 256)
         IF ASK ("Quer salvar estas mudancas " + ALLTRIM(__NOMUSR), 2)
            IF !MEMOWRIT (DRIVE + "\AUTOEXEC.BAT", AUTOEXEC_BAT)
               ERRO ("NÆo foi poss¡vel salvar o arquivo")
            ENDIF
         ENDIF
RETURN

*********************************************************************
Function LOADCONFIGUSR  && USO INTERNO
*********************************************************************

    PRIVATE OLDARE, OLDREC
    OLDARE := SELECT()
    OLDREC := RECNO()

    SELECT (246)
    NET_USE ("SYSPSS.DBF", .F., 5)    
    locate for crypt(alltrim(__NOMUSR), "7654321") == alltrim(CODUSR)
    
    IF EOF()
       ERRO("Usuário não localizado " + __NOMUSR)
       QUIT
    ENDIF
    
    *- COR CABECALHO
       SYS_CORCAB := CORCAB
       SYS_CORCAB := ALLTRIM(CORCAB)

    *- COR MENU
       SYS_CORMEN := CORMEN
       SYS_CORMEN := ALLTRIM(CORMEN)

    *- PAPEL DE PAREDE
       SYS_PAPPAR := PAPPAR 
       SYS_PAPPAR := RTRIM(SYS_PAPPAR)   
       SYS_PAPPAR := LEFT (REPLICATE(SYS_PAPPAR, 80), 80)

    *- COR PAPEL DE PAREDE
       SYS_PAPPA1 := ALLTRIM(PAPPAR1)

    *- COR PROMPT
       SYS_COROPC := ALLTRIM(COROPC)

    *- JANELA DE EDICAO
       SYS_COREDT := ALLTRIM(COREDT)

    *- COR DO GET INATIVO
       SYS_CORGET := ALLTRIM(CORGET)

    *- COR DO GET ATIVO
       SYS_GETATV := ALLTRIM(GETATV)

    SELECT (OLDARE)
    GOTO   (OLDREC)
RETURN .T.

*********************************************************************
Function OPC_MENU  && USO INTERNO
*********************************************************************

    PARAMETERS LINHA, COLUNA, OPCAO, NUMERO, HELP
  
    IF NUMERO == 1
       FOR X := 1 TO 14
           FAST_LINHA[X] = ""
           FAST_COLUNA[X] = ""
           FAST_OPCAO[X] = ""
           FAST_MSG[X] = ""
       NEXT
    ENDIF

    FAST_LINHA  [NUMERO] := LINHA
    FAST_COLUNA [NUMERO] := COLUNA
    FAST_OPCAO  [NUMERO] := OPCAO
    erro (opcao)
    FAST_MSG    [NUMERO] := HELP
    FAST_ULTIMA          := NUMERO     
RETURN NIL
 
*********************************************************************
Function MENUTO  && USO INTERNO
*********************************************************************

    OPC := 1

    SETCOLOR (SYS_CORMEN)

    FAST_HOT_KEY := ""
    
    erro (str(fast_ultima))

    FOR X = 1 TO FAST_ULTIMA
       
        IF FAST_OPCAO [X] == NIL
           FAST_OPCAO [X] := ""
        ENDIF

        *- DISPLAY DA OPCAO COM HIGHLITE
           FAST_SHOWOPC(1, x)

        *- GUARDAR TECLA CHAVE
           FAST_HOT_KEY += UPPER(SUBSTR (FAST_OPCAO [X], AT("\<", FAST_OPCAO [X]) +2, 1))
    NEXT

    X := OPC

    IF X < 1
       X := 1
    ENDIF

    IF X > FAST_ULTIMA
       X := FAST_ULTIMA
    ENDIF

    DO WHILE .T.
       SETCOLOR (SYS_COROPC)
       IF FAST_OPCAO [X] == ""
          FAST_OPCAO [X] := ""
       ENDIF
       FAST_SHOWOPC(1, x)
       SETCOLOR(SYS_CORMEN)
       MENSAGEM(FAST_MSG[X])

       DO WHILE .T.
          CH := INKEY (0) 

          DO CASE
             CASE CH = K_F1
                  EXIT

             CASE UPPER(CHR (CH)) $ FAST_HOT_KEY
                  EXIT

             CASE CH >= 49 .AND. CH <= FAST_ULTIMA + 49
                  EXIT

             CASE CH == K_ESC .OR. CH == K_ALT_2 .OR. CH == K_ALT_3
                  EXIT

             CASE CH == K_ENTER
                  EXIT

             CASE CH == K_CTRL_E .OR. CH == K_UP
                  EXIT

             CASE CH == K_CTRL_X .OR. CH == K_DOWN
                  EXIT  

             CASE CH == K_CTRL_S .OR. CH == K_LEFT
                  EXIT

             CASE CH == K_CTRL_D .OR. CH == K_RIGHT
                  EXIT

             CASE CH == K_PGDN .OR. CH == K_PGUP .OR. CH == K_HOME .OR. CH == K_END
                  EXIT

             OTHERWISE
                  
          ENDCASE     
       ENDDO
       
       FAST_SHOWOPC(0, x)
       
       DO CASE
          CASE CH == K_F1
               MODHLP()
          CASE UPPER(CHR (CH)) $ FAST_HOT_KEY
               X := AT (UPPER(CHR (CH)), FAST_HOT_KEY)
               KEYBOARD CHR(K_ENTER)
          CASE CH == K_PGDN .OR. CH == K_END
               X := FAST_ULTIMA
          CASE CH == K_PGUP .OR. CH == K_HOME
               X := 1
          CASE CHR (CH) >= "1" .AND. VAL (CHR (CH)) <= FAST_ULTIMA
               X := VAL (CHR(CH))+1
               KEYBOARD CHR (K_ENTER)
          CASE CH == K_ESC
               X := 0
               EXIT
          CASE CH == K_ENTER
               EXIT
          CASE CH == K_CTRL_E .OR. CH == K_UP
               IF X == 1
                  X := FAST_ULTIMA
               ELSE
                  X--
               ENDIF   
          CASE CH == K_CTRL_X .OR. CH == K_DOWN
               IF X == FAST_ULTIMA
                  X := 1
               ELSE
                  X++
               ENDIF    
          CASE CH == K_CTRL_S .OR. CH == K_LEFT
               KEYBOARD CHR (K_ESC) + CHR (K_CTRL_S) &&+ CHR (K_ENTER)
          CASE CH == K_CTRL_D .OR. CH == K_RIGHT
               KEYBOARD CHR (K_ESC) + CHR (K_CTRL_D) &&+ CHR (K_ENTER)  
          ENDCASE
          
       ENDDO 
RETURN X

*********************
Function FAST_SHOWOPC
*********************

Parameter MOSTRA, qualopc

IF MOSTRA == 1
   COR_CHAVE := ALLTRIM(STR(VAL(LEFT(SYS_CORMEN, AT ("/", SYS_CORMEN)-1))+8)) + SUBSTR (SYS_CORMEN, AT ("/", SYS_CORMEN), 30)
ELSE
   COR_CHAVE := ALLTRIM(STR(VAL(LEFT(SYS_CORMEN, AT ("/", SYS_CORMEN)-1))+8)) + SUBSTR (SYS_COROPC, AT ("/", SYS_COROPC), 30)
ENDIF

PRECHAVE := LEFT   (FAST_OPCAO [qualopc], AT ("\<", FAST_OPCAO [X])-1)
CHAVE    := SUBSTR (FAST_OPCAO [qualopc], AT ("\<", FAST_OPCAO [X])+2, 01)
POSCHAVE := SUBSTR (FAST_OPCAO [qualopc], AT ("\<", FAST_OPCAO [X])+3, 30)
@ FAST_LINHA [qualopc], FAST_COLUNA[qualopc] SAY PRECHAVE
@ FAST_LINHA [qualopc], COL() SAY CHAVE COLOR COR_CHAVE
MCOL := COL()
@ FAST_LINHA [qualopc], COL() SAY LEFT(POSCHAVE+SPACE(80),79-MCOL)
RETURN NIL

*********************************************************************
Function CONSULTA && CONSULTA SIM/NAO
*********************************************************************

    PARAMETERS EXP && SE &EXP, RETORNA FALSO

    IF TYPE ("EXP") = "U"
       EXP = ".F."
    ENDIF

    MENSAGEM ("Use " + CHR(24) + " " + CHR(25) + " para mover.")
    SETA   = INKEY(0)
    _RECNO = RECNO()

    DO CASE
       CASE SETA = 05 && PARA CIMA
       SKIP -1

       CASE SETA = 24 && PARA BAIXO
       SKIP

       CASE ESCKEY()
       RETURN .F.
    ENDCASE

    IF &EXP .OR. BOF() .OR. EOF()
      IF SETA = 05
         ERRO ("Este e´ o primeiro")
      ELSE
         ERRO ("Este e´o Ultimo")
      ENDIF
      GO _RECNO
    ENDIF
RETURN .T.

*********************************************************************
Function GETUSR  && USO INTERNO
*********************************************************************

          Local varaux 
          
          Clear

          CENTRA (HB_AnsiToOem("."), 4)
          
          CENTRA (HB_AnsiToOem("DADOS PARA SUPORTE"),6)
          CENTRA (HB_AnsiToOem("Telefone: (19) 3897-4477"), 7)
          CENTRA (HB_AnsiToOem("E-Mail: efmelo@outlook.com"), 8)
             
          SELECT (250)
          NET_USE ("SYSMEN.DBF", .F., 5)
          *SET INDEX TO ("SYS101")

          SELECT (249)
          NET_USE ("SYSOPC.DBF", .F., 5) 
          *SET INDEX TO ("SYS201")

          SELECT (248)
          NET_USE ("SYSUSR.DBF", .F., 5)
          *SET INDEX TO ("SYS301")
 
          SELECT (247)
          NET_USE ("SYSLOG.DBF", .F., 5)
          
          SELECT (246)
          NET_USE ("SYSPSS.DBF", .F., 5)
   
          M_TENTATIVAS := 1
          M_ACESSO := .F.
          
          SYS_PAPPAR = IIF(TYPE("SYS_PAPPAR")<>"C", " ", SYS_PAPPAR)

          DO WHILE M_TENTATIVAS <= 3 .AND. !M_ACESSO
             
             TELPAD ("00000", "Digite a chave de acesso", 15, 20, 18, 60, .F.)
             SYS_CORMEN := SYS_COREDT
             @ 16, 25 SAY "Usuario:"
             @ 17, 25 SAY "Chave..:"
             __NOMUSR := GETSTR (16, 34, "!", 24)
             __CODUSR := GETSTR (17, 34, "*", 24)
             M_ACESSO := .F.
             IF ALLTRIM(__NOMUSR) == "ADM"
                SELECT (246)
                NET_USE ("SYSPSS.DBF", .F., 5)
                locate for crypt(alltrim(__NOMUSR), "7654321") == alltrim(CODUSR)
                IF EOF()
                   ERRO ("USUÁRIO NÃO LOCALIZADO!")
                ENDIF
                IF alltrim(PASS) == crypt(alltrim(__CODUSR), "7654321") .OR. EOF()
                   ERRO ("ACESSO AUTORIZADO")
                   M_ACESSO := .T.
                ELSE
                   if EOF()
                      // USUÁRIO ADM AINDA NÃO ESTÁ CONFIGURADO
                      M_ACESSO := .T.
                   else
                      ERRO ("SENHA ERRADA")
                      M_TENTATIVAS := M_TENTATIVAS + 1
                   endif
                ENDIF
             ELSE
                RELEASE __SYS_NROARQ 
                SELECT (246)
                NET_USE ("SYSPSS.DBF", .F., 5)
                locate for crypt(alltrim(__NOMUSR), "7654321") == alltrim(CODUSR)
                IF EOF()
                   ERRO ("USUÁRIO NÃO LOCALIZADO!")
                   LOOP
                ENDIF
                IF alltrim(PASS) == crypt(alltrim(__CODUSR), "7654321") .OR. EOF()
                   ERRO ("ACESSO AUTORIZADO")
                   M_ACESSO := .T.
                ELSE
                   if EOF()
                      // USUÁRIO ADM AINDA NÃO ESTÁ CONFIGURADO
                      M_ACESSO := .T.
                   else
                      ERRO ("SENHA ERRADA")
                      M_TENTATIVAS := M_TENTATIVAS + 1
                   endif
                ENDIF
             ENDIF
          ENDDO
       
          IF M_ACESSO == .F.
             FIMPRG(1)
          ENDIF
       
RETURN NIL

*********************************************************************
Function CALLPRG  && USO INTERNO
*********************************************************************

Parameter pCod

__MENU := "00000"

do while .t.
   __OP := BOXMENU()
   FINDKEY (249, 001, __MENU)
   //erro (str(__op))
   if __OP > 0
      if __OP > 1
         __OP := __OP - 1
         for i := 1 to __OP
             SKIP
         next
      endif
      FINDKEY (248, 01, __MENU + crypt(alltrim(__NOMUSR, "7654321")))
      if SUBSTR (crypt(CODACE, "7654321"), __OP, 1) == "N" .AND. UPPER(ALLTRIM(__NOMUSR)) != "ADM"
         ERRO ("ACESSO NEGADO")
      elseif SUBSTR (crypt(CODACE, "7654321"), __OP, 1) == "S" .OR. UPPER(ALLTRIM(__NOMUSR)) == "ADM"
         SELECT (249)
         if SUBMEN == "S"
            __MENU := RUNPRG
         else
            MENSAGEM ("Um momento.")
            _RUNPRG  =  COD + RUNPRG
            __INIVAR = .T.
            SAVE SCREEN
            M_OLDMOD   := __NUMMOD
            // LOGUSR ("Entrei no módulo " + _RUNPRG)
            DO &_RUNPRG
            __NUMMOD := M_OLDMOD
            MENSAGEM("Um momento ...")
            FECARQ()
            RESTORE SCREEN
         endif
       endif
   else
      // Voltar para o menu principal
      __MENU := "00000"
   endif
enddo

return NIL

*********************************************************************
Function LOGUSR  && REGISTRA A ATIVIDADE DO USUARIO LOGADO 
*********************************************************************

    PARAMETER MENSAGEM  && SCRIPT
    
      TRY
         
      cn := CreateObject( "ADODB.Connection" )
      
      cConStrg := "Provider=SQLOLEDB.1;" +;
                  "Data Source=tcp:gilmar.database.windows.net,1433;Database=Gilmar;User ID=gilmar@gilmar;Password=EfEf140972;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;" +;
                  "Persist Security Info=True;"
      
      cn:ConnectionString := cConStrg
      cn:Open()
      oCommand := CreateObject("ADODB.Command")
      oCommand:ActiveConnection := cn
      set date to japan
      _P1 := dtoc(date()) + " " + time()
      set date to brit
      cn:Execute("INSERT INTO Table_CEP_DOS_JORNAL (DATA_HORA, IDENTIFICACAO, INFORMACAO, DIR, PATH) VALUES ('" + _P1 + "','" + __NOMUSR + "','" + MENSAGEM + "','" + NETNAME() + "','" + CURDIR() + "');")
      cn:Close()
      cn := Nil
   CATCH oErr
     Alert( "Error: " + oErr:Operation + " -> " + oErr:Description )
   END     
    
   // NOMUSR WITH __NOMUSR,;
       
RETURN .T.

*********************************************************************
Function LERGET
*********************************************************************

    PARAMETERS _INFGET  && INFORMACAO PARA MENSAGEM

    PRIVATE RIGHT
    RIGHT := ALLTRIM (SUBSTR (SYS_COROPC, AT ("/", SYS_COROPC)+1, 10))

    IF TYPE ("_INFGET") == "C"
      MENSAGEM (_INFGET)
    ELSE
      MENSAGEM (MSG_GET)
    ENDIF
    SET CURSOR ON
    
    SETCOLOR (SYS_CORMEN + "," + SYS_COROPC + ",N," + SYS_GETATV)
    READ
    SET CURSOR OFF
    __INIVAR = .F.
RETURN !ESCKEY()

*********************************************************************
Function ZERO
*********************************************************************
 
    PARAMETERS VARIAVEL,; && STRING
               CASAS,;    && TAMANHO EX.: "0003"
               X, Y       && LINHA A COLUNA PARA DISPLAY

    VARIAVEL = ALLTRIM (VARIAVEL)
    VARIAVEL = RIGHT (REPLICATE ("0", CASAS) + VARIAVEL, CASAS)
    IF TYPE ("X") = "N" .AND. TYPE ("Y") = "N"
      @ X, Y SAY VARIAVEL
    ENDIF
RETURN VARIAVEL

*********************************************************************
Function SPCSTR
*********************************************************************

    PARAMETERS VARIAVEL,; && STRING
               CASAS,;    && TAMANHO EX.: "   3"
               X, Y       && LINHA A COLUNA PARA DISPLAY

    VARIAVEL := ALLTRIM (VARIAVEL)
    VARIAVEL := VARIAVEL + SPACE (CASAS - LEN(VARIAVEL))

    IF TYPE ("X") != "U" .AND. TYPE ("Y") != "U"
       @ X, Y SAY VARIAVEL
    ENDIF

RETURN VARIAVEL

*********************************************************************
Function PRXNRO
*********************************************************************
 
 LOCAL HDLE, X, _PRXNRO
 
 PARAMETERS VARIAVEL,; && VARIAVEL PARA SER RETORNADA
 CASAS      && TAMANHO EM ZEROS



IF VARIAVEL == "RELEASE"
   DELETE FILE (DBF())
   RETURN NIL
ENDIF

DO WHILE FILE (LOWER(DBF()))
   INKEY (1)
ENDDO

HDLE = FCREATE (DBF())
FCLOSE (HDLE)
 
GOTO BOTTOM

X = ""

FOR I = 1 TO CASAS
    X = X + "9"
NEXT

IF &VARIAVEL. >= X
   DELETE FILE (DBF())
   RETURN .F.
ENDIF

_PRXNRO = ZERO ( STR ( VAL (&VARIAVEL.) +1), CASAS)
CHKREC()
REPLACE &VARIAVEL. WITH _PRXNRO 
RETURN .T.

*********************************************************************
Function DISVAR
*********************************************************************
 
    *- DISPLAY ASSOCIADO COMO O SHOW_FIELD

    PARAMETERS _LINHA, _COLUNA, _VARIAVEL, _AREA, _ORDEM, _CONTEUDO, _LI, _CL
    PRIVATE OLDAREA

    @ _LINHA, _COLUNA SAY _VARIAVEL

    IF TYPE ("_AREA") != "U"
       OLDAREA = SELECT()
       IF FINDKEY (_AREA, _ORDEM, _VARIAVEL)
          @ _LI, _CL SAY &_CONTEUDO.
       ENDIF
       SELECT (OLDAREA)
    ENDIF
RETURN NIL

*********************************************************************
Function MES
*********************************************************************
 
    PARAMETERS DAT,; && DATA
               K     && SE NAO DEFINIDO RETORNA O MES ABREVIADO

    X = SUBSTR (DTOC (DAT), 04, 02)

    DO CASE
       CASE X = "01"
       Y = IF (TYPE("K") != "U", "JANEIRO", "JAN")

       CASE X = "02"
       Y = IF (TYPE("K") != "U", "FEVEREIRO", "FEV")

       CASE X = "03"
       Y = IF (TYPE("K") != "U", "MARCO", "MAR")

       CASE X = "04"
       Y = IF (TYPE("K") != "U", "ABRIL", "ABR")

       CASE X = "05"
       Y = IF (TYPE("K") != "U", "MAIO", "MAI")

       CASE X = "06"
       Y = IF (TYPE("K") != "U", "JUNHO", "JUN")

       CASE X = "07"
       Y = IF (TYPE("K") != "U", "JULHO", "JUL")

       CASE X = "08"
       Y = IF (TYPE("K") != "U", "AGOSTO", "AGO")

       CASE X = "09"
       Y = IF (TYPE("K") != "U", "SETEMBRO", "SET")

       CASE X = "10"
       Y = IF (TYPE("K") != "U", "OUTUBRO", "OUT")

       CASE X = "11"
       Y = IF (TYPE("K") != "U", "NOVEMBRO", "NOV")

       CASE X = "12"
       Y = IF (TYPE("K") != "U", "DEZEMBRO", "DEZ")

    ENDCASE

RETURN Y

*********************************************************************
Function INIALL
*********************************************************************
 
PARAMETERS COD,;            && CODIGO DO SISTEMA
           SISTEMA,;        && NOME DO SISTEMA
           LINHAS,;         && QUANTIDADE DE LINHAS DO VIDEO
           MULT_EMPRESAS,;  && .T. MULT-EMPRESAS
           _INDEXFILE

    // Português do Brasil
      
    // REQUEST HB_LANG_PT
    
    // HB_LangSelect("PT")
    // HB_SetCodePage("PT850")           
    
    // Mouse nos Gets
    
    setmouse(.t.)
    // SET(39,159)
    
    *** DEFINIR IDIOMA PORTUGUÊS ***
    
    REQUEST HB_CODEPAGE_PTISO &&& PARA INDEXAR CAMPOS ACENTUADOS
        
    HB_SETCODEPAGE("PTISO")   &&& PARA INDEXAR CAMPOS ACENTUADOS

    SETCANCEL (.T.)

    __QTDTEL     := 0
    __NOMSIS     := SISTEMA
    __SISTEMA    := SISTEMA
    __COD        := COD
    __TEL        := "99 999.9999-9999"
    __TLX        := "99999999999999"
    __CR         := "@E 999,999,999,999.99"
    __CGC        := "99.999.999/9999-99"
    MSG_GET      := "Entre com os dados."
    MSG_SAV      := "Você quer salvar"
    MSG_PRN      := "Confirma impressão"
    MSG_DEL      := "Confirma exclusão"
    SYS_LASTLINE := LINHAS-1
    SET CURSOR OFF
    SET CENTURY ON
    SET DATE BRITISH
    SET SCOREBOARD OFF
    SET WRAP ON
    SET CONFIRM ON
    SET DELETE ON
    SET EXCLUSIVE OFF
    SET MESSAGE TO
    SET SCOREBOARD ON
    
    IF MULT_EMPRESAS
       SELEMP()
    ENDIF
    
    IF TYPE ("_INDEXFILE") == "C"
       __NOMUSR := "ADM"
       IF _INDEXFILE = "CONFIGURADOR"
          CONFIGSYS()
          FIMPRG(2)
       ENDIF
       __NOMUSR := ""
       INIDBF()
       ININTX(_INDEXFILE)
       CLOSE ALL
       QUIT
    ENDIF

    GETUSR()
    GETPARM()
    LOADCONFIGUSR()
    SET KEY K_F1  TO MODHLP
    SET KEY K_F12 TO FIMPRG()
    CALLPRG(COD)
RETURN NIL

Function GETPARM
   IF NETUSE ("PARM.DBF", .F., 05)
      __SYS_NOMCLI := A031->RS
      ADIV := ALLTRIM(STR(QTD / 30))
      ADIV := RIGHT(ADIV,3)
      GO TOP
      IF EOF()
         CHKREC()
      ELSE
         TRVREG()
      ENDIF
      IF QTD >= 210
         REPLACE QTD WITH 1
      ELSE
         REPLACE QTD WITH QTD+1
      ENDIF
      SAVREG()
      USE
   ENDIF
return ""

Function SELEMP
         TELPAD ("99999", ".", 00, 00, 22, 79)
         CENTRA ("Empresas Disponiveis", 00)
         SELECT 250

         NET_USE ("SYSEMP", .T., 00)
         INDEX ON CODEMP TAG SYSEMP01

         NET_USE ("SYSEMP", .F., 00)

         IF !FINDKEY (250, 01, "01")
            MENSAGEM ("Um momento ...")
            CHKREC()
            REPLACE CODEMP WITH "01",;
                    NOMEMP WITH CLIENTE()
            SAVREG()
            RUN MD 01            > NUL:
            RUN COPY SYS*.DBF 01 > NUL:
         ENDIF

         MENSAGEM ("Utilize as setas para selecionar.")
         CAMPOS := {"CODEMP", "NOMEMP"}
         TITULOS := {"Número", "Nome"}
         SETCOLOR (SYS_COREDT + "," + SYS_GETATV)
         DBEDIT (01, 01, 21, 78, CAMPOS, "ONLY_SEE",, TITULOS) 
         #IFDEF _CLIPPER_
            CLEAR TYPEAHEAD
         #ENDIF
         M_CODEMP     := CODEMP
         __SYS_NOMCLI := ALLTRIM(NOMEMP)
         RUNPRG2 := "CD " + M_CODEMP
         RUN(RUNPRG2)
         ERRO(CLIENTE() + " Diretorio "  + CURDIR())
return

*********************************************************************
Function CLIENTE
*********************************************************************

RETURN "CEU AZUL Catalogos"

*********************************************************************
Function INIVAR
*********************************************************************
 
    PARAMETERS X, Y

    IF TYPE (X) = "U"
       __INIVAR = .T.
    ENDIF

RETURN   IF (__INIVAR, Y, &X.)


Procedure OpenSysfiles
 
          SELECT (250)
          NET_USE ("SYSMEN", .F., 0)
          SET INDEX TO ("SYSMEN")

          SELECT (249)
          NET_USE ("SYSOPC", .F., 0) 
          SET INDEX TO ("SYSOPC")

          SELECT (248)
          NET_USE ("SYSUSR", .F., 0)
          SET INDEX TO ("SYSUSR")
 
          SELECT (247)
          NET_USE ("SYSLOG", .F., 0)
          
          SELECT (246)
          NET_USE ("SYSPSS", .F., 0)
   
return .t.

*********************************************************************
Function FECARQ  && USO INTERNO
*********************************************************************
    CLOSE ALL
    OPENSYSFILES()
RETURN .T.

*********************************************************************
Function NET_USE
*********************************************************************
 
    PARAMETERS FILE, EX_USE, WAIT
    
    PRIVATE FOREVER, AREA, hndle
    FILE := lower (FILE)
    IF AT (".DBF", UPPER(FILE)) == 0
       FILE := FILE + ".dbf"
    ENDIF
    AREA    = "A" + ZERO (STR(SELECT()), 3)
    WAIT    = IF (TYPE ("WAIT") = "U", 0, WAIT)
    FOREVER = (WAIT = 0)

    DO WHILE (FOREVER .OR. WAIT > 0)
       
       IF EX_USE
          USE (FILE) ALIAS (AREA) EXCLUSIVE
       ELSE
          USE (FILE) ALIAS (AREA)
       ENDIF
       
       IF !NETERR()
           FOREVER := .F.
           WAIT := 0
       ELSE
           INKEY(1)
           WAIT = WAIT -1
       ENDIF
    ENDDO

    IF NETERR()
       ALERT(HB_AnsiToOem("Impossível abrir o arquivo " + FILE + "."))
       RETURN .F.
    ELSE
       RETURN .T.
    ENDIF

*********************************************************************
Function TRVARQ
*********************************************************************
 
    PARAMETERS WAIT
    PRIVATE FOREVER

    IF FLOCK()
       RETURN .T.
    ENDIF

    WAIT = IF (TYPE ("WAIT") = "U", 0, WAIT)
    FOREVER = (WAIT = 0)

    DO WHILE (FOREVER .OR. WAIT > 0)

       INKEY (.5)

       IF FLOCK()
          RETURN .T.
       ENDIF

    ENDDO
RETURN .F.

*********************************************************************
Function TRVREG
*********************************************************************
 
    PARAMETERS WAIT, AREA
    PRIVATE FOREVER

    IF TYPE ("AREA") != "U"
       SELECT (AREA)
    ENDIF

    IF RLOCK()
       RETURN .T.
    ENDIF

    WAIT = IF (TYPE ("WAIT") = "U", 0, WAIT)
    FOREVER = (WAIT = 0)

    DO WHILE (FOREVER .OR. WAIT > 0)

       IF RLOCK()
          RETURN .T.
       ENDIF

       INKEY (.5)
       WAIT = WAIT - .5
    ENDDO
RETURN .F.

********************************************************************
Function NOVREG
********************************************************************
 
    PARAMETERS WAIT, AREA
    PRIVATE FOREVER

    IF TYPE ("AREA") = "N"
       SELECT (AREA)
    ENDIF

    APPEND BLANK

    IF !NETERR()
       RETURN .T.
    ENDIF

    WAIT = IF (TYPE ("WAIT") = "U", 0, WAIT)
    FOREVER = (WAIT = 0)

    DO WHILE (FOREVER .OR. WAIT = 0)
       APPEND BLANK

       IF !NETERR()
          RETURN .T.
       ENDIF

       INKEY (.5)
       WAIT = WAIT -.5
    ENDDO
RETURN .F.

*********************************************************************
Function SENNOM  && USO INTERNO
*********************************************************************
 
    PARAMETERS _SENHA

    X = LEN (_SENHA)
    _VOLTA = ""

    FOR I = 1 TO X
        AA = ASC (SUBSTR (_SENHA, I, 1)) + 1
        IF AA > 255
           AA = 0
        ENDIF
        _VOLTA += CHR (AA)
    NEXT
RETURN _VOLTA

*********************************************************************
Function NOMSEN  && USO INTERNO
*********************************************************************
 
    PARAMETERS _SENHA

    X = LEN (_SENHA)
    _VOLTA = ""

    FOR I = 1 TO X
       AA = ASC (SUBSTR (_SENHA, I, 1))
       AA = AA - 1
       IF AA < 0
          AA = 255
       ENDIF
       _VOLTA = _VOLTA + CHR (AA)
    NEXT

RETURN _VOLTA

*********************************************************************
Function MODHLP && HELP AUTOMATICO
*********************************************************************

    PRIVATE OLD_COL := COL()
    PRIVATE OLD_ROW := ROW()

    PRIVATE _OLDSEL 
    _OLDSEL = SELECT()

    OLD_COLOR := SETCOLOR()

    SET KEY K_F1 TO

    SALTEL()
    TELPAD(__NUMMOD, ".", 03, 05, 21, 74, .F.)
    @ 03, 06 SAY " Ajuda "
    MENSAGEM ("Para sair da tela de ajuda, pressione a tecla <ESC>.")
    SET CURSOR ON

    M_HLPARQ = "SYS" + __NUMMOD + ".HLP"
    M_HLPTXT = IF (FILE(M_HLPARQ), MEMOREAD (M_HLPARQ), "")
    MEMOEDIT (M_HLPTXT, 05, 06, 20, 73, .F.)

    IF ALLTRIM(__NOMUSR) == "ADM"
        IF INKEY(0.5) == K_F10
           MENSAGEM ("Editando a tela de Ajuda. ^W Grava, ESC Abandona")
           M_HLPTXT = MEMOEDIT (M_HLPTXT, 05, 06, 20, 73, .T.)
         MEMOWRIT (M_HLPARQ, M_HLPTXT) 
        ENDIF
    ENDIF

    RESTEL()
    SELECT(_OLDSEL)
    @ OLD_ROW, OLD_COL SAY ""
    SET KEY K_F1 TO MODHLP
    SETCOLOR (OLD_COLOR)
RETURN .T.

*********************************************************************
Function ATUSEN && USO INTERNO
*********************************************************************
 
    PARAMETERS _CODUSR
    
     PRIVATE __OP

    **> Salvar ponteiro dos arquivos
    
       SELECT (250)
       SEL250 := RECNO()
       SELECT (249)
       SEL249 := RECNO()
       SELECT (248)
       SEL248 := RECNO()
       M_MENU := "00000"
       
    Selecionado = 1
    Declare Opcoes [400]
        
    Do While .T.
    
       **> Carregar possibilidades para memoria
          Select (249)
          Go Top
          Opcao = 0
           
          Do While !eof()
            Acesso = CRYPT(Findkey (248, 01, A249->CodMen + crypt(__CodUsr, "7654321"), "CodAce"), "7654321")
            Acesso = SubStr (Acesso, Val (Left (A249->CodOpc, 1) ), 1)
            Acesso = If (Acesso = "S", "Abre", "Fecha")
            Select (249)
            Opcao = Opcao + 1
            Opcoes[Opcao] = codmen + " " + left(codopc, 20) + " " + Left (DesOpc,45) + " " + Acesso + " " + CodMen + Left (A249->CodOpc, 1)
            Skip
          EndDo
        
          @ 07, 00 To 21, 79
          CENTRA (" Rotinas do Sistema ", 07)
          Selecionado = AChoice (08, 01, 20, 78, Opcoes, , , Selecionado)
          If Selecionado = 0
             Exit
          Else
             M_Menu := Left (Right(Opcoes[Selecionado],6),5)
             m_encontrou := Findkey (248, 01, M_Menu + CRYPT(__CODUSR, "7654321"))
             Opc      = Right (Opcoes[Selecionado],1)
             M_CODACE = CRYPT(CODACE, "7654321")
             M_NOVOPC = If (SubStr(M_CODACE, Val (Opc), 1) = "S", "N", "S")
             M_CODACE = STUFF (M_CODACE, Val (Opc), 1, M_NOVOPC)
             if !m_encontrou
                CHKREC()
                replace codmen with m_menu,;
                        codusr with crypt(__CODUSR, "7654321")
             else
                TrvReg()
             endif
             Replace CODACE With CRYPT(M_CODACE, "7654321")
             SavReg()
          EndIf
       Enddo
     
    **> Voltar ponteiro dos arquivos
         SELECT (250)
         GO     SEL250
         SELECT (249)
         GO     SEL249
         SELECT (248)
         GO     SEL248    
    
RETURN NIL

*********************************************************************
Function ATUMEN  && USO INTERNO
*********************************************************************
 
    PARAMETERS _CODUSR, M_MENU
    FINDKEY (250, 01, M_MENU)
    M_QTDOPC := QTDOPC  
    FINDKEY (248, 01, M_MENU + _CODUSR)
    M_CODMEN := CODMEN
    M_CODACE := CODACE
    FINDKEY (249, 01, M_MENU)
    PRIVATE _QTDOPC, LI, LF, _CODOPC 
    _QTDOPC := M_QTDOPC
    LI      := 02
    LF      := 03 + M_QTDOPC

    IF M_MENU != "00000"
      PRIVATE COLMEN 
      COLMEN := "__COLMEN" + LEFT (M_CODMEN, 1)
      IF TYPE ("COLMEN") == "U"
        &COLMEN. := 01
      ENDIF
      PRIVATE CI, CF 
      CI := &COLMEN.
      CF := &COLMEN. + 25
    ELSE
      PRIVATE CI, CF 
      CI := 01
      CF := 26
    ENDIF

    __LINHA  := LI +1
    __COLUNA := CI +1
    FUNDO (02,00,SYS_LASTLINE-1,79)
    
    IF M_MENU == "00000" && MENU PRINCIPAL
      __COLUNA := 1
      SETCOLOR (SYS_CORMEN)
      @ 01, 00 SAY SPACE (80)
      MENSAGEM ("O asterisco indica que o usuário tem acesso.")

      FOR _VARAUX = 1 TO _QTDOPC
          _CODOPC := SUBSTR (CODOPC, 04, 01) + LOWER (ALLTRIM(RIGHT(CODOPC, 25)))
          @ 01, __COLUNA PROMPT _CODOPC + IF (SUBSTR (M_CODACE, _VARAUX, 1) = "S", "*", " ")
          PRIVATE COLMEN 
          COLMEN := "__COLMEN" + LEFT (CODOPC, 1)
          PUBLIC &COLMEN. 
          &COLMEN. := IF (__COLUNA > 51, 51, __COLUNA)
          __COLUNA := __COLUNA + LEN (_CODOPC) +3
          SKIP
        NEXT
    ELSE
      WINDOW (LI, CI, LF, CF+6, .F.)
      FOR _VARAUX = 1 TO _QTDOPC
        @ __LINHA, __COLUNA PROMPT CODOPC + IF (SUBSTR (M_CODACE, _VARAUX, 1) = "S", "*", " ")
        __LINHA++
        SKIP
      NEXT
    ENDIF

    MENU TO __OP
RETURN NIL

*********************************************************************
Function MANSEN
*********************************************************************

    DO WHILE .T. 
       FUNDO (2, 0, 23, 79)
       SAVE SCREEN
       SET COLOR TO W+/B,W+/N
       MENSAGEM ("Indique o que quer fazer.")
       PRIVATE _OPCAO
       DECLARE _OPCOES := {"Cancelar", "Atividades", "Novo", "Usuarios", "Log"}
       MSG = "Bem vindo, " + __nomusr + ", escolha :"

       TELPAD ("04000", ".", 11, 20, 11, 20, .F.)
       SET COLOR TO
       _OPCAO = ALERT (MSG, _OPCOES)

       IF _OPCAO = 0
          RETURN  
       ENDIF

       DO CASE
          CASE _OPCAO == 1
               _NOMUSR := SPACE (24)
               TELPAD ("05000", "Excluir uma senha", 02, 00, 04, 79)
               @ 03, 02 SAY "Qual o nome " GET _NOMUSR PICTURE "@!" 
               READ

               IF ALLTRIM(_NOMUSR) == "ADM"
                  ERRO ("Você não pode ser excluido")
                  LOOP
               ENDIF

               if ASK ("Confirma exclusão")
                  MENSAGEM ("Um momento ...")
                  SELECT (246)
                  go top
                  LOCATE FOR crypt(alltrim(__CODUSR), "7654321") == alltrim(NOMUSR)
                  if FOUND()
                     TRVREG()
                     DELETE
                     UNLOCK 
                     LOGUSR("Excluiu o usuário " + _NOMUSR)
                     erro ("Usuário excluido com sucesso.")
                  else
                     erro ("Usuário não encontrado.")
                  endif
                  SELECT (248)
                  go top
                  LOCATE FOR crypt(alltrim(__CODUSR), "7654321") == alltrim(NOMUSR)
                  do while FOUND()
                     TRVREG()
                     DELETE
                     UNLOCK
                     go top
                     LOCATE FOR crypt(alltrim(__CODUSR), "7654321") == alltrim(NOMUSR)
                  enddo
               endif
               
          CASE _OPCAO == 2
               _CODUSR := SPACE (24)  
               _NOMUSR := SPACE (24)
               TELPAD ("05200", "Atualizar", 02, 00, 05, 79)
               @ 03, 02 SAY "Qual o nome " GET _NOMUSR PICTURE "@!"
               @ 04, 02 SAY "Qual a senha"
               READ
               IF ESCKEY()
                  LOOP
               ENDIF

               IF ALLTRIM(_NOMUSR) == "ADM"
                  ERRO ("Voce tem de ter acesso a tudo")
                  LOOP
               ENDIF

               _CODUSR := GETSTR (04, 15, "*", 24)

               SELECT (246)
               GO TOP
               LOCATE FOR CRYPT(ALLTRIM(__CODUSR),"7654321") == NOMUSR
               
               IF !found()
                  ERRO ("Não existe este usuário")
                  RETURN
               ENDIF

               MENSAGEM ("Atualizando senha: Usuario = '" + _NOMUSR + "'.")
               ATUSEN   (_NOMUSR)

          CASE _OPCAO == 3
               _CODUSR := SPACE (24)
               _NOMUSR := SPACE (24)
               _NOMUSR2 := SPACE(50)
               _PSSUSR := SPACE(20)
               TELPAD ("05000", "Criar", 02, 00, 06, 79)
               @ 3, 2 SAY "Qual o ID   " GET _NOMUSR PICTURE "@!"
               @ 4, 2 SAY "Nome        " GET _NOMUSR2
               @ 5, 2 SAY "Qual a senha"
               READ
               IF ESCKEY()
                  LOOP
               ENDIF
      
               _PSSUSR := GETSTR (5, 15, "*", 24)

               MENSAGEM("Pesquisando ...")
               SELECT (246)
               NET_USE ("SYSPSS.DBF", .F., 5)
               GO TOP

               DO WHILE !EOF()
                  IF NOMUSR == CRYPT(_NOMUSR, "7654321")
                     TRVREG()
                     RECALL
                     SAVREG()
                     EXIT
                  ENDIF
                  SKIP
               ENDDO

               MENSAGEM ("Criando a senha ...")
               SELECT (250)
               SEL250 := RECNO()
               GOTO TOP

               DO WHILE !EOF()
                  M_CODMEN := CODMEN
                  SELECT (248)
                  CHKREC()
                  REPLACE CODMEN WITH M_CODMEN,;
                          CODUSR WITH CRYPT(ALLTRIM(_NOMUSR), "7654321"),;
                          CODACE WITH CRYPT("SSSSSSSSS", "7654321")
                  SAVREG()
                  SELECT (250)
                  SKIP
               ENDDO
               
               SELECT (246)
               LOCATE FOR CRYPT(ALLTRIM(CODUSR),"7654321") == _NOMUSR
               
               IF FOUND()
                  ERRO ("Usuário já criado")
               ELSE
                  CHKREC()
                  REPLACE CODUSR WITH CRYPT(ALLTRIM(_NOMUSR),  "7654321"),;
                          NOMUSR WITH CRYPT(_NOMUSR2, "7654321"),;
                          PASS   WITH CRYPT(ALLTRIM(_PSSUSR),  "7654321"),;
                          DATCRI WITH DATE()
                  SAVREG()
               ENDIF

               GO     SEL250
               LOGUSR ("Criou o usuario " + _NOMUSR)
               ERRO ("Usuário criado com sucesso")

          CASE _OPCAO = 4
               SELECT (246)
               NET_USE ("SYSPSS.DBF", .F., 5)
               GO TOP
               @ 20, 00 SAY "" 
               DO WHILE !eof()
                  IF ROW()==20
                     TELPAD ("05000", ".", 02, 00, 22, 79)
                     @ 03, 02 SAY "Nome                     Nome completo"
                     @ 04, 00 SAY ""
                  ENDIF
                  @ ROW()+1, 02 SAY crypt(codusr, "7654321") + " " + crypt(nomusr, "7654321")
                  SKIP
                  IF ROW()==20
                     MENSAGEM ("Pressione <Espaço> ...")
                     PAUSA()
                     @ 20, 00 SAY "" 
                  ENDIF  
               ENDDO
               IF ROW() != 20
                  MENSAGEM ("Pressione <Espaço> ...")
                  PAUSA()
               ENDIF

             CASE _OPCAO = 5
                  SYSUSR_LOG := MEMOREAD ("SYSUSR.LOG")
                  @ 02, 00 TO 22, 79
                  SET CURSOR ON
                  SELECT 246
                  DBEDIT(03, 01, 21, 78)
          ENDCASE
    ENDDO
RETURN

*********************************************************************
Function MANIMP
*********************************************************************
    Local Impressoras [Adir("*.PRN")]
    Local M_IMPNOM
    Local __PRN_COMP := SPACE(30)
    Local __PRN_UNCO := SPACE(30)
    Local __PRN_PORT := SPACE(30)
    
   TELPAD ("PRNS", "CONFIGURACAO DE IMPRESSORAS", 10, 10, 20, 69)
   ADir ("*.PRN", Impressoras)
   M_IMPNOM := AChoice (11,11,19,68,Impressoras)
   if M_IMPNOM = 0
      M_IMPNOM = SPACE (20)
   else
      M_IMPNOM = Impressoras [M_IMPNOM]
   endif
   @ 11, 24 say "Impressora    " get M_IMPNOM picture "@!"
   @ 12, 24 say "Compactador   "
   @ 13, 24 say "Descompactador"
   @ 14, 24 say "Porta         "
   if !lerget()
      return
   endif
   if file (M_IMPNOM)
      restore from (M_IMPNOM) additive
   endif
   @ 12, 39 get __PRN_COMP
   @ 13, 39 get __PRN_UNCO
   @ 14, 39 get __PRN_PORT
   if !LERGET()
      return .t.
   endif
   if ASK ("Confirma dados")
      save all like __PRN_* TO (M_IMPNOM)
   endif
return .T.

*********************************************************************
Function FUNDO  
*********************************************************************

PARAMETERS LI,CI,LF,CF,COR  && COORDENADAS
COR := SETCOLOR()
SETCOLOR (SYS_PAPPA1)
@ li, ci clear to lf, cf
SETCOLOR (COR)
RETURN NIL

*********************************************************************
Function GETSTR  && USO INTERNO
*********************************************************************

         PARAMETERS LIN, COL, PIC, SIZ
         Local M_STR, I, CH

         @ LIN, COL SAY SPACE (SIZ)
         M_STR := ""
         I     := 0
         SET CURSOR ON

         DO WHILE .T.

            @ LIN, COL+I SAY ""

            CH := INKEY(0)
            
            DO CASE

               CASE CH == K_ENTER .OR. CH == K_ESC
                    EXIT

               CASE CH == K_BS
                    IF I > 0
                       I--
                       M_STR := LEFT (M_STR, I)
                    ENDIF    

               CASE UPPER(CHR (CH)) $ "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
                    IF I < SIZ
                       M_STR += UPPER(CHR (CH))
                       I++
                    ENDIF

            ENDCASE
            IF PIC == "!"
               @ LIN, COL SAY LEFT (M_STR + SPACE (SIZ), SIZ)
            ELSE
               @ LIN, COL SAY LEFT (REPLICATE (PIC, I) + SPACE (SIZ), SIZ)
            ENDIF
         ENDDO

         SET CURSOR OFF

RETURN LEFT (M_STR + SPACE (SIZ), SIZ)

**********************
function TrocaCaracter 
   parameter p1, p2, p3
   Local i
   Local retorno := ""
   Local aux
   
   for i := 1 to len(p1)
      aux := substr(p1, i, 1)
      if aux == p2
         retorno := retorno + p3
      else
         retorno := retorno + aux
      endif
   next
   
return retorno

*********************************************************************
Function GoogleGeo
*********************************************************************

    PARAMETERS pEndereco
    
    LOCAL oHttp, cHtml, hQuery, oHtmlDoc, oNode, aLink, pEndereco 
    
    THTMLDocument():New("CEP.HTML")
    
    if THTMLDocument():ReadFile( "http://maps.google.com/maps/geo?q=" + pEndereco + "&output=xml&sensor=true_or_false&key=ABQIAAAAKvu9lWky417YGt9ducGe-hTi87jhdSgJhcYeNwoqJkCLFv94hhQGYs_B98_Fx-bw8JC8bZcZA9aK5w")
       erro("Consegui ler o arquivo")
    else
       erro("Nao consegui ler o arquivo")
    endif
    
    //oHttp:writeFile("CEP.XML")
    
    //THTMLDocument():WriteFile("CEP.XML")
    
RETURN .t.

*********************************************************************
Function CodigoRandomico
*********************************************************************

    PARAMETERS pQtdDigitos
    
    Local sRetorno := ""
    Local i
    Local cCharacter
    *Local pQtdDigitos
    
    For i := 1 to pQtdDigitos
       cCharacter := ""
       do while !IsXDigit(cCharacter)
          cCharacter := chr(HB_RandomInt(48,122))
       enddo
       sRetorno := sRetorno + cCharacter
    Next
       
RETURN sRetorno