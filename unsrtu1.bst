%%
%% This is file `plainu.bst',
%% ukrainian/russian style 
%% attempting to format bibliography 
%% according GOST 7.1-84 
%% and current Ukrainian requirements 
%% for scientific reports/dissertations.
%%
%% For the Russian/Ukrainian bibliographic entries 
%% you need to create field 
%% language = {ukrainian|russian}.
%% Default language is English.
%% Field numpages for books must contain number of pages.
%% Optional field url will format url (using hyperref, if loaded).
%%
%% See examples in test.bib 
%%
%% Requires 8-bit bibtex with switch -B and csf file supporting cyrillic.
%% bibtex8 -B -c <encoding>.csf <your_document>
%% 
%% Copyright 1996-2003 Maksym Polyakov.                          
%% Version 2003.04.24 
%% This file can be redistributed and/or modified                
%% under the terms of the LaTeX Project Public License (lppl).   
%% Please, send bug reports via e-mail:                          
%%   polyama@auburn.edu                                          
%%   mpoliak@i.com.ua                                            

ENTRY
  { address
    author
    booktitle
    chapter
    edition
    editor
    howpublished
    institution
    journal
    key
    month
    note
    number
    organization
    pages
    numpages
    publisher
    school
    series
    title
    type
    volume
    year
    language
    url
  }
  {}
  { label }

INTEGERS { output.state before.all mid.sentence after.sentence after.block
after.dblslash after.slash after.column }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
  #4 'after.dblslash :=
  #5 'after.slash :=
  #6 'after.column :=
}

STRINGS { s t }

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block =
        { add.period$ write$
%          " " quote$ "--- " * *  write$
          " " " " "--- " * *  write$
          newline$
          "\newblock " write$
        }
        { output.state before.all =
            'write$
            { output.state after.dblslash =
                { "~// " * write$ }
                { output.state after.slash =
                    { "~/ " * write$ }
                    { output.state after.column =
                       { ": " * write$ }
                       { add.period$ " " * write$ }
                    if$
                  }
                  if$
                }
              if$
            }
          if$
        }
      if$
      mid.sentence 'output.state :=
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

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.dblslash}
{ output.state before.all =
    'skip$
    { after.dblslash 'output.state := }
  if$
}

FUNCTION {new.slash}
{ output.state before.all =
    'skip$
    { after.slash 'output.state := }
  if$
}

FUNCTION {new.column}
{ output.state before.all =
    'skip$
    { after.column 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
        'skip$
        { after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {add.blank}
{ " " * before.all 'output.state :=
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

FUNCTION {non.stop}
{ duplicate$
   "}" * add.period$
   #-1 #1 substring$ "." =
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
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

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "\emph{" swap$ * "}" * }
  if$
}

FUNCTION {space.word}
{ " " swap$ * " " * }


%FUNCTION {bbl.and}     %  { "\bbland{}"}
%{  language empty$
%    {"and"}
%    { language "ukrainian" =
%        {"{\cyr\cyrt\cyra}"}
%        { language "russian" =
%           {"{\cyr\cyri}"}
%           {"language is not defined: " language * warning$ "and"}
%         if$}
%      if$}
%  if$
%}
FUNCTION {bbl.editors} %  { "\bbleds{}" }
{  language empty$
    {"eds."}
    { language "ukrainian" = language "russian" = or
        {"{\cyr\cyrr\cyre\cyrd.}"}
        {"language is not defined: " language "eds" * * warning$ "eds"}
      if$}
  if$
}
FUNCTION {bbl.editor}  %  { "\bbled{}" }
{  language empty$
    {"ed."}
    { language "ukrainian" = language "russian" = or
        {"{\cyr\cyrr\cyre\cyrd.}"}
        {"language is not defined: " language *  "ed" * warning$ "ed."}
      if$}
  if$
}
%FUNCTION {bbl.edby}      { "\bbledby{}" }

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FUNCTION {bbl.phdthesis} %  { "\bblphdthesis{}" }
{  language empty$
    {"edition"}
    { language "ukrainian" =
        {"{\cyr\cyrv\cyri\cyrd\cyra\cyrn\cyrn\cyrya}"}
        { language "russian" =
           {"{\cyr\cyrd\cyri\cyrs\cyrs.~\cyrn\cyra~ \cyrs\cyro\cyri\cyrs\cyrk\cyra\cyrn\cyri\cyre ~\cyru\cyrch.~\cyrs\cyrt\cyre\cyrp\cyre\cyrn\cyri~\cyrk\cyra\cyrn\cyrd.~ \cyrf\cyri\cyrz.-\cyrm\cyra\cyrt.~\cyrn\cyra\cyru\cyrk}"}
           {"language is not defined: " language  "edition" * * warning$ "edition"}
         if$}
      if$}
  if$
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {bbl.edition} %  { "\bbledition{}" }
{  language empty$
    {"edition"}
    { language "ukrainian" =
        {"{\cyr\cyrv\cyri\cyrd\cyra\cyrn\cyrn\cyrya}"}
        { language "russian" =
           {"{\cyr\cyri\cyrz\cyrd\cyra\cyrn\cyri\cyre}"}
           {"language is not defined: " language  "edition" * * warning$ "edition"}
         if$}
      if$}
  if$
}
FUNCTION {bbl.vvolume} %  { "\bblVolume{}" }
{  language empty$
    {"Volume"}
    { language "ukrainian" = language "russian" = or
        {"\CYRT\cyro\cyrm"}
        {"language is not defined: " language  "Volume" * * warning$ "Volume"}
      if$}
  if$
}

%FUNCTION {bbl.vol}     %  { "\bblvol{}" }
%{  language empty$
%    {"vol."}
%    { language "ukrainian" = language "russian" = or
%           {"{\cyr\cyrt.}"}
%           {"language is not defined: " language  "vol" * * warning$ "vol."}
%      if$}
%  if$
%}

FUNCTION {bbl.vvol}    %  { "\bblVol{}" }
{  language empty$
    {"Vol."}
    { language "ukrainian" = language "russian" = or
           {"\CYRT."}
           {"language is not defined: " language  "Vol." * * warning$ "Vol."}
      if$}
  if$
}
%FUNCTION {bbl.volume}  %  { "\bblvolume{}" }
%{  language empty$
%    {"volume"}
%    { language "ukrainian" = language "russian" =
%           {"{\cyr\cyrt\cyro\cyrm}"}
%           {"language is not defined: " language * warning$ "volume"}
%      if$}
%  if$
%}

FUNCTION {bbl.iissue}  %  { "\bblIssue{}" }
{  language empty$
    {"Issue"}
    { language "ukrainian" =
        {"\CYRV\cyri\cyrp\cyru\cyrs\cyrk"}
        { language "russian" =
           {"\CYRV\cyrery\cyrp\cyru\cyrs\cyrk"}
           {"language is not defined: " language * warning$ "Issue"}
         if$}
      if$}
  if$
}

FUNCTION {bbl.iiss}  %  { "\bblIss{}" }
{  language empty$
    {"Iss."}
    { language "ukrainian" =
        {"\CYRV\cyri\cyrp."}
        { language "russian" =
           {"\CYRV\cyrery\cyrp."}
           {"language is not defined: " language * warning$ "Issue"}
         if$}
      if$}
  if$
}

%FUNCTION {bbl.issue}  %   { "\bblissue{}" }
%{  language empty$
%    {"issue"}
%    { language "ukrainian" =
%        {"{\cyr\cyrv\cyri\cyrp\cyru\cyrs\cyrk}"}
%        { language "russian" =
%           {"{\cyr\cyrv\cyrery\cyrp\cyru\cyrs\cyrk}"}
%           {"language is not defined: " language * warning$ "issue"}
%         if$}
%      if$}
%  if$
%}

FUNCTION {bbl.of}      %  { "\bblof{}" }
{  language empty$
    {"of"}
    { language "ukrainian" =
        {"{\cyr\cyrii\cyrz}"}
        { language "russian" =
           {"{\cyr\cyri\cyrz}"}
           {"language is not defined: " language "of" *  * warning$ "of"}
         if$}
      if$}
  if$
}

FUNCTION {bbl.etal}      %  { "\bblof{}" }
{  language empty$
    {"et~al."}
    { language "ukrainian" =
        {"{\cyr\cyrt\cyra~\cyrii\cyrn.}"}
        { language "russian" =
           {"{\cyr\cyri~\cyrd\cyrr.}"}
           {"language is not defined: " language  "at al" * * warning$ "at al."}
         if$}
      if$}
  if$
}

FUNCTION {bbl.nnumber} %  { "\bblNumber{}" }
{  language empty$
    {"Number"}
    { language "ukrainian" = language "russian" = or
           {"\CYRN\cyro\cyrm\cyre\cyrr"}
           {"language is not defined: " language  "Number" * * warning$ "Number"}
      if$}
  if$
}

FUNCTION {bbl.number}  %  { "\bblnumber{}" }
{  language empty$
    {"number"}
    { language "ukrainian" = language "russian" = or
           {"{\cyr\cyrn\cyro\cyrm\cyre\cyrr}"}
           {"language is not defined: " language  "number" * * warning$ "number"}
      if$}
  if$
}

FUNCTION {bbl.nr}     %   { "\bblno{}" }
{  language empty$
    {"no."}
    { language "ukrainian" = language "russian" = or
           {"{\cyr\textnumero}"}
           {"language is not defined: " language  "no." * * warning$ "no."}
      if$}
  if$
}

FUNCTION {bbl.nnr}     %   { "\bblno{}" }
{  language empty$
    {"No."}
    { language "ukrainian" = language "russian" = or
           {"{\cyr\textnumero}"}
           {"language is not defined: " language  "No." * * warning$ "No."}
      if$}
  if$
}

FUNCTION {bbl.in}    %    { "\bblin{}" }
{  language empty$
    {"in"}
    { language "ukrainian" = language "russian" = or
           {"{\cyr\cyrv}"}
           {"language is not defined: " language  "in" * * warning$ "in"}
      if$}
  if$
}

FUNCTION {bbl.iin}  %     { "\bblIn{}" }
{  language empty$
    {"In"}
    { language "ukrainian" = language "russian" = or
           {"\CYRV"}
           {"language is not defined: " language  "In" * * warning$ "In"}
      if$}
  if$
}

FUNCTION {bbl.pages}    % { "\bblpp." }
{  language empty$
    {"pp."}
    { language "ukrainian" = language "russian" = or
           {"{\cyr\cyrs.}"}
           {"language is not defined: " language  "pp." * * warning$ "pp."}
      if$}
  if$
}

FUNCTION {bbl.page}   %   { "\bblp."
{  language empty$
    {"p."}
    { language "ukrainian" = language "russian" = or
           {"{\cyr\cyrs.}"}
           {"language is not defined: " language  "p." * * warning$ "p."}
      if$}
  if$
}

FUNCTION {bbl.ppages}%    { "\bblPp." }
{  language empty$
    {"Pp."}
    { language "ukrainian" = language "russian" = or
           {"{\cyr\CYRS.}"}
           {"language is not defined: " language  "Pp." * * warning$ "Pp."}
      if$}
  if$
}

FUNCTION {bbl.ppage}  %   { "\bblP." }
{  language empty$
    {"P."}
    { language "ukrainian" = language "russian" = or
           {"{\cyr\CYRS.}"}
           {"language is not defined: " language  "P." * * warning$ "P."}
      if$}
  if$
}

%\def\bblchapter{chapter}        \def\bblchap{chap.}
%\def\bblmthesis{Master's thesis}
%\def\bblphdthesis{Ph.D. thesis}
%\def\bblfirst{First}            \def\bblfirsto{1st}
%\def\bblsecond{Second}          \def\bblsecondo{2nd}
%\def\bblthird{Third}            \def\bblthirdo{3rd}
%\def\bblfourth{Fourth}          \def\bblfourtho{4th}
%\def\bblfifth{Fifth}            \def\bblfiftho{5th}
%\def\bblst{st}  \def\bblnd{nd}  \def\bblrd{rd}
%\def\bblth{th}


FUNCTION {bbl.chapter}   { "\bblchapter{}" }
FUNCTION {bbl.techreport} {"Technical Report"}
FUNCTION {bbl.techrep}   { "Tech. Rep." }
FUNCTION {bbl.mthesis}   { "\bblmthesis{}" }
FUNCTION {bbl.phdthesis} { "\bblphdthesis{}" }
FUNCTION {bbl.first}     { "\bblfirsto{}" }
FUNCTION {bbl.second}    { "\bblsecondo{}" }
FUNCTION {bbl.third}     { "\bblthirdo{}" }
FUNCTION {bbl.fourth}    { "\bblfourtho{}" }
FUNCTION {bbl.fifth}     { "\bblfiftho{}" }
FUNCTION {bbl.st}        { "\bblst" }
FUNCTION {bbl.nd}        { "\bblnd" }
FUNCTION {bbl.rd}        { "\bblrd" }
FUNCTION {bbl.th}        { "\bblth" }


INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr
%%      "{f.~}{vv~}{ll}{, jj}" format.name$ 't :=
%%      "{ll}{f.~}{vv~}{, jj}" format.name$ 't :=
      "{vv~}{ll}{ jj}{ ff}" format.name$ 't :=
%%      "{vv~}{ll}{~jj}{~f.}" format.name$ 't :=
      nameptr #1 >
        {
          numnames #50 >
            { "others" 't :=
              #1 'namesleft := }
            'skip$
          if$
          namesleft #1 >
            { ", " * t * }
            {
              t "others" =
                { " " * bbl.etal * }
                { ", " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.names.ed}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr
      "{f.~}{vv~}{ll}{, jj}"
      format.name$ 't :=
      nameptr #1 >
        {
          namesleft #1 >
            { ", " * t * }
            {
              "," *
              t "others" =
                { " et~al." * }
                { " " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    { author format.names emphasize}
%    { author format.names}
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor format.names emphasize
      editor num.names$ #1 >
        { ", " * bbl.editors * }
        { ", " * bbl.editor * }
      if$
    }
  if$
}

FUNCTION {format.in.editors}
{ editor empty$
    { "" }
    { editor format.names.ed
      editor num.names$ #1 >
        { ", " * bbl.editors * }
        { ", " * bbl.editor * }
      if$
    }
  if$
}

FUNCTION {format.title}
{ title empty$
    { "" }
    { title "t" change.case$
    }
  if$
}

FUNCTION {format.url}
{ url empty$
    { "" }
    { after.sentence 'output.state :=
%      "\newline\texttt{\small\url{" url * "}}" * }
%      "\newline{\small\url {" url * "}}" * }
      "{\small\url{ " url * "}}" * }
  if$
}

FUNCTION {output.address.publisher.date}
{
      address empty$
        'skip$
        { address output
          publisher empty$
            'skip$
            { new.column
            }
          if$
        }
        if$
        publisher "publisher" output.check
        year "year" output.check
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem{" write$
  cite$ write$
  "}" write$
  newline$
  "\selectlanguageifdefined{" write$
  language empty$
    {"english"  write$}
    {language  write$}
  if$
  "}" write$ newline$
%l@ukraine
%  language empty$
%    {default}
%    { language "ukrainian" =
%        {ukrainian}
%        {russian}
%      if$
%    }
%  if$
  ""
  before.all 'output.state :=
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

FUNCTION {word.in}
{ bbl.iin
  " " * }

FUNCTION {format.date}
{ year empty$
    { month empty$
        { "" }
        { "there's a month but no year in " cite$ * warning$
          month
        }
      if$
    }
    { month empty$
        'year
        { month " " * year * }
      if$
    }
  if$
}

FUNCTION {format.btitle}
{ title
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {tie.connect}
 {"~"
  swap$ * *
 }


FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
%%%%%%%%%%%%%%%%%%%%!!!!!!!!!!!!!!!!!!!!!!
    { bbl.vvol volume tie.connect %tie.or.space.connect
      series empty$
        'skip$
        { bbl.of space.word * series emphasize * }
      if$
      "volume and number" number either.or.check
    }
  if$
}

%FUNCTION {format.number.series}
%{ volume empty$
%    { number empty$
%        { series field.or.null }
%        { output.state mid.sentence =
%            { bbl.number }
%            { bbl.nnumber }
%          if$
%          number tie.or.space.connect
%          series empty$
%            { "there's a number but no series in " cite$ * warning$ }
%            { bbl.in space.word * series * }
%          if$
%        }
%      if$
%    }
%    { "" }
%  if$
%}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
        { series field.or.null }
        { series empty$
            { "there's a number but no series in " cite$ * warning$
              bbl.nnr }
            {
              %new.dblslash
              new.sentence
              series
              bbl.nr
              tie.or.space.connect}
          if$
          number tie.or.space.connect
        }
      if$
    }
    { "" }
  if$
}

FUNCTION {is.num}
{ chr.to.int$
  duplicate$ "0" chr.to.int$ < not
  swap$ "9" chr.to.int$ > not and
}

FUNCTION {extract.num}
{ duplicate$ 't :=
  "" 's :=
  { t empty$ not }
  { t #1 #1 substring$
    t #2 global.max$ substring$ 't :=
    duplicate$ is.num
      { s swap$ * 's := }
      { pop$ "" 't := }
    if$
  }
  while$
  s empty$
    'skip$
    { pop$ s }
  if$
}

FUNCTION {eng.ord}
{ duplicate$ "1" swap$ *
  #-2 #1 substring$ "1" =
     { bbl.th * }
     { duplicate$ #-1 #1 substring$
       duplicate$ "1" =
         { pop$ bbl.st * }
         { duplicate$ "2" =
             { pop$ bbl.nd * }
             { "3" =
                 { bbl.rd * }
                 { bbl.th * }
               if$
             }
           if$
          }
       if$
     }
   if$
}

FUNCTION {convert.edition}
{ edition
% edition extract.num "l" change.case$ 's :=
%  s "first" = s "1" = or
%    { bbl.first 't := }
%    { s "second" = s "2" = or
%        { bbl.second 't := }
%        { s "third" = s "3" = or
%            { bbl.third 't := }
%            { s "fourth" = s "4" = or
%                { bbl.fourth 't := }
%                { s "fifth" = s "5" = or
%                    { bbl.fifth 't := }
%                    { s #1 #1 substring$ is.num
%                        { s eng.ord 't := }
%                        { edition 't := }
%                      if$
%                    }
%                  if$
%                }
%              if$
%            }
%          if$
%        }
%      if$
%    }
%  if$
%  t
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { output.state mid.sentence =
        { convert.edition "l" change.case$ " " * bbl.edition * }
        { convert.edition "t" change.case$ " " * bbl.edition * }
      if$
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
        { #1 'multiresult := }
        { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
        { bbl.ppages pages n.dashify tie.connect }
        { bbl.ppage pages tie.connect }
      if$
    }
  if$
}

FUNCTION {format.pages.page}
{ pages empty$
    { numpages empty$
      { "" }
      { numpages bbl.pages tie.connect }
    if$}
    { format.pages}
  if$
}

FUNCTION {format.vol.num.pages}
{ volume field.or.null
  number empty$
    'skip$
    {
      ", no." number tie.or.space.connect *
      volume empty$
        { "there's a number but no volume in " cite$ * warning$ }
        'skip$
      if$
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
        { pop$ format.pages }
        { ": " * pages n.dashify * }
      if$
    }
  if$
}

FUNCTION {format.volume}
{ volume empty$
    { "" }
    { bbl.vvol volume tie.or.space.connect }
  if$
}

FUNCTION {format.number}
{ number empty$
    { "" }
    { bbl.nr number tie.or.space.connect }
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
        { bbl.chapter }
        { type "l" change.case$ }
      if$
      chapter tie.or.space.connect
      pages empty$
        'skip$
        { ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
        { booktitle emphasize }
        { format.in.editors ", " *
          booktitle emphasize * }
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
  key empty$ not and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { bbl.techrep }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}

FUNCTION {format.article.crossref}
{
  key empty$
   { journal empty$
        { "need key or journal for " cite$ * " to crossref " * crossref *
          warning$
          ""
        }
        { journal emphasize }
      if$
    }
    { word.in key * " " *}
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.crossref.editor}
{ editor #1 "{vv~}{ll}" format.name$
  editor num.names$ duplicate$
  #2 >
    { pop$ " et~al." * }
    { #2 <
        'skip$
        { editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
            { " et~al." * }
            { " \& " * editor #2 "{vv~}{ll}" format.name$ * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      word.in
    }
    { bbl.vvol volume tie.or.space.connect
      bbl.of space.word *
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
            { series emphasize * }
          if$
        }
        { key * }
      if$
    }
    { format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.incoll.inproc.crossref}
{
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { booktitle empty$
            { "need editor, key, or booktitle for " cite$ * " to crossref " *
              crossref * warning$
              ""
            }
            { word.in booktitle emphasize * }
          if$
        }
        { word.in key * " " *}
      if$
    }
    { word.in format.crossref.editor * " " *}
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  new.sentence
  format.title "title" output.check
  new.dblslash
  crossref missing$
    {
%      journal emphasize "journal" output.check
      journal "journal" output.check
      new.block
%      output.address.publisher.date
      year output
      new.block
      format.volume output
      format.number output
    }
    { format.article.crossref output.nonnull
    }
  if$
  new.block
  format.pages.page output
  new.block
  note output
  new.sentence
  format.url output
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check
    }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  new.sentence
  format.btitle "title" output.check
  crossref missing$
    { new.sentence
      format.number.series output
      new.block
      format.edition output
      new.block
      output.address.publisher.date
    }
    {
      new.dblslash
      format.book.crossref output.nonnull
    }
  if$
  new.block
  format.bvolume output
  new.block
  format.pages.page output
  new.block
  note output
  new.sentence
  format.url output
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  new.block
  format.title "title" output.check
  new.block
  howpublished output
  address output
  format.date output
  new.block
  note output
  new.sentence
  format.url output
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check
    }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  new.block
  format.btitle "title" output.check
  crossref missing$
    { format.chapter.pages "chapter and pages" output.check
      new.block
      format.number.series output
      new.sentence
      output.address.publisher.date
    }
    { format.chapter.pages "chapter and pages" output.check
      new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  new.block
  format.bvolume output
  new.block
  format.pages.page output
  new.block
  note output
  new.sentence
  format.url output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  new.sentence
  format.title "title" output.check
  new.dblslash
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      new.block
      output.address.publisher.date
      new.block
      format.bvolume output
      format.number.series output
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$
  new.block
  format.pages.page output
  new.block
  note output
  new.sentence
  format.url output
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  new.sentence
  format.title "title" output.check
  new.dblslash
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      new.block
      address empty$
        { organization publisher new.sentence.checkb
          organization output
          publisher output
          format.date "year" output.check
        }
        { address output.nonnull
          new.column
          organization output
          publisher output
          format.date "year" output.check
        }
      if$
      new.block
      format.bvolume output
      format.number.series output
    }
    { format.incoll.inproc.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  format.pages.page output
  new.block
  note output
  new.sentence
  format.url output
  fin.entry
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem
  author empty$
    { organization empty$
        'skip$
        { organization output.nonnull
          address output
        }
      if$
    }
    { format.authors output.nonnull }
  if$
  new.block
  format.btitle "title" output.check
  author empty$
    { organization empty$
    {
          address new.block.checka
          address output
        }
        'skip$
      if$
    }
    {
      organization address new.block.checkb
      organization output
      address output
    }
  if$
  format.edition output
  format.date output
  new.block
  note output
  new.sentence
  format.url output
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.btitle "title" output.check
  new.block
  bbl.mthesis format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  new.block
  note output
  new.block
  format.url output
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  title howpublished new.sentence.checkb
  format.title output
  howpublished new.block.checka
  howpublished output
  new.block
  format.date output
  new.block
  note output
  new.sentence
  format.url output
  fin.entry
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  new.sentence
  format.btitle "title" output.check
  new.column
  bbl.phdthesis format.thesis.type output.nonnull
  new.slash
  school "school" output.check
  new.block
  output.address.publisher.date
  new.block
  format.pages.page output
  note output
  new.sentence
  format.url output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { organization output }
    { format.editors output.nonnull }
  if$
  new.block
  format.btitle "title" output.check
  format.bvolume output
  format.number.series output
  address empty$
    { editor empty$
        { publisher new.sentence.checka }
        { organization publisher new.sentence.checkb
          organization output
        }
      if$
      publisher output
      format.date "year" output.check
    }
    { address output.nonnull
      format.date "year" output.check
      new.sentence
      editor empty$
        'skip$
        { organization output }
      if$
      publisher output
    }
  if$
  new.block
  note output
  new.sentence
  format.url output
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  new.sentence
  format.title "title" output.check
  new.column
  format.tr.number output.nonnull
  new.block
  address output
  new.column
  institution "institution" output.check
  format.date "year" output.check
  new.block
  note output
  new.sentence
  format.url output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  note "note" output.check
  new.sentence
  format.url output
  fin.entry
}

FUNCTION {default.type} { misc }

MACRO {jan} {"\bbljan{}"}

MACRO {feb} {"\bblfeb{}"}

MACRO {mar} {"\bblmar{}"}

MACRO {apr} {"\bblapr{}"}

MACRO {may} {"\bblmay{}"}

MACRO {jun} {"\bbljun{}"}

MACRO {jul} {"\bbljul{}"}

MACRO {aug} {"\bblaug{}"}

MACRO {sep} {"\bblsep{}"}

MACRO {oct} {"\bbloct{}"}

MACRO {nov} {"\bblnov{}"}

MACRO {dec} {"\bbldec{}"}

MACRO {acmcs} {"ACM Computing Surveys"}

MACRO {acta} {"Acta Informatica"}

MACRO {cacm} {"Communications of the ACM"}

MACRO {ibmjrd} {"IBM Journal of Research and Development"}

MACRO {ibmsj} {"IBM Systems Journal"}

MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

MACRO {ieeetc} {"IEEE Transactions on Computers"}

MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

MACRO {ipl} {"Information Processing Letters"}

MACRO {jacm} {"Journal of the ACM"}

MACRO {jcss} {"Journal of Computer and System Sciences"}

MACRO {scp} {"Science of Computer Programming"}

MACRO {sicomp} {"SIAM Journal on Computing"}

MACRO {tocs} {"ACM Transactions on Computer Systems"}

MACRO {tods} {"ACM Transactions on Database Systems"}

MACRO {tog} {"ACM Transactions on Graphics"}

MACRO {toms} {"ACM Transactions on Mathematical Software"}

MACRO {toois} {"ACM Transactions on Office Information Systems"}

MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}

MACRO {tcs} {"Theoretical Computer Science"}

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
      s nameptr
      "{vv{ } }{ll{ }}{  f{ }}{  jj{ }}"
      format.name$ 't :=
      nameptr numnames = t "others" = and
        { "et al" * }
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
      "The " #4 t chop.word
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
{ type$ "book" =
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

%ITERATE {presort}

%SORT

STRINGS { longest.label }

INTEGERS { number.label longest.label.width }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
}

FUNCTION {longest.label.pass}
{ number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
}

EXECUTE {initialize.longest.label}

ITERATE {longest.label.pass}

FUNCTION {begin.bib}
{ "\begin{thebibliography}{"  longest.label  * "}" * write$ newline$
  "\def\selectlanguageifdefined#1{"                  write$ newline$
  "\expandafter\ifx\csname date#1\endcsname\relax"   write$ newline$
  "\else\language\csname l@#1\endcsname\fi}"                write$ newline$
  "\ifx\undefined\url\def\url#1{#1}\else\fi"         write$ newline$
  preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
}


EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
%  "\catcode`\/=11"        write$ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}
%% End of customized bst file
%%
%% End of file `plainu.bst'.
