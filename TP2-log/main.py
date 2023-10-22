import psycopg2 
from copy import copy

#inicia a simulação
def getLog (name, con):
    createTable(con)




# create teste table from simulation
def createTable(con):
    cur = con.cursor()
    cur.execute("create table if not exist teste(id integer, A integer, B integer)")
