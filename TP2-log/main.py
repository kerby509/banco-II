import psycopg2 
from copy import copy
import json

#inicia a simulação
def getLog (name, con):
    createTable(con)
    file = open(name, "r")
    data = file.readlines()
    data = data[data.index("\n")+1:]
    data.reverse()
    file.close()
    return data




# create teste table from simulation
def createTable(con):
    cur = con.cursor()
    cur.execute("create table if not exist teste(id integer, A integer, B integer)")
