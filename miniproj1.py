from random import randint
from hashlib import pbkdf2_hmac
import sqlite3
import sys
import os

connection = None
cursor = None
user = None

def connect(path):
    #taken from week 8 lab.
    
    global cursor, connection
    
    exists = os.path.exists(path)

    connection = sqlite3.connect(path)
    connection.row_factory = sqlite3.Row
    cursor = connection.cursor()
    cursor.execute(' PRAGMA forteign_keys=ON; ')

    #if database does  not yet exist creates the tables.
    if not exists:
        initScript = open('p1-tables.sql', 'r').read()
        cursor.executescript(initScript)
    connection.commit()


def printScreen(title):
    print('='*32+'\n')
    print(title +'\n')


def hashPassword(password):
    
    hash_name ='sha256'
    salt = 'ssdirf993lksiqb4'
    iterations = 100000

    return pbkdf2_hmac(hash_name, bytearray(password, 'ascii'), bytearray(salt, 'ascii'), iterations)

def login_accept():
    user = cursor.fetchone()[0]
    printScreen('Welcome User' +  user + '\n')

def login_deny():
    while True:
        printScreen('Username/password are wrong')
        cmd = input("1. Try again.\n2. Cancel\n\n")
        if cmd == '1':
            login()
            return
        if cmd == '2':
            return

def login():

    global user, cursor
        
    printScreen('Login')
    username = input('Username: ')
    userpass = hashPassword(input('Password: '))

    sqlcmd = "SELECT user_id FROM users WHERE login=:username AND password=:userpass"
    
    cursor.execute(sqlcmd, {"username":username, "userpass":userpass})
    try:
        login_accept()
    except:
        login_deny()
        return


def register():

    global user, cursor, connection

    printScreen('Register');

    #Get username and check if not a duplicate
    while True:
        username = input('Username: ')
        sqlcmd = "SELECT user_id FROM users WHERE login=:username"
        cursor.execute(sqlcmd, {"username":username })
        try:
            cursor.fetchone()[0]
            print("Username already taken!\n")
        except:
            break

    password = hashPassword(input('Password: '))

    #Get user role
    while True:
        role = input("Role:\n1.Account Manager\n2.Supervisor\n3.Dispatcher\n4.Driver\n\n")
        if role == '1':
            role == 'Account Manager'
            break
        elif role == '2':
            role == 'Supervisor'
            break
        elif role == '3':
            role == 'Dispatcher'
            break
        elif role == '4':
            role == 'Driver'
            break

    #Assign a random not already used id.
    while True:
        user_id = randint(0,sys.maxsize)
        sqlcmd = "SELECT user_id FROM users WHERE user_id=:user_id"
        cursor.execute(sqlcmd, {"user_id":user_id})
        try:
            cursor.fetchone()[0]
        except:
            break

    #Insert into user table
    sqlcmd = "INSERT INTO users(user_id, role, login, password) VALUES (:user_id, :role, :login, :password)"
    cursor.execute(sqlcmd, {"user_id":user_id, "role":role, "login":username, "password":password})
    connection.commit()

    printScreen("Welcome User" + str(user_id))

def main():
    
    global cursor, connection

    connect("./waste_management.db")

    while True:

        printScreen('Mini Project 1')
        cmd = input('1.Login\n2.Register\n0.Quit\n\n')
        if cmd == '0':
            break
        if cmd == '1':
            login()
            break
        if cmd == '2':
            register()
            break

    cursor.close()

if __name__ == "__main__":
    main()
