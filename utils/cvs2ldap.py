#!/usr/bin/python
# -*- coding: utf-8-auto; -*-
import csv, string

reader = csv.reader(open('ad.csv', 'rb'), delimiter=';', quotechar='|')
file = open('ad.ldif','a')

for row in reader:
    fname = row[0].replace('-', '').lower()
    lname = row[1].replace('-', '').lower()
    uid = fname[0] + lname[:5]

    file.write('dn: uid='+ uid +',ou=People,dc=ldn-fai,dc=net\n')
    file.write('objectClass: inetOrgPerson\n')
    file.write('objectClass: shadowAccount\n')
    file.write('uid: ' + uid + '\n')
    file.write('mail: ' + row[7] + '\n')
    file.write('cn: ' + row[0] + ' ' +row[1] + '\n')
    file.write('givenName: ' + row[0] + '\n')
    file.write('sn: ' + row[1] + '\n\n')
