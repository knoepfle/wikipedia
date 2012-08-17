//
//  main.cpp
//  wikipedia
//
//  Created by Daniel Knoepfle on 8/16/12.
//  Copyright (c) 2012 Daniel Knoepfle. All rights reserved.
//

#include <iostream>
#include <string>
#include <boost/tokenizer.hpp>

using namespace std;
using namespace boost;

//REVISION 4781981 72390319 Steven_Strogatz 2006-08-28T14:11:16Z SmackBot 433328
//CATEGORY American_mathematicians
//IMAGE
//MAIN Boston_University MIT Harvard_University Cornell_University
//TALK
//USER
//USER_TALK
//OTHER De:Steven_Strogatz Es:Steven_Strogatz
//EXTERNAL http://www.edge.org/3rd_culture/bios/strogatz.html
//TEMPLATE Cite_book Cite_book Cite_journal
//COMMENT ISBN formatting &/or general fixes using [[WP:AWB|AWB]]
//MINOR 1
//TEXTDATA 229
//[blank line]

int main(int argc, char * argv[])
{

    string line;
    
    char_separator<char> space(" ");
    
    while(getline(cin, line)) {
        if(line != "") {
            tokenizer<char_separator<char>> tokens(line, space);
            auto ltok = tokens.begin();
            
            string field_name = *ltok;
            advance(ltok, 1);
            
            if(field_name == "REVISION") {
                while(ltok != tokens.end()) {
                    cout << *ltok << "\t";
                    advance(ltok, 1);
                }
            } else {
                while(ltok != tokens.end()) {
                    cout << *ltok << " ";
                    advance(ltok, 1);
                }
            }
        } else {
            cout << "\n";
        }
    }
    
}