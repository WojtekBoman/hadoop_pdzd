import sys
import pandas as pd
import os

path = sys.argv[1]

df = pd.read_csv(path)

if((df["firstSeen"] <= df['lastSeen']).all()):
	print(0)
else:
	print(1)
