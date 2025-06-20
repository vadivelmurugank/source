"""
mypython.py

My python template file

"""

import sys
import os
import collections

class block:
"""
    Block Class
"""
    # Constructor
    def __init__(self):
        self.global = 0
        self._protected_variable = 0
        self.__private_variable = 0
        self.dict_var = collections.OrderedDict() # { }
        self.list_var = list() # [  ]
        self.tuple_var = tuple() # ( )
        self.set_muttable_var = set() #  set([1,2,3])
        self.frozenset_immutable_var = frozenset() # frozenset([1,2,3])

    # Destructor
    def __del__(self): pass

    # Callable object
    def __call__(self, *args, **kwargs):

    # Iterator Object
    def __iter__(self):

    def __next__(self):

    # Descriptor
    def __get__(self, obj, objtype=None):

    def __set__(self, obj, value):

    def __delete__(self, obj):



    #Generator Object
    def generator_func():
        yield a += 1

    # Generator Expressions
    sum([x*x for x in range(10)])
    lfunc = lambda s, a: s+a[3]

    # Decorator
    def my_decorator_func(myfunc):
        def wrapper(*args, **kwargs):
            result = myfunc(*args, **kwargs)
            # Do something generic
            return result
        return wrapper

    @my_decorator_func
    def runfunc(self, a, b)
        return a + b

    def class_func(self):
        try:

        except:

        throw:

def important_types():
    ## functions
    enumerate(["a", "b", "c"])
    zip([1,2], [2,3])
    map(func, [lists])
    filter(func, [range])
    reduce(openrator, [values])


if __name__ = "__main__":
    import sys

    cl = class_block(<init values>)
    cl.class_func()


############################################################
# PYDOT DIAGRAMS
############################################################

    graph = pydot.Dot(graph_type='digraph')

    # layout = dot, neato,twopi, circo 
    #    dot - Directed graphs and directed ranks
    #    neato - spring model layouts
    #    circo - Circular layout
    #    twopi - radial layout

    # rankdir = BL, BR, TL, TR, RB, RT, LB, LT

    graph.set_graph_defaults(
        rankdir="LR",
        compound="true",
        layout="dot",
        nodesep=1,
        graph_type="record",
        bgcolor="white"
    )
    graph.set_edge_defaults(
            color="royalblue",
            fontsize=10,
            style="solid",
            fontname="times-bold",
            fillcolor="grey",
            arrowhead="vee",
            rank="source",
            penwidth=2)
    graph.set_node_defaults(
            fontname="times-bold",
            fontsize=10,
            gradientangle=270,
            shape="record",
            nodesep=2,
            ordering="out",
            penwidth=1)

    cluster_block = pydot.Cluster("Clusterblock", label="cluster block", color="royalblue")
    node_block = pydot.Node("Node Block", label="Device Object Init", shape="plaintext", height=2, width=2)
    cluster_block.add_node(node_block)
    graph.add_subgraph(cluster_block)

    module_str = '''{
         Object Class
        - member_func()
        - member_func_1()
        - member_func_2()
        ...
    }'''

    nmodule = pydot.Node(label=module_str, shape="record",
fillcolor="royalblue", style="filled", fontcolor="white")
    cmodule.add_node(nmodule)
    graph.add_subgraph(cmodule)
    emodule = pydot.Edge(node_block, nmodule, label="Call modulelib init")
    graph.add_edge(emodule)

    cmultiblock = pydot.Cluster("multiblock", label="multiblock")
    name =" Objects | *** | <f1> Partition 1 |<f2> Partition 2 |<f3> Partition 3 "
    nmultiblock = pydot.Node("nmultiblock",label=name, height=2, width=2, shape="record")
    cmultiblock.add_node(nmultiblock)
    graph.add_subgraph(cmultiblock)

    graph.add_edge(pydot.Edge(node_block, "nmultiblock:f1", dir="back"))
    graph.add_edge(pydot.Edge(nmodule, "nmultiblock:f2", dir="back"))



############################################################
# MATPLOTLIB
############################################################


############################################################
# SCIPY NUMPY
############################################################








