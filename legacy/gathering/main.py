#!/usr/bin/python3
import os, sys, time, subprocess, smtplib, imapclient, email, pyzmail, ssl
from datetime import datetime
from email.mime.text import MIMEText
from conf import EMAIL
from conf import USER
from conf import PASSWD
from conf import onError

def check():
  global server
  server.select_folder("INBOX")
  server.idle()
  server.idle_check(timeout=3600)
  server.idle_done()
  messages = server.search(["TO", EMAIL])
  response = server.fetch(messages, ["RFC822"])
  for msg_id, data in response.items():
      msg = email.message_from_bytes(data[b"RFC822"])
      msg = pyzmail.PyzMessage.factory(msg)
      frm = msg.get_address("from")[1]
      content = msg.text_part
      if content:
        charset = content.charset
        if not charset:
          charset = "utf-8"
        lines = content.get_payload().decode(charset, errors="ignore").split("\r\n")
        for line in lines:
          if line:
            cmd = [s.strip() for s in line.split(";")]
            subprocess.call([os.path.dirname(__file__) + "/cmd.py"] + [frm] + cmd)
            break
      server.delete_messages([msg_id])
      server.expunge()

server = None
errorSent = False

while True:
  try:
    check()
  except Exception as e:
    error = e
    iteration = 0
    while error and (iteration < 20):
      iteration = iteration + 1
      try:
        if server == None:
          print("connecting...")
        else:
          print("reconnecting...")
        server = imapclient.IMAPClient("imap.gmail.com", use_uid=True, ssl=True, ssl_context=ssl.create_default_context(cafile="/etc/pki/tls/certs/ca-bundle.crt"))
        server.login(USER, PASSWD)
        check()
        error = None
      except Exception as e:
        print(e)
        error = e
        time.sleep(30)
    if error and not errorSent:
      onError(error)
      errorSent = True

