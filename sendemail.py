#!/usr/bin/env python2


import sys
import os
import smtplib
import pwd
import re
import argparse
import ConfigParser
import email.MIMEMultipart
import email.MIMEBase
import email.MIMEText
import email.Utils
import email.Encoders


##### Public methods #####
def readConfig(config_file_path) :
	config_parser = ConfigParser.ConfigParser()
	config_parser.read(config_file_path)
	opt = ( lambda name : config_parser.get("email", name) )
	return (
		opt("from"),
		opt("server"),
		opt("user"),
		opt("passwd"),
	)

def etcPasswdEmails() :
	return [
		item.pw_gecos for item in pwd.getpwall()
		if re.match(r"[^@]+@[^@]+\.[^@]+", item.pw_gecos)
	]

def makeEmail(send_from, send_to_list, subject, text, files_list = None) :
	message = email.MIMEMultipart.MIMEMultipart()
	message["From"] = send_from
	message["To"]   = email.Utils.COMMASPACE.join(send_to_list)
	message["Date"] = email.Utils.formatdate(localtime=True)
	if not subject is None :
		message["Subject"] = subject

	message.attach(email.MIMEText.MIMEText(text))

	if not files_list is None :
		for path in files_list :
			with open(path, "rb") as attach :
				part = email.MIMEBase.MIMEBase("application", "octet-stream")
				part.set_payload(attach.read())
				email.Encoders.encode_base64(part)
				part.add_header("Content-Disposition", "attachment; filename=\"%s\"" % (os.path.basename(path)))
				message.attach(part)
	return message

def sendEmail(server_host, user, passwd, send_from, send_to_list, message) :
	server = smtplib.SMTP_SSL(server_host)
	try :
		server.login(user, passwd)
		server.sendmail(send_from, send_to_list, message.as_string())
	finally :
		server.close()


##### Main #####
if __name__ == "__main__" :
	cli_parser = argparse.ArgumentParser(description="Send stdin as email")
	cli_parser.add_argument("-c", "--config",  dest="config_file_path", action="store", required=True, metavar="<config>")
	cli_parser.add_argument("-s", "--subject", dest="subject",          action="store", metavar="<text>")
	cli_parser.add_argument("-a", "--attach",  dest="files_list",       nargs="+",      metavar="<files>")
	cli_parser.add_argument(      "--split",   dest="split_flag",       action="store_true")
	to_group = cli_parser.add_mutually_exclusive_group(required=True)
	to_group.add_argument("--to",            dest="send_to_list", nargs="+", metavar="<emails>")
	to_group.add_argument("--to-etc-passwd", dest="to_etc_passwd_flag", action="store_true")
	cli_options = cli_parser.parse_args(sys.argv[1:])

	(send_from, server_host, user, passwd) = readConfig(cli_options.config_file_path)
	to_list = ( etcPasswdEmails() if cli_options.to_etc_passwd_flag else cli_options.send_to_list )
	to_list = ( [ [to] for to in to_list ] if cli_options.split_flag else [to_list] )
	text = sys.stdin.read()

	for send_to_list in to_list :
		sendEmail(server_host, user, passwd, send_from, send_to_list, makeEmail(
				send_from,
				send_to_list,
				cli_options.subject,
				text,
				cli_options.files_list,
			))

