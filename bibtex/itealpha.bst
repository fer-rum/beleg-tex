%%****************************************
%%*                                      *
%%* TU Dresden                           *
%%* Institut für Technische Informatik   *
%%* 				         *
%%*                                      *
%%****************************************
%%
%% LaTeX-Vorlage fuer Doktor-, Diplom- und Seminararbeiten
%% Formatierung des Literaturverzeichnisses
%%

ENTRY
  { address      %%  Verlagsort
    author       %%  persoenlicher Urheber eines Werkes
    booktitle    %%  a) Gesamttitel eines mehrbaendigen Werkes
    chapter      %%  Kapitel in einem Buch (Monographie)
    edition      %%  Auflagevermerk
    editor       %%  Persoenl.Herausgeber oder Koerperschaftlicher Herausgeber
    howpublished %%  beliebiger Verlegervermerk: von wem, wo
    institution  %%  Institution, die e.Verlagsfreie Veroeffentlichung betreibt
    isbn         %%  Standardnr fuer Buecher
    issn         %%  - " -    :      Zeitschriften u. Serien
    journal      %%  Titel einer Zeitschrift
    key          %%  Zusaetzlich vergebener Sortierschluessel, mitunter notwend.
    month        %%  naehere Bestimmung des Erscheinungsjahres (-> macro 's)
    note         %%  freies Eingabefeld fuer zusaetzliche Informationen
    number       %%  Mehrfachbedeutung in Abhaengigkeit vom Eingabetyp
    organization %%  a) Name der Organisation/des Veranstalters e. Tagung,Konferenz
    pages        %%  Umfangsangaben, meist Seitenzahlen
    publisher    %%  Verlag
    school       %%  Hochschule/Universitaet, die eine Dipl.-Arb./Dissertation veroeff.
    series       %%  Titel e.Reihe, in der ein best. Buchtitel erschienen ist
    title        %%  Titel einer (namentlich gekennzeichneten) Veroeffentlichung
    type         %%  Zusatzfeld z.Kennzeichnung e.besonderen Publikationstyps
    volume       %%  a) Zaehlung bei einem mehrbaendigen Werk (-> book)
    year         %%  Erscheinungsjahr
  }
  {}
  { label extra.label sort.label }

INTEGERS { output.state before.all mid.sentence after.sentence after.block }

%% die folg. BOOLE'sche VAR steuern d. Ausg. ": " nach Urheber-Feldern
%%    und ". - " vor ISBN oder Anmerkungen (NOTE)

INTEGERS { colon.after  period.dash }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
  #4 'colon.after :=
  #5 'period.dash :=
}
INTEGERS { zahl  lang }

STRINGS { h s t u v }

%% neue DIN-Funktion, 16/2/94

FUNCTION {output.nonnull}
{ 's :=
  output.state after.block =
      { add.period$  write$
        newline$
        "\newblock " write$
      }
      { output.state before.all =
          {  write$ }
          {  output.state colon.after =
               { ": " * write$
                 newline$
                 "\newblock " write$
               }
               { output.state period.dash =
                   { ". -- " *  write$
                     newline$
                     "\newblock " write$
                   }
                   { output.state mid.sentence =
                       { ", " * write$ }
                       { write$
                         newline$
                         "\newblock " write$
                       }
                     if$
                   }
                if$
               }
            if$
           }
         if$
         after.block 'output.state :=
       }
     if$
     s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem[" write$
  label write$
  "]{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {fin.entry}   %%$$$  nach DIN neu 16/2/94
{ write$
  newline$
}

FUNCTION {set.period.dash}    %% Wenn ein ". - " die Satzteile trennen soll.!
{ output.state before.all =
    'skip$
    { period.dash  'output.state := }
  if$
}

%%   neu 16/2/94
%%   prueft, ob PAGES, ISBN- oder NOTE-Feld vh. ist und setzt dann ". - " davor.

FUNCTION {set.period.dash.check}
{ empty$
    'skip$
    'set.period.dash
  if$
}

FUNCTION {set.colon.after}   %%$$$ Wenn ein ": " d. Satzteile trennen soll!
{ output.state before.all =
    'skip$
    { colon.after 'output.state  := }
  if$
}

%% neu / alt 17/2/94          Wenn ein " " die Satzteile trennen soll.!
FUNCTION {new.sentence}
{ output.state before.all =
     'skip$
     { after.sentence 'output.state := }
  if$
}

%% neu 17/2/94                 Wenn ein ", " die Satzteile trennen soll.!
FUNCTION { part.of.sentence }
{ output.state before.all =
     'skip$
     { mid.sentence 'output.state := }
  if$
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

INTEGERS { nameptr namesleft numnames }

STRINGS { fkt }

% AG: Diese Funktion und nur diese Funktion bringt eine kursive
% Formatierung ein. Sie wird für alle Tittel verwendet.
FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "\emph{" swap$ * "}" * }
  if$
}

%% neu, setzt Autor/Hrsg. in Kapitaelchen 9/3/94
FUNCTION { capitalize }
 { duplicate$ empty$
    { pop$ "" }
    { "\textsc{" swap$ * "}" * }
  if$
}

%%$$$ DIN-Quellenangabe : spezieller unselbst. Teil ist erschienen "In: "
%%                        dem bibliogr. selbst. Werk, z.B. Zeitschrift, Buch

%% 1/4/96
FUNCTION {article.in.journal}
{ duplicate$ empty$
    { pop$ "" }
    { author missing$
        { title missing$
% Empty Stack Bug behoben, wenn Autor und Titel fehlen 27.08.2000
%            { " " * *}%% wenn ein Zs-Heft als ganzes zitiert wird
            { " " *}%% wenn ein Zs-Heft als ganzes zitiert wird
            { "{In: }" swap$ ", " * * }
          if$
        }
        { "{In: }" swap$ ", " * * }
      if$
     }
  if$
}

%% nach Vorschlag von H.Lueddecke, um Adelspraedikate beim Sortieren
%% nach den(m) Vornamen aufzufuehren. Lo, 2/11/94
%% AG, 22.08.2000: Vornamen werden ab jetzt abgekuertzt
FUNCTION {format.names}
{ 's :=
  "" 'u  :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    {
       s nameptr "{vv~}{ll}" format.name$ 't :=%% das ergibt DIN-Ansetzung
       %% Lue's Vorschlag   s nameptr "{ll}" format.name$ 't :=
       t capitalize 't :=
%%     dinalpha's Vorschlag:  s nameptr "{, ff}" format.name$ 'u :=
       s nameptr "{, f.}" format.name$ 'u :=
       %% Lue's Vorschlag   s nameptr "{, ff}{ vv}" format.name$ 'u :=
       u  text.length$  'lang :=
       #1 'zahl :=
       "" 'v :=
         {  zahl  lang  <  }
         {  u  zahl  #1  substring$  "~"  =
               {  v  ""  =
                     {  u  #1  zahl  #1  -  substring$  'v :=  }
                     'skip$
                  if$
                  v  u  zahl  #2  substring$  *  "."  *  'v :=  }
               'skip$
            if$
            zahl  #1  +  'zahl :=  }
      while$
      v  ""  =
         {  u  'v :=  }
         'skip$
      if$
%%    der string fkt enthaelt " (Hrsg.)", wenn Editorfeld nicht leer ist
      t  v  *  fkt  *  't :=  %% Komma nach Nachnamen wird oben erledigt!
                              %% t enthaelt nun d. formatierten Nnamen, Vnamen
      nameptr #1 >
         { namesleft #1 >
             { "; " * t * }
             { numnames #2 >
                  { "" * }
                  'skip$
               if$
%%                                %% n. schindle's hinweis 12/1/96 erweitert
               t "\textsc{others}" = t "\textsc{others} (Hrsg.)" = or
%%%                  { " [u.~a.]" * }%%   13/2/94
                  { "~et~al." * } %% Geschmackssache, waehle eins von beiden
                    { "; " * t * }
               if$
               }
            if$  %% Ende der namesleft-Pruefung
          }
            't
           %% hierdurch wird bei jed. Schleifendurchgang das sich komplet-
           %% tierende Zwischen-Namensergebnis wieder auf den sdack gelegt

       if$  %%  Ende der nameptr-Pruefung

      nameptr #1 + 'nameptr :=
      namesleft #1 -  'namesleft :=
    }
  while$  %%  Ende von { namesleft #0 > } ganz oben
  "" 'fkt :=  %% fkt wird zurueckgesetzt
}

%%$$$ geaendert 14/2/94

FUNCTION {format.authors}
{ author empty$
    { "" }
    { author format.names }
  if$
}

%%$$$ geaend. 20/2/94 Anpassung an DIN, wonach Autor + Hrsg. zusammen vorkom-
%%                    men duerfen.!!
FUNCTION {format.editors}
{ editor empty$
   { author empty$
       { "Weder Verfasser noch Hrsg. in " cite$ * warning$ }
       'skip$
     if$
    }
    { author empty$
        { " (Hrsg.)" 'fkt :=
          editor format.names
        }
        { " (Hrsg.)" 'fkt :=
          "; " * editor format.names *
        }
      if$
     }
   if$
 }

%% Lo, 12/5/99 neue Funktion fuer proceedings, misc usw.

FUNCTION { format.editors.organization }
{ organization empty$
    'skip$
    { type$ "misc" =
        { organization }
        { "; " * organization " (Veranst.)" *}
      if$
    }
  if$
}

%%$$$  Sonderfall: Herausgeber bei Typ incollection, 21/2/94
%% 10.04.01 AG: Herausgeberschaft werden fett und mit dem einmaligen
%% Verweis Hrsg. gesetzt.
FUNCTION {format.ed.incoll}
{ editor empty$
     { "" }
     { " (Hrsg.)" 'fkt :=
       editor format.names
     }
  if$
}

% Wenn's einen Titel hat, dann kursiv ausgeben. Die Funktion
% format.btitle wird dann ueberfluessig.
FUNCTION {format.title}
{ title empty$
    { "" }
    { title emphasize }
  if$
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
        { t #1 #2 substring$ "--" = not
            { "--" *
              t #2 global.max$ substring$ 't :=
            }
            {   { t #1 #1 substring$ "-" = }
                { "-" *
                  t #2 global.max$ substring$ 't :=
                }
              while$
            }
          if$
        }
        { t #1 #1 substring$ *
          t #2 global.max$ substring$ 't :=
        }
      if$
    }
  while$
}

%% geaendert 24/2/94
FUNCTION {format.date}
{ year empty$
    { month empty$
        { "" }
        { "there's a month but no year in " cite$ * warning$
          month
        }
      if$
    }
    { month empty$  %% b. Buechern nur Jahr, ohne Monat ausgeb. im Impressum
          'year
          { month "/" * year * }
      if$
    }
  if$
}

%%
%%$$$  neue Fkt., 16/2/94 u. 14/3/94       das sog. Impressum
FUNCTION {format.address.publisher.year}

      {  publisher empty$
         { address empty$
           { year empty$
              { "" }
              { year }
              if$
           }
           { "Es gibt einen Verlagsort, aber keinen Verlag in " cite$ * warning$
                  address ", " * format.date *
           }
           if$ %Ende address empty$ (Zeile 501)
        }
        { address empty$
          { year empty$
             { "Es gibt nur eine Verlagsangabe aber keine Jahreszahl in " cite$ * warning$
                publisher
             }
             { publisher ", " * format.date * }
             if$ %Ende year empty$ (Zeile 513)
          }
          { year empty$
              { address ": " * publisher * }
              { address ": " * publisher * ", " * format.date * }
              if$ %Ende year empty(Zeile 520)
          }
          if$ %Ende address empty$ (Zeile 512)
        }
        if$ %Ende address empty$ (Zeile 501)
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #10 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

%% neu 8/3/94 in dieser Funkt. steckt im volume empty-Teil noch ein bug, der
%%            aber ignoriert werden kann; das Ergebnis ist ok.
FUNCTION {format.btitle.vol}
{ number empty$
   { series empty$
     { volume empty$
        { title emphasize }
        { title " (Band"  * volume tie.or.space.connect ")" * emphasize }
       if$
     }
     { volume empty$
        { title emphasize }%% ein Buch, das zusaetzl. SERIES=Reihentitel besitzt
    %% jetzt kommt d. Fall des mehrbaendigen Werkes mit Gesamttitel=SERIES
    %% Zaehlung=VOLUME und Bandtitel=TITLE;
        { series emphasize ". Band" * volume tie.or.space.connect
                                 ": " * title * emphasize }
       if$
     }
     if$%% series-test
   }
   { title emphasize }%% wenn number ex., dann immer title-Feld
  if$%% Ende number-test
}

%%$$$ neu 16/2/94
%%   Serien- / Reihentitel werden im Feld series gespeichert. Weist die
%%   Serie eine Zaehlung der Einzeltitel auf, gibt man entweder nach DIN alles
%%   in das Feld series so ein: ---> TITEL DER SERIE  NR. (der Vorlage) <---
%%   z. B.  SERIES= { Mensch und Computer 12 }.
%%   [ Die Nummer der Vorlage darf auch durch "; " abgesetzt werden. ]
%%   oder:
%%   man gibt die Zaehlung in das Feld NUMBER ein, z.B. NUMBER = {12}.
%%   Achtung!!
%%   Bei mehrbaendigen Werken steht d. Gesamttitel im Feld SERIES und die
%%   Bandzaehlung im Feld VOLUME; NUMBER darf dann nicht besetzt sein!
%%   Anderenfalls liegt ein Erfassungsfehler vor, da sich Reihe u. mehrbd.
%%   Werk gegenseitig ausschliessen.
%%   AG: Die hier eingefuegten oeffnenden und schliessenden Klammern kommen weg.
%%
FUNCTION {format.series.number.din} {
  volume empty$
    { number empty$
          { series empty$
               { "" }%%   Ausstieg mit Nullstring
               { "" series * "" * } %% d. Seriennr koennte auch gleich hier
                                      %% im SERIES-Feld miterfasst werden
            if$ %%Ende von series empty$
          }
          { series empty$
               { "" number tie.or.space.connect "" *
                 "there's a number but no series in " cite$ * warning$
               }
               { "" series * number tie.or.space.connect "" * }
            if$ %% Ende von Series empty$
          }
       if$ %%Ende von number empty$
     }
     { series empty$
          %% Kein Serientitel angegeben -> Nullstring
          { "" }
          %% Serientitel vorhanden
          { type empty$
            %% kein Typ angegeben, nur VOLUME oder NUMBER erlaubt
            { number empty$
              %% laufende Nummer nicht vorhanden -> alles ok
               { "" series * "" *}
               %% VOLUME und NUMBER vorhanden -> Fehlermeldung
               %% nur Ausgabe der Serie
               { "" series * "" *
                 "VOLUME und NUMBER sind nur für TYPE Proceedings in " cite$ *
                 " gleichzeitig erlaubt." * warning$
               }
               if$ %%Ende von number empty$ (Zeile 605)
             }
             %% Typ vorhanden
             { type "proceedings" =
               %% Type entspricht Proceedings
               %% -> es sind Werte für VOLUME und NUMBER erlaubt
               { number empty$
                 %% laufende Nummer ist nicht vorhanden
                 { "" series * "" *}
                 %% laufende Nummer ist vorhanden -> mit ausgeben
                 { "" series * number tie.or.space.connect "" *}
                 if$ %% Ende number empty$ (Zeile 619)
               }
               %% Type entspricht nicht Proceedings
               %% es darf nur im Feld Number oder im Feld VOLUME
               %% etwas verzeichnet sein
               { number empty$
                 %% laufende Nummer nicht vorhanden -> alles ok
                 { "" series * "" *}
                 %% VOLUME und NUMBER vorhanden -> Fehlermeldung
                 %% nur Ausgabe der Serie
                 { "" series * "" *
                   "VOLUME und NUMBER sind nur für TYPE Proceedings in "  cite$
                   * "gleichzeitig erlaubt." * warning$
                 }
                 if$ %%Ende von number empty$ (Zeile 629)
               }
               if$ %%Ende von type "proceedings" = (Zeile 601)
             }
             if$ %% Ende von type empty$ (Zeile 603)
           }  
       if$ %%Ende von series empty$ (Zeile 599)
      }    
  if$ %% Ende von volume empty (Zeile 582)
}

%Falls Series angegeben wurde, wird ein Komma auf dem Stack hinterlegt
FUNCTION {set.comma.after.series} {
  series empty$
    'skip$
    { part.of.sentence }
  if$
}

%% seltener Fall bei MISC: Ausgabe einer Serie; die Nummer der Serie muss
%%  in SERIES miterfasst werden  16/6/99

FUNCTION {format.misc.series}
{ series empty$
    { "" }
    { "(" series * ")" * }
  if$
}

%%$$$ 16/2/94
%%  Auflagenvermerke gibt man komplett, einschliesslich Abkuerzungen in
%%  das Feld edition ein: ---> EDITION= { 3., erw. und verb. Aufl. }
%%  oder fremdsprachlich:      EDITION= { 2nd edition }

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { edition }
  if$
}

%%$$$ neu, 18/3/94
FUNCTION { format.isbn.issn }
{ isbn empty$
     { issn empty$
          { "" }
          { "ISSN" issn n.dashify tie.or.space.connect }
       if$
     }
     { "ISBN" isbn n.dashify tie.or.space.connect }
  if$
}

%%$$$ geaendert, 21/2/94  gibt Seitenzahl bei BOOK-Typ und verwandten T. aus
FUNCTION {format.pages.book}
{ pages empty$
    { "" }
    { "" pages n.dashify tie.or.space.connect " S" *} %% 17/12/95
  if$
}

%%$$$  alle anderen Seitenang. zB. Zeitschrft., INBOOK usw. a la Orig., 9/3/94
FUNCTION {format.pages}
{ pages empty$
    { "" }
    { "S." pages n.dashify tie.or.space.connect }
  if$
}

%%    Angaben v. Jahrgang, Jahr, Heftnr., Seiten bei Artikel-Typ
%%    14/3/94, 26/2/97

FUNCTION {format.vol.year.num.pages}
{ 
    volume empty$
      { "" }
      { "Vol. " volume * }
    if$
    number empty$
      'skip$
      { "{\#}" number * tie.or.space.connect }
    if$
    year empty$
      { "Es gibt einen Jahrgang, aber kein Jahr in " cite$ * warning$ }
      { 
	"(" 
        month empty$
          'skip$
          { month "/" * * }
        if$
	year * ")" * tie.or.space.connect 
      }
    if$
    pages empty$%%  Lo, 26/2/97
      'skip$
      { ", " format.pages * *}%%
    if$
}

%% geaendert 21/2/94
FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
        { "Kapitel " }
        { type }
      if$
      chapter tie.or.space.connect
      pages empty$
        'skip$
        { ", " * format.pages * }
      if$
    }
  if$
}

%%$$$  geaendert 21/2/94
FUNCTION {format.in.ed.booktitle.din}
{ booktitle empty$
    { "" }
    { editor empty$
        { volume empty$
            { "{In: }" booktitle emphasize * }%% n. Belieben fettes In:
            { "{In: }" booktitle emphasize *  %%      - " -
              " Band" volume tie.or.space.connect *
            }
          if$
        }
        { volume empty$
            { "{In: }" format.ed.incoll * ": " * booktitle emphasize * }
            { "{In: }" format.ed.incoll * ": " * booktitle emphasize *
              " Band" volume tie.or.space.connect *
            }
          if$
        }
      if$
    }
  if$
}

%% geaendert 1/3/94
FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type
    }
  if$
}

%% geaendert 23/2/94    i.Orig. wird zuerst die number, dann der type getestet
%% Geaendert (28.06.2000): tie.or.space.connect ersetzt durch einfache
%% Leerzeichen, da sonst unmittelbar nach der öffnenden Klammer ein Leerzeichen
%% stand.
FUNCTION {format.tr.number.din}
{ type empty$
   { number empty$
      { "Forschungsbericht" }   %%  bei Minimalangaben besser ohne "."!
      % You can't pop from Literal empty stack
      { "Forschungsbericht " number * }
      if$
   }
   { number empty$
       { type }             %%  bei Minimalangaben besser ohne "."!
      % You can't pop from Literal empty stack
       { type " " * number * }
       if$
   }
  if$
}

FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
        { "need key or journal for " cite$ * " to crossref " * crossref *
          warning$
          ""
        }
        { "{In: }{\em " journal * "}" * }%%
      if$
    }
    { "{In: }" key * }%%
  if$
  "{\cite{" * crossref * "}" * "}" * ", " * format.pages *
}

%%geaendert 7/3/94 und noch einmal nach Lueddecke, s.o.
FUNCTION {format.crossref.editor}
 { editor #1 "{ll}" format.name$ " (Hrsg.)" *
   editor num.names$ duplicate$
   #2 >
    { pop$ " [u.\,a.]" * }
%%    { pop$ " et~al." * }
    { #2 <
        'skip$
        { editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
            { " [u.\,a.]" }
%%          { " et~al." * }
            { "; " * editor #2 "{vv~}{ll}" format.name$ * " (Hrsg.)" * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      "{\texttt{siehe}} "
%%      "(siehe "
    }
    { ". -- Band" volume tie.or.space.connect
      " von " *
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { series empty$
            { "need editor, key, or series for " cite$ * " to crossref " *
              crossref * warning$
              "" *
            }
            { "" * }%% dadurch kommt nach der Bandzaehl. gleich das label 2/6/99
          if$
        }
        { key * }
      if$
    }
    { "" * }%% nach der Bandzaehlung kommt gleich das label; Lo 2/6/99
%%    { format.crossref.editor * }
  if$
  "{\cite{" * crossref * "}" * "}" *
%%  "{\cite{" * crossref * "}" * "}" * %%"), " * format.pages *
}

%% AG: Fuer meine Begriffe soll bei angegebener Referenz nur
%% ein In: plus Zitierschluessel generiert werden!
%% Falls zusaetzlich zur Crossref noch ein Buchtitel oder ein Editor
%% angegeben wurde, wird eine Warnung ausgegeben, dass diese Angaben
%% nicht exportiert werden.
%%FUNCTION {format.incoll.inproc.crossref} {
%%  "In: {\cite{" crossref * "}" * "}" * ", " * format.pages *
%%  booktitle empty$
%%    'skip$
%%    { "Fuer den Eintrag " cite$ * " wurde eine Crossreference und ein " *
%%      "Buchtitel angegeben. Der Buchtitel wird ignoriert." * "(" * booktitle * ")" * warning$
%%    }
%%  if$
%%  editor empty$
%%    'skip$
%%    { "Fuer den Eintrag " cite$ * " wurde eine Crossreference und ein " *
%%      "Editor angegeben. Der Editor wird ignoriert." * warning$
%%    }
%%  if$
%%}

FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { booktitle empty$
            { "need editor, key, or booktitle for " cite$ * " to crossref " *
              crossref * warning$
              ""
            }
            { "{In: }" booktitle * emphasize }%%  fettes In: n. Belieben
          if$
        }
        { "{In: }" }%% 26/5/99
      if$
    }
    { "{In: }" }%% Lo, 10/2/99 es sieht der reine Bezug (Referenz) besser aus!
  if$
  "{\cite{" * crossref * "}" * "}" * ", " * format.pages *
}

%%geaendert
FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  set.colon.after
  format.title "title" output.check
  crossref missing$
    { journal article.in.journal output.nonnull %   26/2/97
      new.sentence
      format.vol.year.num.pages output
    }
    { format.article.crossref output.nonnull }
  if$
   note set.period.dash.check
   note output
   issn set.period.dash.check
   format.isbn.issn output
   fin.entry
}

%%$$$   geaendert, 20/2/94
%% Entgegen den TeX-Regeln verlangt die DIN Norm eine Auflagennummer für jedes
%% Buch. Dies wurde jedoch wieder zurückgenommen. Somit gelten die TeX-Regeln
%% wieder.
FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors  format.editors output.nonnull }
  if$
  set.colon.after
  format.title "title" output.check
  format.series.number.din output
  set.comma.after.series
  %AG: Nur bei angegebener Edition, setzen wir ein Komma danach ein
  edition empty$ 
    'skip$
    { format.edition output.nonnull
      part.of.sentence }
  if$
  format.address.publisher.year "publisher" output.check
  new.sentence

%% AG: Nach meinem Dafuerhalten sollten ein Buch keine Crossreferenz haben!
%%  crossref missing$
%%    { format.series.number.din  output
%%      pages set.period.dash.check%%  19/5/99 wie bei adinat.bst
%%      format.pages.book output
%%    }
%%    { format.book.crossref output.nonnull
%%      pages set.period.dash.check
%%      format.pages.book output
%%    }
%%  if$
  note set.period.dash.check
  note output
  isbn set.period.dash.check
  format.isbn.issn output
  fin.entry
}

%% geaendert 23/2/94
FUNCTION {inbook}
{ output.bibitem
%% unselbst. Teile eines Buches werden am Anf. genannt, dann d selbst. Quelle
  chapter empty$
    { "Es fehlen die Kapitelangaben in " cite$ * warning$ }
    { type empty$
         { "Kap. " output }%%  d.i. die Standardvorgabe
         { type output}%%  wenn man keine bes. Typform angeben will, koennte ein kl.
%%                   Zwischenraum gewaehlt werden, z.B. " \, "
         if$
    }
  if$
  chapter tie.or.space.connect " {In: }" * %% n. Belieben fettes In:
%%   -------- jetzt kommt der bibliogr. selbst. Teil
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull}
  if$
  set.colon.after
  format.btitle.vol "title" output.check
  crossref missing$
    { 
      format.edition output
      format.address.publisher.year "publisher" output.check
      new.sentence
      format.series.number.din output
% %% vorher note..
      part.of.sentence 
%% nach Texregeln sind die Seitenzahlen nicht zwingend
      format.pages output
%%      format.pages  "pages" output.check
      note set.period.dash.check
      note output
    }
    {
      format.book.crossref output.nonnull
      note set.period.dash.check
      note output      
    }
  if$
  isbn set.period.dash.check
  format.isbn.issn output
  fin.entry
}

%%  geaenderte Seitenzahlausgabe, wenn crossref-Feld benutzt wird, 27/2/97
FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  set.colon.after
  format.title "title" output.check
  crossref missing$
     { format.in.ed.booktitle.din "booktitle" output.check
       format.edition output
       format.series.number.din output
       set.comma.after.series
       format.address.publisher.year "publisher" output.check
       new.sentence
       note set.period.dash.check
       note output
       isbn set.period.dash.check
       issn set.period.dash.check
       format.isbn.issn output
       part.of.sentence
% %% Nach texregeln sind die Seitenangaben nicht zwingend
       format.chapter.pages output
% %%      format.chapter.pages "pages" output.check
     }
     { format.incoll.inproc.crossref output.nonnull
       note set.period.dash.check
       note output
       isbn set.period.dash.check
       issn set.period.dash.check
       format.isbn.issn output
     }
     if$
 fin.entry
}

%%  geaendert 22/2/94, 15/11/96 (Hinweis v. Alin Shindun, Uni Siegen)
FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  set.colon.after
  format.title "title" output.check
  crossref missing$
    { format.in.ed.booktitle.din "booktitle" output.check
      address empty$
        { organization new.sentence.checka
          organization output
          part.of.sentence
          format.address.publisher.year "year" output.check
        }
        { format.address.publisher.year "year" output.check}
      if$
      new.sentence
      series empty$ %%neu nach Hinweis v. Alin Shindun, 15/11/96
        'skip$
        { format.series.number.din output }
      if$
      note set.period.dash.check
      note output
      isbn set.period.dash.check
      issn set.period.dash.check
      format.isbn.issn output
      part.of.sentence
      format.pages output
    }
    { format.incoll.inproc.crossref output.nonnull
      note set.period.dash.check
      note output
      isbn set.period.dash.check
      issn set.period.dash.check
      format.isbn.issn output
    }
    if$
 fin.entry
}

FUNCTION {conference} { inproceedings }%% nach Patashnik, wg US-Kompatibilitaet

%% geaendert, 11/6/99
FUNCTION {manual}
{ output.bibitem
  author empty$
    { organization empty$
        { title empty$
            'skip$
            {format.title "title" output.check }
          if$
        }
        { organization output.nonnull
          set.colon.after
          format.title "title" output.check
        }
      if$
    }
    { format.authors output.nonnull
      set.colon.after
      format.title "title" output.check
    }
  if$
%% Nach Texregeln ist die Auflage nicht gefordert
  format.edition output
%%  format.edition "edition" output.check
  author empty$
    { organization empty$
        { address output
          part.of.sentence
        }
        'skip$
      if$
    }
    { address ": " *  organization * output
      part.of.sentence
    }
  if$
  format.date output
  pages set.period.dash.check
  format.pages.book output
  note set.period.dash.check
  note output
  fin.entry
}

%%  Ausgabe-Standard ist "Diplomarbeit", fuer andere Abschlussarbeiten
%%  bei der Erfassung TYPE="anderer Typ" eingeben.
%%  z.B. TYPE={Dissertation}, TYPE={Diss.}, TYPE={Habil.}, TYPE={Magisterarb.}
%%
FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  set.colon.after
  format.title "title" output.check
  address output
  part.of.sentence
  school "school" output.check
  part.of.sentence
  "Diplomarbeit" format.thesis.type output.nonnull
  part.of.sentence
  format.date "year" output.check
%%  pages new.sentence.checka
  pages set.period.dash.check
  format.pages.book output
  note set.period.dash.check
  note output
  fin.entry
}

%% Dissertationen
FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  set.colon.after
  format.title "title" output.check
  address output
  part.of.sentence
  school "school" output.check
  part.of.sentence
  "Dissertation" format.thesis.type output.nonnull
  part.of.sentence
  format.date "year" output.check
%%  pages new.sentence.checka
  pages set.period.dash.check
  format.pages.book output
  note set.period.dash.check
  note output
  fin.entry
}

%% hiermit werden u.a. Normen erfasst
FUNCTION {misc}
{ output.bibitem
  note empty$
     { title empty$
%% Stack isn't empty bug (CK)
         { "" output}
%%       { "" }
%% Naechste Zeile verursacht einen Stack isn't empty bug, 
%% falls kein Autor angegeben wurde
%%          {format.authors format.editors output.nonnull
%% Stack isn't empty bug (AG) mit den Zeilen aus book behoben
        {author empty$
          {editor empty$
            { "" output} 
            {format.editors "author and editor" output.check }
          if$}
          { format.authors  format.editors output.nonnull }
        if$

           set.colon.after
           format.title output
           howpublished output
           part.of.sentence
           format.date output
          }
        if$ %%title empty
     }
%% Hier wird geprüft, ob die Anmerkung mit 'Norm' beginnt
     {note duplicate$ #1 #4 substring$ "Norm" =
             %% Anmerkung beginnt mit 'Norm'
            {output new.sentence
             format.date output
             format.title output
            }
             %% Anmerkung beginnt nicht mit 'Norm'
%% Stack isn't empty bug (CK)
            {output pop$ ""
%%            {pop$ ""
              author empty$
                %% Tag Autor frei
                { editor empty$
                  %% Tag Herausgeber leer
                  { organization empty$
                    %%Tag Organization frei
                    { 'skip$ }
                    %%Tag Organization belegt
                    { format.editors.organization output.nonnull
                      set.colon.after }
                    if$ %%organization empty
                  }
                  %% Tag Herausgeber belegt
                  { format.editors format.editors.organization output.nonnull
                    set.colon.after }
                 if$ %%editor empty
                }
                %% Tag Autor belegt
                { format.authors format.editors output.nonnull
                  set.colon.after
                }
              if$ %%author empty
              format.title output
              howpublished output
              format.date output
              new.sentence
              format.misc.series output%%  neu 16/6/99
              note set.period.dash.check
              note output
           }
      if$ %%note duplicate ...
    }
  if$ %% note empty
  fin.entry
}

%%FUNCTION {booklet} {misc}%% booklet ist nach dt. Vorgehensweise oft ueberfluessig
FUNCTION {booklet}
{ output.bibitem
  format.authors output
  format.title "title" output.check
  howpublished output
  address output
  format.date output
  note output
  fin.entry
}

%% geaendert 21/5/99
FUNCTION {proceedings}
{ output.bibitem
    editor empty$
      { organization empty$
           { "" output}
           { organization " (Veranst.)" * output }
        if$
      }
      { format.editors format.editors.organization output.nonnull }
    if$
  set.colon.after
  format.title "title" output.check
  format.series.number.din output.nonnull
  set.comma.after.series
  volume empty$
    { "" output.nonnull }
    { "{\textnormal{Band}}" volume tie.or.space.connect "volume" output.check }
  if$
  format.address.publisher.year "year" output.check
  new.sentence
  pages set.period.dash.check
  format.pages.book output
  note set.period.dash.check
  note output
  isbn set.period.dash.check
  issn set.period.dash.check
  format.isbn.issn output
  fin.entry
}

%% geaendert 23/2/94 auch fuer Firmenschriften u."a. zu benutzen
FUNCTION {techreport}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors  format.editors output.nonnull }
  if$
  set.colon.after
  format.title "title" output.check
  institution empty$
     'skip$
     { institution output.nonnull 
       part.of.sentence }
  if$
  format.tr.number.din "number" output.check
  part.of.sentence
  format.address.publisher.year "year" output.check
  number new.sentence.checka
% AG: Jetzt direkt nach dem Titel
%  format.tr.number.din "number" output.check
  %%  new.sentence
  pages set.period.dash.check
  format.pages.book output
%% Nach Texregeln ist die Anmerkung nicht zwingend
  note output
%%  note "note" output.check
  isbn set.period.dash.check
  issn set.period.dash.check
  format.isbn.issn output
  fin.entry
}

FUNCTION {unpublished} {misc}%% author, title, note muessen sein! howpublished
%%                           %% entfaellt natuerlich
FUNCTION {default.type} { misc }

MACRO {jan} {"Januar"}

MACRO {feb} {"Februar"}

MACRO {mar} {"M{\^^b a}rz"}
%% nach Bernd Raichle, Febr. 1999

MACRO {apr} {"April"}

MACRO {mai} {"Mai"}

MACRO {may} {"Mai"}

MACRO {jun} {"Juni"}

MACRO {jul} {"Juli"}

MACRO {aug} {"August"}

MACRO {sep} {"September"}

MACRO {okt} {"Oktober"}

MACRO {oct} {"Oktober"}

MACRO {nov} {"November"}

MACRO {dez} {"Dezember"}

MACRO {dec} {"Dezember"}

%%  stillgelegte Beispiele fuer den Gebrauch von Kuerzeln (hier Zs-Titel).

%%MACRO {acmcs} {"ACM Computing Surveys"}

%%MACRO {acta} {"Acta Informatica"}

%%MACRO {cacm} {"Communications of the ACM"}

%%MACRO {ibmjrd} {"IBM Journal of Research and Development"}

%%MACRO {ibmsj} {"IBM Systems Journal"}

%%MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

%%MACRO {ieeetc} {"IEEE Transactions on Computers"}

%%MACRO {ieeetcad}
%% {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

%%MACRO {ipl} {"Information Processing Letters"}

%%MACRO {jacm} {"Journal of the ACM"}

READ

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

INTEGERS { et.al.char.used }

FUNCTION {initialize.et.al.char.used}
{ #0 'et.al.char.used :=
}

EXECUTE {initialize.et.al.char.used}

FUNCTION {format.lab.names}
{ 
's :=
   s num.names$ 'numnames :=
   numnames #1 =
      % Genau ein Autor
      {s #1 "{ll}" format.name$ #4 text.prefix$}
      'skip$
   if$
   numnames #2 =
      %Genau zwei Autoren
      {s #1 "{ll}" format.name$ #2 text.prefix$ s #2 "{ll}" format.name$ #2
      text.prefix$ *}
      'skip$
   if$
   numnames #2 >
      %Mehr als zwei Autoren
      {s #1 "{ll}" format.name$ #3 text.prefix$ "$^+$" *}
      'skip$
   if$
% 's :=
%   s num.names$ 'numnames :=
%   numnames #1 >
%     { numnames #4 >
%         { #3 'namesleft := }
%         { numnames 'namesleft := }
%       if$
%       #1 'nameptr :=
%       ""
%         %% Eingangsbedingung für Whileschleife
%         { namesleft #0 > }
%         { nameptr numnames =
%             { s nameptr "{ff }{vv }{ll}{ jj}" format.name$ "others" =
% %%              { "\," *  %% kein besonderes Zeichen fuer "others" i. label
%                 { "{\etalchar{+}}" *   %% ein plus-Zeichen (+) fuer "others"!
%                   #1 'et.al.char.used :=
%                 }
% %%              { s nameptr "{v{}}{l{}}" format.name$ * }
%                 { s nameptr "{l{}}" format.name$ * }
%               if$
%             }
% %%          { s nameptr "{v{}}{l{}}" format.name$ * }
%             { s nameptr "{l{}}" format.name$ * }
%           if$
%           nameptr #1 + 'nameptr :=
%           namesleft #1 - 'namesleft :=
%         }
%       while$
%       numnames #4 >
% %%        { "\," *  %%  s. Bemerkung oben
%         { "{\etalchar{+}}" *
%           #1 'et.al.char.used :=
%         }
%         'skip$
%       if$
%     }
% %%  { s #1 "{v{}}{l{}}" format.name$
%     { s #1 "{l{}}" format.name$
%       duplicate$ text.length$ #2 <
%         { pop$ s #1 "{ll}" format.name$ #4 text.prefix$ } %%  vgl. Anmerkung!
%         'skip$
%       if$
%     }
%   if$
}
%% Anmerkung, Lo 14/12/95:
%% wenn man in der letzten label-Bearbeitung #4 statt #3 setzt, dann werden
%% auch Umlaute oder á an 3. Stelle im Namen korrekt in das label genommen.
%% Tip: Aendere diese Zahl nur, wenn in einer Lit.-Liste der Umlautsonderfall
%% stoerend auffaellt.

FUNCTION {author.key.label}
{ author empty$
    { key empty$
        { cite$ #1 #3 substring$ }
        { key #4 text.prefix$ }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.editor.key.label}
{ author empty$
    { editor empty$
        { key empty$
            { cite$ #1 #3 substring$ }
            { key #4 text.prefix$ }
          if$
        }
        { editor format.lab.names }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.key.organization.label}
{ author empty$
    { key empty$
        { organization empty$
            { cite$ #1 #3 substring$ }
            { "The " #4 organization chop.word #3 text.prefix$ }
          if$
        }
        { key #4 text.prefix$ }
      if$
    }
    { author format.lab.names }
  if$
}
%% neu 19/5/99 damit eigene labels fuer Konferenzen erzeugt werden koennen,
%%             darf man zusaetzlich auch ein key-Feld eingeben. Das produziert
%%             dann vorrangig das label.
FUNCTION {editor.key.organization.label}
{ editor empty$
    { key empty$
        { organization empty$
            { cite$ #1 #3 substring$ }
            { "The " #4 organization chop.word organization } %% Lo, 26/1/98
%%          { "The " #4 organization chop.word #3 text.prefix$ }
          if$
        }
        { key #5 text.prefix$ }%%  man kann Laenge des key einstellen
      if$
    }
    { key empty$%%  wenn key vh., dann macht er das label! Lo,18/5/99
        { editor format.lab.names }
        { key #5 text.prefix$ }
      if$
    }
  if$
}

FUNCTION {calc.label}
{ type$ "book" =
  type$ "inbook" =
  type$ "misc" =
  or
  or
    'author.editor.key.label
    { type$ "proceedings" =
        'editor.key.organization.label
        { type$ "manual" =
            'author.key.organization.label
            'author.key.label
          if$
        }
      if$
    }
  if$
  duplicate$
  year field.or.null purify$ #-1 #2 substring$
  *
  'label :=
  year field.or.null purify$ #-1 #4 substring$
  *
  sortify 'sort.label :=
}

FUNCTION {sort.format.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
        { "   " * }
        'skip$
      if$
      s nameptr "{ll{ }}{  ff{ }}{ vv{ }}{  jj{ }}" format.name$ 't :=
      nameptr numnames = t "others" = and
        { "[u.~a.]" * }
         %%             { "et al" * }% Geschmackssache
        { t sortify * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "Der " #4
        "Die " #4
          "Das " #4
            "Ein " #4
              "Eine " #5
                  "The " #4 t chop.word
               chop.word
             chop.word
           chop.word
         chop.word
       chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {author.sort}
{ author empty$
    { key empty$
        { "to sort, need author or key in " cite$ * warning$
          ""
        }
        { key sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.editor.sort}
{ author empty$
    { editor empty$
        { key empty$
            { "to sort, need author, editor, or key in " cite$ * warning$
              ""
            }
            { key sortify }
          if$
        }
        { editor sort.format.names }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.organization.sort}
{ author empty$
    { organization empty$
        { key empty$
            { "to sort, need author, organization, or key in " cite$ * warning$
              ""
            }
            { key sortify }
          if$
        }
        { "The " #4 organization chop.word sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {editor.organization.sort}
{ editor empty$
    { organization empty$
        { key empty$
            { "to sort, need editor, organization, or key in " cite$ * warning$
              ""
            }
            { key sortify }
          if$
        }
        { "The " #4 organization chop.word sortify }
      if$
    }
    { editor sort.format.names }
  if$
}

FUNCTION {presort}
{ calc.label
  sort.label
  "    "
  *
  type$ "book" =
  type$ "inbook" =
  or
    'author.editor.sort
    { type$ "proceedings" =
        'editor.organization.sort
        { type$ "manual" =
            'author.organization.sort
            'author.sort
          if$
        }
      if$
    }
  if$
  *
  "    "
  *
  year field.or.null sortify
  *
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {presort}

SORT

STRINGS { longest.label last.sort.label next.extra }

INTEGERS { longest.label.width last.extra.num }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #0 int.to.chr$ 'last.sort.label :=
  "" 'next.extra :=
  #0 'longest.label.width :=
  #0 'last.extra.num :=
}

FUNCTION {forward.pass}
{ last.sort.label sort.label =
    { last.extra.num #1 + 'last.extra.num :=
      last.extra.num int.to.chr$ 'extra.label :=
    }
    { "a" chr.to.int$ 'last.extra.num :=
      "" 'extra.label :=
      sort.label 'last.sort.label :=
    }
  if$
}

FUNCTION {reverse.pass}
{ next.extra "b" =
    { "a" 'extra.label := }
    'skip$
  if$
  label extra.label * 'label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
  extra.label 'next.extra :=
}

EXECUTE {initialize.longest.label}

ITERATE {forward.pass}

REVERSE {reverse.pass}

FUNCTION {begin.bib}%%lt. Original wiederhergestellt 4/1/96
{ et.al.char.used
    { "\newcommand{\etalchar}[1]{$^{#1}$}" write$ newline$ }
    'skip$
  if$
  preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{"  longest.label  * "}" * write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}

