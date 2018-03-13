from random import randint
from hashlib import pbkdf2_hmac
from datetime import datetime
import sqlite3
import sys
import os

connection = None
cursor = None
user = None
role = None

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
    
def supervisor_newMasterAccount():

    global cursor, connection

    #Select account manager

    #Select all personnel with matching supervisor_pid and who are account managers
    sqlcmd = "SELECT pid FROM personnel WHERE supervisor_pid=:user"
    cursor.execute(sqlcmd, {"user":user})
    supervised = cursor.fetchall()
    for i in range(0, len(supervised)):
        supervised[i] = supervised[i][0]

    #Selecting an account manager    
    manager = None
    while True:
        printScreen('Supervised managers')
        for i in range(0, len(supervised)):
            print(supervised[i])
        manager = input("Select an account manager:\n\n")
        if manager in supervised:
            break
    
    account_no = None
    #Generate unique random for account_no
    while True:
        account_no = str(randint(0,sys.maxsize))
        sqlcmd = "SELECT account_no FROM accounts WHERE account_no=:account_no"
        cursor.execute(sqlcmd, {"account_no":account_no})
        try:
            cursor.fetchone()[0]
        except:
            break

    #Retrieve account information
    customer_name = input("Customer name: ")
    contact_info = input("Contact information: ")
    
    customer_type = None
    while True:
        cmd = input("Customer type:\n1.Municipal\n2.Commercial\n3.Industrial\n4.Residential\n\n")
        if cmd == '1':
            customer_type = 'municipal'
            break
        if cmd == '2':
            customer_type = 'commercial'
            break
        if cmd == '3':
            customer_type = 'industrial'
            break
        if cmd == '4':
            customer_type = 'residential'
            break
    
    start_date = None
    while True:
        start_date = input("Start date (YYYY-MM-DD): ")
        try:
            datetime.strptime(start_date,"%Y-%m-%d")
            break
        except:
            pass

    end_date = None
    while True:
        end_date = input("End date (YYYY-MM-DD): ")
        try:
            datetime.strptime(end_date,"%Y-%m-%d")
            break
        except:
            pass

    #Add input check
    total_amount = input("Total amount for all services : $") 

    #Create account
    sqlcmd = "INSERT INTO accounts(account_no, account_mgr, customer_name, contact_info, customer_type, start_date, end_date, total_amount) VALUES (:account_no, :manager, :customer_name, :contact_info,:customer_type, :start_date, :end_date, :total_amount)"
    cursor.execute(sqlcmd, {"account_no":account_no, "manager":manager, "customer_name":customer_name, "contact_info":contact_info, "customer_type":customer_type, "start_date":start_date, "end_date":end_date, "total_amount":total_amount})
    connection.commit()


def supervisor_customerReport():
    pass

def supervisor_managersReport():
    pass


def supervisorActivity():
    printScreen('Supervisor Actions')
    cmd = input("1.Create new master account\n2.Create summary report for customer\n3.Create summary report for each supervised account manager\n0.Log out\n\n")
    while True:
        if cmd == '1':
            supervisor_newMasterAccount()
        if cmd == '2':
            supervisor_customerReport()
        if cmd == '3':
            supervisor_managersReport()
        if cmd == '0':
            return

        

def applyRole():
    
    if role == "Supervisor":
        supervisorActivity()


def login_accept( ):
    
    global role

    user = cursor.fetchone()[0]
    sqlcmd = "SELECT role FROM users WHERE user_id=:user_id"
    cursor.execute(sqlcmd, {"user_id":user})
    role = cursor.fetchone()[0]
    printScreen('Welcome User' +  user + '\n')
    applyRole()

def login_deny():
    while True:
        printScreen('Username/password are wrong')
        cmd = input("1. Try again.\n2. Cancel\n\n")
        if cmd == '1':
            login()
            return
        if cmd == '2':
            main()
            return

def login():

    global user, cursor
        
    printScreen('Login')
    username = input('Username: ')
    password = hashPassword(input('Password: '))

    sqlcmd = "SELECT user_id FROM users WHERE login=:username AND password=:userpass"
    
    cursor.execute(sqlcmd, {"username":username, "userpass":password})
    try:
        login_accept()
    except:
        login_deny()


def register():

    global user, role, cursor, connection

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
            role = 'Account Manager'
            break
        elif role == '2':
            role = 'Supervisor'
            break
        elif role == '3':
            role = 'Dispatcher'
            break
        elif role == '4':
            role = 'Driver'
            break

    #Assign a random not already used id.
    while True:
        user = str(randint(0,sys.maxsize))
        sqlcmd = "SELECT user_id FROM users WHERE user_id=:user_id"
        cursor.execute(sqlcmd, {"user_id":user})
        try:
            cursor.fetchone()[0]
        except:
            break

    #Insert into user table
    sqlcmd = "INSERT INTO users(user_id, role, login, password) VALUES (:user_id, :role, :login, :password)"
    cursor.execute(sqlcmd, {"user_id":user_id, "role":role, "login":username, "password":password})
    connection.commit()

    printScreen("Welcome User" + str(user_id))
    applyRole()

def main():
    
    global user, cursor, connection

    connect("./waste_management.db")

    #Debug
    user = '74569'

    #supervisor_newMasterAccount()

    while True:

        printScreen('Mini Project 1')
        cmd = input('1.Login\n2.Register\n0.Quit\n\n')
        if cmd == '0':
            break
        if cmd == '1':
            login()
        if cmd == '2':
            register()
            break

    cursor.close()

if __name__ == "__main__":
    main()
