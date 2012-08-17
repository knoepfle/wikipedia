#!/bin/awk -f

function concat_fields(suf) {
    if(NF == 1) return suf
    cc=""
    for (i = 2; i <= NF; i = i + 1) {
	cc=cc""((i>2)?" ":"")$i;
    }
    return cc suf
}

BEGIN {
    FS="[ ]+";
    OFS="\t";
}

{
    if($1 == "REVISION") {
	out=$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t";
    }
    ## if you want to exclude a given variable,
    ## just put a '#' character in front of the
    ## relevant line to comment it out
    if($1 == "CATEGORY")  out=out""concat_fields("\t");
    if($1 == "IMAGE")     out=out""concat_fields("\t");
    if($1 == "MAIN")      out=out""concat_fields("\t");
    if($1 == "TALK")      out=out""concat_fields("\t");
    if($1 == "USER")      out=out""concat_fields("\t");
    if($1 == "USER_TALK") out=out""concat_fields("\t");
    if($1 == "OTHER")     out=out""concat_fields("\t");
    if($1 == "EXTERNAL")  out=out""concat_fields("\t");
    if($1 == "TEMPLATE")  out=out""concat_fields("\t");
    if($1 == "COMMENT")   out=out""concat_fields("\t");
    if($1 == "MINOR")     out=out""concat_fields("\t");
    if($1 == "TEXTDATA")  out=out""concat_fields("");
    if($0 == "") print out;
}

END {
    if($0 != "") print out;
}
