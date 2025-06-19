#!/usr/bin/env python3
"""

Python template

main
argparser
logger

regex
subprocess
urlib
getpass

"""

import os
import sys
import pdb
import re
import logging
import inspect
import importlib
import time
import datetime
import threading
import tarfile
import subprocess
import argparse
import re
import getpass
import urllib
import urllib.parse
import xml.etree.ElementTree as ET

log = None

"""
log console print 
"""
class LogPrint():
    def __init__(self):
        global log
        thread = threading.current_thread().name

		# module-name + thread-name
        logger = logging.getLogger(__name__ + thread)
        if len(logger.handlers):
            logger.handlers.clear()

		# set log level
        logger.setLevel(logging.DEBUG)

		# Add console handler
        console = logging.StreamHandler(sys.stdout)
        console.setFormatter(logging.Formatter("    %(message)s"))
        console.setLevel(logging.DEBUG)
        logger.addHandler(console)
        log = logger

class templateInfo():
    def __init__(self, reldir, branch, procbase, proccmp, base_template,top_template):
        self.branch = branch
        self.procbase = procbase
        self.proccmp = proccmp
        self.reldir = reldir
        self.base_template = base_template
        self.top_template = top_template
        self.logdir = None
        self.difftemplates=""
        self.gitdesc=""
        self.gitlog=""
        self.gitdiffs=""
        self.gitfilediffs=""
        self.ubit_user = ""
        self.ubit_passwd = ""

        timenow = datetime.datetime.now().strftime('%Y-%m-%d_%H%M%S')
        logdirname=f'difflogs-{branch}'
        subdirname=f'{timenow}-{procbase}-{proccmp}-log'

        difflogsdir = os.path.join(self.reldir, logdirname)
        os.makedirs(difflogsdir, exist_ok=True)
        self.logdir = os.path.join(self.reldir, logdirname, subdirname)
        os.makedirs(self.logdir, exist_ok=True)

        log.info("CI Change summary and details are at: \n\t %s" %(self.logdir))

        # Download template files 
        if procbase != 0 and proccmp != 0 :
            self.base_template = self.get_templatefile(self.branch, procbase)
            self.top_template = self.get_templatefile(self.branch, proccmp)

      
        self.templatelogfile = open(os.path.join(self.logdir, "procchanges_summary.txt"), "a")
        self.templatelogfile.write("#"*80 + "\n")
        self.templatelogfile.write("difftemplates: %s \n" %(reldir))
        self.templatelogfile.write("    template1: %s\n" %(base_template))
        self.templatelogfile.write("    template2: %s\n" %(top_template))
        self.templatelogfile.write("#"*80 + "\n")

        self.gitlogfile = open(os.path.join(self.logdir, "procchanges_details.txt"), "a")
        self.gitlogfile.write("#"*80 + "\n")
        self.gitlogfile.write("gitdiffs: %s %s %s \n" %(reldir, base_template, top_template))
        self.gitlogfile.write("#"*80 + "\n")

        self.repo_difftemplate()
        self.display_template(self.top_template, self.logdir)

    def get_templatefile(self, branch, build):
        ubit_url = f'https://artifactory.com/template.xml'
        template_file=f'{self.logdir}/{str(build)}-template.xml'
        log.info("Downloading %s %d template file...\n" %(branch, build))
        if not self.ubit_user and not self.ubit_passwd:
            self.ubit_user = input("Username to access ubit-artifactory:")
            self.ubit_passwd = getpass.getpass("Password to access ubit-artifactory:")
        wget_cmd = f'wget --no-proxy --user={self.ubit_user} --password={self.ubit_passwd} {ubit_url} -O {template_file}'

        output_bytes = subprocess.run(wget_cmd.strip(), shell=True, check=True, capture_output=True, cwd=self.reldir)
        if not os.path.isfile(template_file):
            log.error("wget command failed")

        return template_file

    def display_template(self, templateXMLfile, logdir):
        xmlremote = {}
        xmlproj = {}
        templateXML = ""

        # Get template XML
        #with open(self.base_template, 'r') as mf_base:
        #    self.base_templateXML = ET.fromstring(mf_base.read())
        #with open(self.top_template, 'r') as mf_top:
        #    self.top_templateXML = ET.fromstring(mf_top.read())

        with open(templateXMLfile, 'r') as mf_top:
            templateXML = ET.fromstring(mf_top.read())
 
        #for tag in self.top_templateXML.iter("default"): print(tag.items())
        for tag in templateXML.iter("remote"): print(tag.items())
        for md in templateXML.iter("remote"):
            xmlremote.update({md.get('name') : md.get('fetch')})
        print(xmlremote)

        for md in templateXML.iter("project"):
            attrib=dict()
            attrib.update({'giturl': urllib.parse.urljoin(xmlremote[md.get('remote')],md.get('name'))})
            for tag in md.keys():
                attrib.update({tag : md.get(tag)})

            xmllink = []
            xmlcopylist = []
            for subnode in md.iter():
                if (subnode.tag == 'linkfile'):
                    xmldict={}
                    for tag in subnode.keys():
                        xmldict.update({tag : subnode.get(tag)})
                    xmllink.append(xmldict)
                elif (subnode.tag == 'copyfile'):
                    xmldict={}
                    for tag in subnode.keys():
                        xmldict.update({tag : subnode.get(tag)})
                    xmlcopylist.append(xmldict)

            attrib.update({"linkfile" : xmllink})
            attrib.update({"copyfile" : xmlcopylist})
            xmlproj.update({md.get('name') : attrib})
            #print(md.get('name'), attrib)

        # Display xml
        #print(xmlproj)
        template_log = open(os.path.join(logdir, "template_log.txt"), "a")
        template_log.write("\n" + "#"*80 + "\n")
        template_log.write("templates info: %s \n" %(templateXMLfile))
        template_log.write("\n" + "#"*80 + "\n")
 
        for proj in xmlproj.keys(): 
            xmlbuf = "%-40s %-50s %-40s %-30s %-30s %-30s\n" %(proj, 
                            xmlproj[proj]['giturl'], xmlproj[proj]['path'], xmlproj[proj]['linkfile'], 
                            xmlproj[proj]['copyfile'], xmlproj[proj]['groups'])
            template_log.write(xmlbuf)

       # for md in self.top_templateXML.iter("linkfile"): print(md.items())
        

    def repo_difftemplate(self):
        repo_difftemplates_cmd = f'repo difftemplates {self.base_template} {self.top_template}'
        log.info(repo_difftemplates_cmd)
        output_bytes = subprocess.run(repo_difftemplates_cmd.strip(), shell=True, capture_output=True, cwd=self.reldir)
        self.difftemplates = output_bytes.stdout.decode("utf-8").strip()
        self.templatelogfile.write(repo_difftemplates_cmd)
        self.templatelogfile.write(self.difftemplates)

    def get_source_diffs(self):
        log.info(self.difftemplates)
        regx=r'([\w/]+) changed from ([0-9a-fA-F]+) to ([0-9a-fA-F]+)'
        grps=re.findall(regx, self.difftemplates, re.M) 
        if grps is not None:
            # Tuple ("project",  "sha1" "sha2")
            for proj in grps:
                log.info(proj)
                gitpath = os.path.join(self.reldir, ".repo", "projects" , proj[0] + '.git')
                self.get_gitdiffs(proj[0], gitpath, proj[1], proj[2])

        self.templatelogfile.write("\n" + "="*80 + "\nFile Changes:\n" + "="*80 + "\n")
        self.templatelogfile.write(self.gitfilediffs)
        self.gitlogfile.write(self.difftemplates)
        self.gitlogfile.write("\n" + "="*80 +  "\nDescribe:\n" + "="*80 + "\n")
        self.gitlogfile.write(self.gitdesc)
        self.gitlogfile.write("\n" + "="*80 + "\nFile Changes :\n" + "="*80 + "\n")
        self.gitlogfile.write(self.gitfilediffs)
        self.gitlogfile.write("\n" + "="*80 + "\nCommit Logs :\n" + "="*80 + "\n")
        self.gitlogfile.write(self.gitlog)
        self.gitlogfile.write("\n" + "="*80 + "\nCommit Updates:\n" + "="*80 + "\n")
        self.gitlogfile.write(self.gitdiffs)

    def get_gitdiffs(self, proj, gitdir, sha1, sha2):
        repo_gitdesc_cmd = f'git -C {gitdir} describe {sha1} {sha2}'
        repo_gitdiff_cmd = f'git -C {gitdir} diff {sha1}..{sha2}'
        repo_filesdiff_cmd = f'git -C {gitdir} diff --name-status {sha1}..{sha2}'
        repo_gitlog_cmd = f'git -C {gitdir} log --stat --pretty {sha1}..{sha2}'

        output_bytes = subprocess.run(repo_gitdesc_cmd.strip(), shell=True, capture_output=True, cwd=self.reldir)
        gitdesc = output_bytes.stdout.decode("utf-8").strip()
        self.gitdesc = '\n'.join([self.gitdesc,f'\n*** {proj} ***\n', repo_gitdesc_cmd,gitdesc])

        output_bytes = subprocess.run(repo_gitlog_cmd.strip(), shell=True, capture_output=True, cwd=self.reldir)
        gitlog = output_bytes.stdout.decode("utf-8").strip()
        self.gitlog = '\n'.join([self.gitlog,f'\n*** {proj} ***\n',repo_gitlog_cmd,gitlog])

        output_bytes = subprocess.run(repo_gitdiff_cmd.strip(), shell=True, capture_output=True, cwd=self.reldir)
        gitdiffs = output_bytes.stdout.decode("utf-8").strip()
        self.gitdiffs = '\n'.join([self.gitdiffs,f'\n*** {proj} ***\n',repo_gitdiff_cmd,gitdiffs])

        output_bytes = subprocess.run(repo_filesdiff_cmd.strip(), shell=True, capture_output=True, cwd=self.reldir)
        gitfilediffs = output_bytes.stdout.decode("utf-8").strip()
        self.gitfilediffs = '\n'.join([self.gitfilediffs,f'\n*** {proj} ***\n',repo_filesdiff_cmd, gitfilediffs])


def main():
    global log
    LogPrint()

    # Parse input args - template1, template2 and reldir
    parser = argparse.ArgumentParser(
                prog='procinfo.py',
                formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-b', action='store',	
                   dest='branch', default="release", choices=['release', 'master'], help='release')
    parser.add_argument('-c', action='store', 
                   dest='compare', nargs=2, metavar=('procbuild', 'procbuild_compare'), help="compare between two procs")
    parser.add_argument('--template1', action='store',	
                        dest='base_template', default=None, help='Template File')
    parser.add_argument('--template2', action='store',	
                        dest='top_template', default=None , help='Template File to compare')
    parser.add_argument('--reldir', action='store',	required=True,
                        dest='reldir', default=os.getcwd(), help='release repo')
    args = parser.parse_args()

    log.info("CI Build Compare : %s -- %s  (repo %s) templates %s %s"
                %(args.branch, args.compare, args.reldir, args.base_template, args.top_template))

    procbase = 0 ; proccmp = 0
    if args.compare:
        procbase = int(args.compare[0])
        proccmp = int(args.compare[1])

    # Get repo difftemplates
    info = templateInfo(args.reldir,args.branch, procbase, proccmp, args.base_template, args.top_template)
    info.get_source_diffs()

if __name__ == "__main__":
    main()
