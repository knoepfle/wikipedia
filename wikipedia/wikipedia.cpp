//
//  wikipedia.cpp
//
//  A demonstration of the utility of scripting languages when
//  the task is primarily IO-bound.
//
//  Created by Daniel Knoepfle on 8/16/12.
//  Copyright (c) 2012 Daniel Knoepfle. All rights reserved.
//

#include <iostream>
#include <cstdio>
#include <string>
#include <boost/tokenizer.hpp>

using namespace std;
using namespace boost;

/* SAMPLE DATA: */
/*
REVISION 4781981 72390319 Steven_Strogatz 2006-08-28T14:11:16Z SmackBot 433328
CATEGORY American_mathematicians
IMAGE
MAIN Boston_University MIT Harvard_University Cornell_University
TALK
USER
USER_TALK
OTHER De:Steven_Strogatz Es:Steven_Strogatz
EXTERNAL http://www.edge.org/3rd_culture/bios/strogatz.html
TEMPLATE Cite_book Cite_book Cite_journal
COMMENT ISBN formatting &/or general fixes using [[WP:AWB|AWB]]
MINOR 1
TEXTDATA 229
[blank line]
*/

typedef tokenizer<char_separator<char> > spaced_tokenizer;

void infix_output(spaced_tokenizer::iterator & it, spaced_tokenizer::iterator const & end, char const & sep) {
    while(it != end) {
        printf("%s", (*it).c_str());
        advance(it, 1);
        if(it != end) {
            printf("%c", sep);
        }
    }
}

int main(int argc, char * argv[])
{
    string line;
    
    char_separator<char> space(" ");
    
    // make iostreams less slow (see ISO/IEC TR 18015:2006(E) pages 63-64)
    cin.sync_with_stdio(false);
    cin.tie(0);
    
    while(getline(cin, line)) {
        if(line != "") {
            spaced_tokenizer tokens(line, space);
            spaced_tokenizer::iterator ltok = tokens.begin();
            
            string field_name = *ltok;
            advance(ltok, 1);
            
            if(field_name == "REVISION") {
                infix_output(ltok, tokens.end(), '\t');
            } else {
                infix_output(ltok, tokens.end(), ' ');
            }
            
            // output field separator
            if(field_name != "TEXTDATA") {
                printf("%c", '\t');
            }
        } else {
            printf("%c", '\n');
        }
    }
    
}