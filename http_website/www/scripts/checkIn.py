#!/usr/bin/env python3

import cgi

print('HTTP/1.0 200 OK')
print('Content-Type: text/html')
print('''

<h1>Wall of Messages</h1>

''')

form = cgi.FieldStorage()

# Adding message to list of messages
if 'message' in form:
    file_object = open('www/text/checkIn.txt', 'a')
    string = form['message'].value + '\n'
    file_object.write(string)
    file_object.close()
    
# Get the user input
print('''
<h2>Input the message to be immortalized in the wall</h2>
<form>
    <input type="text" name="message">
    <input type="submit">
</form>
''')

# Printing existing messages
print('''

<h2>Messages\n</h2>

''')

file_object = open('www/text/checkIn.txt')
line = file_object.readline()

while line:
    print('<h3>- {}</h3>'.format(line))
    line = file_object.readline()

file_object.close()







