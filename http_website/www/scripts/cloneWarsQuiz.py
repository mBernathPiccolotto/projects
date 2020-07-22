#!/usr/bin/env python3

import cgi

print('HTTP/1.0 200 OK')
print('Content-Type: text/html')
print()

form = cgi.FieldStorage()

score = 0

if ('rexNumber' in form) or ('domino' in form) or ('cody' in form) or ('66' in form):
  # If user submmited answers

    # Calculating Score
  if 'rexNumber' in form:
    if((form['rexNumber'].value) == 'CT-7567'):
      score += 1
  if 'domino' in form:
    if((form['domino'].value) == 'Boiler'):
      score += 1
  if 'cody' in form:
    if((form['cody'].value) == '212 Atack Battalion'):
      score += 1
  if '66' in form:
    if((form['66'].value) == 'Commander Cody'):
      score += 1

  # Outputing result

  if score == 0:
    print('''<h1>Your Rank: Clone Cadet</h1>''')
    print('''<h2>You still have much to learn, but you have taken a first step into a larger world</h2>''')
    print("<img src=\"https://vignette.wikia.nocookie.net/starwars/images/b/bb/Epguide301.png/revision/latest/scale-to-width-down/1000?cb=20130505050246\" alt=\"Cadets\" height=\"590\" width=\"1270\">")
  elif score == 1:
    print('''<h1>Your Rank: Clone Trooper</h1>''')
    print('''<h2>You already know the basics, but careful, Geonosis is nothing like the simulations</h2>''')
    print("<img src=\"https://wallpaperplay.com/walls/full/1/6/5/54211.jpg\" alt=\"Trooper\" height=\"453\" width=\"802\">")
  elif score == 2:
    print('''<h1>Your Rank: Clone Sargent</h1>''')
    print('''<h2>Good job! You are ready to lead a small company</h2>''')
    print("<img src=\"https://vignette.wikia.nocookie.net/starwars/images/3/36/HunterCF99.png/revision/latest?cb=20200305013758\" alt=\"Sargent\" height=\"625\" width=\"1101\">")
  elif score == 3:
    print('''<h1>Your Rank: Clone Captain</h1>''')
    print('''<h2>You are more experienced than most. Now remember: it is your duty to remain loyal to the republic, but you also have another duty: to protect your men</h2>''')
    print("<img src=\"https://thewookieegunner.files.wordpress.com/2013/03/captain-rex-large.jpg\" alt=\"Captain\" height=\"387\" width=\"761\">")
  elif score == 4:
    print('''<h1>Your Rank: Clone Commander</h1>''')
    print('''<h2>The generals command. You implement</h2>''')
    print("<img src=\"https://assets.change.org/photos/4/nm/ww/YsNMWwpgbZWqItd-800x450-noPad.jpg?1539413306\" alt=\"Commander\" height=\"489\" width=\"875\">")

else: 
  # If not give them the quiz

  # Title

  print('''

    <h1>To celebrate Clone Wars Season 7 test your knowledge of the Grand Army of the Republic</h1>

  ''')

  # Start the quiz
  print('''
  <form>
  ''')

  # Question 1 Captain Rex
  print('''

    <h2>What is Cap. Rex's id Number?</h2>

    <input type="radio" id="CT-7567" name="rexNumber" value="CT-7567">
    <label for="CT-7567">CT-7567</label><br>

    <input type="radio" id="ARC-5555" name="rexNumber" value="ARC-5555">
    <label for="ARC-5555">ARC-5555</label><br>

    <input type="radio" id="CT-2224" name="rexNumber" value="CT-2224">
    <label for="CT-2224">CT-2224</label><br><br>

  ''')

  # Question 2 Domino Squad

  print('''

    <h2>Who is not a member of Domino squad?</h2>

    <input type="radio" id="Droidbait" name="domino" value="Droidbait">
    <label for="Droidbait">Droidbait</label><br>

    <input type="radio" id="Cutup" name="domino" value="Cutup">
    <label for="Cutup">Cutup</label><br>

    <input type="radio" id="Boiler" name="domino" value="Boiler">
    <label for="Boiler">Boiler</label><br>

  ''')

  # Question 3 Cody 

  print('''

    <h2>Which battalion did Commander Cody lead?</h2>

    <input type="radio" id="501st Legion" name="cody" value="501st Legion">
    <label for="501st Legion">501st Legion</label><br>

    <input type="radio" id="212th Atack Battalion" name="cody" value="212 Atack Battalion">
    <label for="212 Atack Battalion">212 Atack Battalion</label><br>

    <input type="radio" id="41st Elite Corps" name="cody" value="41st Elite Corps">
    <label for="41st Elite Corps">41st Elite Corps</label><br>

  ''')

  # Question 4 Order 66

  print('''

    <h2>Which of these clones did not disobey order 66?</h2>

    <input type="radio" id="Commander Wolffe" name="66" value="Commander Wolffe">
    <label for="Commander Wolffe">Commander Wolffe</label><br>

    <input type="radio" id="Commander Cody" name="66" value="Commander Cody"">
    <label for="Commander Cody">Commander Cody</label><br>

    <input type="radio" id="Commander Gregor" name="66" value="Commander Gregor">
    <label for="Commander Gregor">Commander Gregor</label><br>

  ''')


  # Submmit and end Form
  print('''
  <h2>\n</h2>
  <input type="submit" value="Submit">
  </form> 
  ''')