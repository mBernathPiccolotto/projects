s = """
Volume - values from 0 to 4      Volume - values from 0 to 4    
Filter Choice - 0:ON  1:OFF     Filter Choice - 0:ON  1:OFF     
Oscillator  -  0:sine 1:square 2:triangle 3:sawtooth 4:noise    """

s = s.replace('\n', '')

print(' '.join("{:02x}".format(ord(c)) for c in s))
