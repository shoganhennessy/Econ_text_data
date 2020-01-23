
# 21/01/2020
# jupyter nbextension enable python-markdown/main
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
sns.set(style='darkgrid')

## Load data
# Journal_articles_data = pd.read_csv(
# 	'../Data/RePEc_data/Papers_data/Journal_articles_repec.csv',  low_memory=False)


## Create a causal graph :
import networkx as nx
Graph = nx.DiGraph()

# nodes
Graph.add_node('Student')
Graph.add_node('Economist')
Graph.add_edge('Student','Economist', w = 4.7)

# draw the graph
node_position = nx.spring_layout(Graph)
nx.draw(Graph, pos = node_position, node_size = 100)

# adjust the position
def real_sign(number) :
	if number < 0 : return -1
	else : return 1
def array_sign(array) :
	return np.array([real_sign(num) for num in array])
label_position = {name : -0.05*array_sign(node_position[name]) + node_position[name]
					for name in node_position}
nx.draw_networkx_labels(Graph, pos = label_position, font_size = 12, with_labels = True)
plt.show()


# https://networkx.github.io/documentation/networkx-1.9/examples/drawing/labels_and_colors.html



# 
# 
# Re-read and references these papers and blog posts:
# 
# https://p-hunermund.com/2017/10/25/econometrics-and-the-not-invented-here-syndrome-suggestive-evidence-from-the-causal-graph-literature/#more-4512
# 
# https://www.nber.org/papers/w19453
# 
# Reflections on Heckman and Pinto's Causal Analysis After Haavelmo
# Judea Pearl 2013
# 
# https://p-hunermund.com/2018/06/09/no-free-lunch-in-causal-inference/#more-4858
# 
# Read this to create the causal graph.
# https://networkx.github.io/documentation/stable/index.html 
# 
# Causal implemtation, using a causal graph and data as input.
# https://microsoft.github.io/dowhy/ 
# 
# 
# 
# Read first :
# https://towardsdatascience.com/jupyter-notebook-in-visual-studio-code-3fc21a36fe43
# 
