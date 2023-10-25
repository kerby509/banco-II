import psycopg2 
from copy import copy
import json

#inicia a simulação
def getLog (name, con):
    createTable(con)
    file = open(name, "r")
    data = file.readlines()
    #initSimulation(con, data[:data.index("\n")])
    data = data[data.index("\n")+1:]
    data.reverse()
    file.close()
    return data


def remove_transaction(data, transaction_to_remove):
    result = []

    for line in data:
        log = line[1:-2]

        if transaction_to_remove not in log:
            result.append(line)

    return result

# encontre os checkpoints finalizados no arquivo de log
def findCheckpoint(data):
    stack = []
    after_checkpoint = []
    undid_transactions = []

    for line in data:
        if line == "<start CKPT>\n":
            stack.append(True)
        if len(stack) > 0:
            if stack[-1] and line == "<end CKPT>\n":
                stack.pop()
            if stack[-1]:
                after_checkpoint.append(line)
            elif line.startswith("Transação") and "realizou UNDO" in line:
                undid_transactions.append(line)
    
    return data, after_checkpoint, undid_transactions




# create teste table from simulation
def createTable(con):
    cur = con.cursor()
    cur.execute("create table if not exist teste(id integer, A integer, B integer)")
    
    
    
    
    
# inicia a conexão com o banco de dados e obtém o arquivo de log
con={
    'database':'work',
    'user' : 'postgres',
    'password': 'kerby3948',
    'host': 'localhost',
    'port': '5432'
}

data=getLog("logs/entradaLog", con)
try:
    data = psycopg2.connect(**con)
    print("Conexão com o banco de dados PostgreSQL bem-sucedida.")
    
        # Fechar a conexão com o banco de dados
    data.close()
    print("Conexão com o banco de dados PostgreSQL encerrada.")
except Exception as e:
        print(f"Erro ao conectar ao banco de dados PostgreSQL: {e}")




#teste e insere os valores de inicialização da simulação
def initSimulation(con, data):
    cur = con.cursor()
    cur.execute("truncate teste")
    con.commit()

    insertMap = []

    for line in data:
        temp = line.split(",")
        value = temp[1].split("=")[1]

        separator = ""
        if " " in value:
            separator += " "
        separator += "\n"
        
        insertMap.append({"column": temp[0], "id": temp[1].split("=")[0], "value": value[:value.index(separator)]})  
    tuple = []
    for i in insertMap:
        for j in insertMap:
            if i["id"] == j["id"] and j["column"] != i["column"] and len(tuple) < len(insertMap)/2:
                tuple.append([i["id"], i["value"], j["value"]])
    for i in tuple:
        sql = f"insert into teste(id, a, b) values{i[0], i[1], i[2]}"
        cur.execute(sql)
    con.commit()



    