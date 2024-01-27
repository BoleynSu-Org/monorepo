#!/usr/bin/python3
import os, sys, smtplib
from datetime import datetime
from email.mime.text import MIMEText
from conf import EMAIL
from conf import USER
from conf import PASSWD

with open(os.path.dirname(__file__) + "/log.txt", "a") as log:
  log.write("[" + str(datetime.now()) + "]\t" + str(sys.argv))
  log.write("\n")

emailToName = dict()
emailOf = dict()
regular = dict()
remaining = dict()
once = dict()

def sendTo(emails, message):
  msg = MIMEText(message, _charset="UTF-8")
  msg["From"] = "Group Gathering <" + EMAIL + ">"
  msg["To"] = ", ".join(emails)
  msg["Subject"] = message.split("\n")[0]
  server = smtplib.SMTP("smtp.gmail.com", 587)
  server.starttls()
  server.login(USER, PASSWD)
  server.sendmail(msg["From"], emails, msg.as_string())
  server.close()

def getAttenders():
  attenders = []
  for name in emailToName.values():
    if regular[name] and once.get(name, True):
      attenders.append(name)
    if (not regular[name]) and once.get(name, False):
      attenders.append(name)
  return attenders

def sendEmail(email, message):
  global emailToName, emailOf, regular, remaining, once
  message += "\n## Statistics ##\n"
  for name in emailOf.keys():
    message += "[" + name + "] has [" + ("%.2f" % remaining[name]) + "] HKD remaining, [" + ("is" if regular[name] else "is not") + "] a regular attender and [" + ("will" if (regular[name] and once.get(name, True)) or ((not regular[name]) and once.get(name, False)) else "will not") + "] attend the next gathering.\n"
  total = 0
  for r in remaining.values():
    total += r
  message += "Amount: [" + ("%.2f" % total) + "] HKD\n"
  message += "Attenders: [" + ", ".join(getAttenders()) + "]\n" 
  message += "Reply \"help\" for usage"
  if email == None:
    sendTo(emailToName.keys(), message)
  else:
    sendTo([email], message)

def help(records, email, args):
  message = ""
  if args:
    message += args[0] + "\n"
  message += \
"""## Usage ##
You can send commands by sending email to """
  message += EMAIL
  message += \
""".
Commands should be in the body of the email you send and the subject will be ignored.
All commands supported are as follows.
1) help
Replying "help" will show you this message.
2) announce; message
This will send an email to all users. There should be no simecolon or tab in the message and this rule applies to other parameters in other commands too. For example, you can send "announce; let's go eating".
3) register; name
This command will register name with your email. For example, Alice can register herself by sending "register; Alice" using alice@email@example.com.
4) change_email; new_email
This command will link the name linked to your email to a new email. For example, Bob can change his email by sending "change_email; bob@example.com".
5) cancel
This command will cancel your account so that you will not recieve any message any more, but your remaining money will be kept no matter it is positive or negative.
6) add_value; amount
For example, you can add 123.45 HKD to your account by sending "add_value; 123.45".
7) spend; amount
For example, if we spend 100 HKD in one gathering, the bookkeeper should send "spend; 100". Then all regular attenders that do not quit and all nonregular attenders that attend will pay this amount together.
8) be_a_regular_attender
If you want to be a regular attender, reply "be_a_regular_attender". Note that you are a regular attender by default, if you do not want to be one then use the next command.
9) stop_being_a_regular_attender
If you do not want to be a regular attender, reply "stop_being_a_regular_attender".
10) attend_once
If you are not a regular attender and want to attend the coming gathering, reply "attend_once".
11) quit_once
If you are a regular attender and do not want to attend the coming gathering, reply "quit_once"."""
  if args:
    message += str(args[0]) + "\n"
  sendEmail(email, message)

def announce(records, email, args):
  global emailToName
  if not email in emailToName:
    help(None, email, ["ERROR: [" + email + "] has not registered any account"])
    sys.exit(1)
  message = args[0] + "\n"
  message += "If you are a regular attender and you do not want to attend this time, please reply \"quit_once\".\n"
  message += "If you are not a regular attender and you want to attend this time, please reply \"attend_once\"."
  sendEmail(None, message)

def register(records, email, args):
  global emailOf, emailToName, regular, remaining
  if not args:
    help(None, email, ["ERROR: invalid command"])
    sys.exit(1)
  name = args[0]
  if name in emailOf:
    help(None, email, ["ERROR: [" + name + "] has already been registered"])
    sys.exit(1)
  if email in emailToName:
    help(None, email, ["ERROR: [" + email + "] has already registered another account"])
    sys.exit(1)
  emailToName[email] = name
  emailOf[name] = email
  regular[name] = True
  if not name in remaining:
    remaining[name] = 0
  if records:
    records.write("[" + str(datetime.now()) + ", " + email + "]\t")
    records.write("register\t")
    records.write(name + "\n")
    sendEmail(email, "[" + email + "] has been registered as [" + name + "].")
#    sendEmail(None, "[" + email + "] has been registered as [" + name + "].")

def change_email(records, email, args):
  global emailOf, emailToName
  if not args:
    help(None, email, ["ERROR: invalid command"])
    sys.exit(1)
  if not email in emailToName:
    help(None, email, ["ERROR: [" + email + "] has not registered any account"])
    sys.exit(1)
  name = emailToName[email]
  new_email = args[0]
  if new_email in emailToName:
    help(None, email, ["ERROR: [" + new_email + "] has already registered another account"])
    sys.exit(1)
  emailOf[name] = new_email
  emailToName.pop(email)
  emailToName[new_email] = name
  if records:
    records.write("[" + str(datetime.now()) + ", " + email + "]\t")
    records.write("change_email\t")
    records.write(new_email + "\n")
    sendEmail(email, "Your email has been changed to [" + new_email + "].")
#    sendEmail(None, "Email of [" + name + "] has been changed to [" + new_email + "].")

def cancel(records, email, args):
  global emailOf, emailToName, remaining
  if not email in emailToName:
    help(None, email, ["ERROR: [" + email + "] has not registered any account"])
    sys.exit(1)
  name = emailToName[email]
  emailToName.pop(email)
  emailOf.pop(name)
  if records:
    records.write("[" + str(datetime.now()) + ", " + email + "]\t")
    records.write("cancel\n")
    sendEmail(email, "You have canceled your account with [" + ("%.2f" % remaining[name]) + "] HKD remaining.")
#    sendEmail(None, "[" + name + "] has canceled his/her account with [" + ("%.2f" % remaining[name]) + "] HKD remaining.")

def add_value(records, email, args):
  global emailToName, remaining
  if not args:
    help(None, email, ["ERROR: invalid command"])
    sys.exit(1)
  if not email in emailToName:
    help(None, email, ["ERROR: [" + email + "] has not registered any account"])
    sys.exit(1)
  name = emailToName[email]
  try:
    amount = float(args[0])
    remaining[name] += amount
    if records:
      records.write("[" + str(datetime.now()) + ", " + email + "]\t")
      records.write("add_value\t")
      records.write(("%.2f" % amount) + "\n")
#      sendEmail(email, "You have added value [" + ("%.2f" % amount) + "] with [" + ("%.2f" % remaining[name]) + "] HKD remaining.")
      sendEmail(None, "[" + name + "] has added value [" + ("%.2f" % amount) + "] with [" + ("%.2f" % remaining[name]) + "] HKD remaining.")
  except ValueError:
    help(None, email, ["ERROR: some parameters are wrong"])

def spend(records, email, args):
  global emailToName, emailOf, regular, remaining, once 
  if not args:
    help(None, email, ["ERROR: invalid command"])
    sys.exit(1)
  if not email in emailToName:
    help(None, email, ["ERROR: [" + email + "] has not registered any account"])
    sys.exit(1)
  name = emailToName[email]
  try:
    amount = float(args[0])
    attenders = getAttenders()
    for attender in attenders:
      remaining[attender] -= amount / len(attenders)
    once = dict()
    if records:
      records.write("[" + str(datetime.now()) + ", " + email + "]\t")
      records.write("spend\t")
      records.write(("%.2f" % amount) + "\n")
      sendEmail(None, "[" + ", ".join(attenders) + "] have spent [" + ("%.2f" % amount) + "] HKD.")
      for attender in attenders:
        if remaining[attender] < 10:
          sendEmail(emailOf[attender], "You have [" + ("%.2f" % remaining[attender]) + "] HDK left. Please add value in time.")
  except ValueError:
    help(None, email, ["ERROR: some parameters are wrong"])

def be_a_regular_attender(records, email, args):
  global emailToName, regular
  if not email in emailToName:
    help(None, email, ["ERROR: [" + email + "] has not registered any account"])
    sys.exit(1)
  name = emailToName[email]
  regular[name] = True
  if records:
    records.write("[" + str(datetime.now()) + ", " + email + "]\t")
    records.write("be_a_regular_attender\n")
    sendEmail(email, "You have been a regular attender.")
#    sendEmail(None, "[" + name + "] has been a regular attender.")

def stop_being_a_regular_attender(records, email, args):
  global emailToName, regular
  if not email in emailToName:
    help(None, email, ["ERROR: [" + email + "] has not registered any account"])
    sys.exit(1)
  name = emailToName[email]
  regular[name] = False
  if records:
    records.write("[" + str(datetime.now()) + ", " + email + "]\t")
    records.write("stop_being_a_regular_attender\n")
    sendEmail(email, "You have stopped being a regular attender.")
#    sendEmail(None, "[" + name + "] has stopped being a regular attender.")

def attend_once(records, email, args):
  global emailToName, once
  if not email in emailToName:
    help(None, email, ["ERROR: [" + email + "] has not registered any account"])
    sys.exit(1)
  name = emailToName[email]
  once[name] = True
  if records:
    records.write("[" + str(datetime.now()) + ", " + email + "]\t")
    records.write("attend_once\n")
    sendEmail(email, "You will attend the next gathering.")
#    sendEmail(None, "[" + name + "] will attend the next gathering.")

def quit_once(records, email, args):
  global emailToName, once
  if not email in emailToName:
    help(None, email, ["ERROR: [" + email + "] has not registered any account"])
    sys.exit(1)
  name = emailToName[email]
  once[name] = False
  if records:
    records.write("[" + str(datetime.now()) + ", " + email + "]\t")
    records.write("quit_once\n")
    sendEmail(email, "You will not attend the next gathering.")
#    sendEmail(None, "[" + name + "] will not attend the next gathering.")
  
def runCmd(records, email, cmd):
  cmds = {
    "register" : register,
    "change_email" : change_email,
    "cancel" : cancel,
    "add_value" : add_value,
    "announce" : announce,
    "spend" : spend,
    "be_a_regular_attender" : be_a_regular_attender,
    "stop_being_a_regular_attender" : stop_being_a_regular_attender,
    "attend_once" : attend_once,
    "quit_once" : quit_once,
  }
  for c in cmd:
    if c.find("\t") != -1:
      help(None, email, ["ERROR: some parameters are wrong"])
      sys.exit(1)
  cmds.get(cmd[0], help)(records, email, cmd[1:])

if not os.path.exists(os.path.dirname(__file__) + "/records.txt"):
  open(os.path.dirname(__file__) + "/records.txt", "a").close() 

with open(os.path.dirname(__file__) + "/records.txt", "r") as records:
  while True:
    cmd = records.readline()
    if not cmd:
      break
    cmd = cmd.strip().split("\t")
    runCmd(None, cmd[0][1:-1].split(", ")[1], cmd[1:])
  with open(os.path.dirname(__file__) + "/records.txt", "a") as records:
    if sys.argv[1] == "-n":
      runCmd(records, emailOf[sys.argv[2]], sys.argv[3:])
    else:
      runCmd(records, sys.argv[1], sys.argv[2:])

