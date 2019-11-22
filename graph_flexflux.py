#!/usr/bin/env python
import sys
import pandas
import matplotlib
import matplotlib.pyplot as plt
data=sys.argv[1]
df= pandas.read_csv(data, sep="\t")
loc=['center right']
for k,v in df.items() : 
	time=df['Time']
	if k!='X' and k!='Time':
		name=str(k)
		component=df[k]
		plt.plot(time, component, label=name)
		plt.legend(loc=7)

plt.xlabel('Time')
plt.ylabel('Concentrations of component')

plt.savefig('output_graph_FlexFlux.png')
