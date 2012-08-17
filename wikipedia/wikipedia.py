#!/usr/bin/python

def print_record(revision_fields, vals):
    (article_id, rev_id, article_title, 
             timestamp, username, user_id) = revision_fields
    print repr('\t'.join([
        article_id,
        rev_id,
        article_title,
        timestamp,
        username,
        user_id,
        vals['CATEGORY'],
        vals['IMAGE'],
        vals['MAIN'],
        vals['TALK'],
        vals['USER'],
        vals['USER_TALK'],
        vals['OTHER'],
        vals['EXTERNAL'],
        vals['TEMPLATE'],
        vals['COMMENT'],
        vals['MINOR'],
        vals['TEXTDATA']
    ]))

with open("wikipedia.txt") as f:
    vals = dict()
    for line in f:
        fields = line.rstrip().split(' ')
        field_name = fields[0]
        if field_name == "":
            if len(vals) > 0:
                print_record(revision_fields, vals)
                vals.clear()
        elif field_name == "REVISION":
            revision_fields = fields[1:]
        else:
            vals[field_name] = ' '.join(fields[1:])
    
    ## output last record
    if len(vals) > 0:
        print_record(revision_fields, vals)