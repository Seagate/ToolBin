#!/usr/bin/env python
"""

================================================================================
SeaChestUtilitiesParallel.35.py - Seagate drive utilities
Copyright (c) 2014-2017 Seagate Technology LLC and/or its Affiliates, All Rights Reserved
v0.3
Date last edit: 02-Oct-2017
================================================================================

Demonstrates how to perform tasks in parallel using Python scripts.

Multi-Threading runs all instances from within the same process.
Multiprocessing can be thought of as a "fork" where multiple instances of the
same process will be created, each running on their own. Which is faster?
That's hard to say. With the threading method, Python must manage the threads
and memory, whereas with multiprocess the OS has to manage these. On some
systems one may be faster than the other. See the Python documentation for more
details.

This script has four demonstration sections:
 1 - Sequential test for total end to end times
 2 - Multi-Thread test
 3 - Multi-Process test
 4 - Parallel-Python test which uses processes and IPC (Inter Porcess 
     Communication), not threads, because of Python GIL (Global Interpreter Lock)
     Parallel Python at http://www.parallelpython.com/
 
First, an important message:

Running SeaChest Utilities using various parallel methods can easily overwhelm
a system.  As the system administrator you are responsible for evaluating how
your systems might react to multiple storage devices running various
diagnostics routines.  Will there be memory issues?  What is the safe number of
parallel tests to run at one time?  Is the power supply ready to support
numerous active drives?  Will there be network issues when the tasks are on
different systems?  What should be the response when a drive fails a diagnostic
test?  Do you have a  way to identify and kill an unresponsive instance of the
tests?  Will there be clean up routines and processes that need be halted when
the tests are finished?  These are only a few of the many obvious questions
that need to be considered before implementing a parallel testing plan.

In Windows, SeaChest Utilities must be Run as administrator.  Python IDLE may
need to be started as administrator.

In Linux, SeaChest Utilities will probably need sudo to run.

TO DO:
        1) first two multi-threaded individual times are coming out the same,
        Multi-Thread individual times are OK in IDLE however.  need to investigate.
        Might have something to do with SDTOUT. Not a problem in Linux.
        2) not sure why but in IDLE for some reason -v0 is necessary to get
        individual Multi-Process test times
        3) add a --testUnitReady filter before command execution?  Some devs report
        NOT READY and still run generic reads.  The filter could weed out not ready
        and also set the fast-to-slow start order
        4) trap error when SeaChest tool name is mispelled

Tested on Python v3.5.2 Linux and v3.6.2 Win7SP1 Win10
    
END USER LICENSE AGREEMENT
This information is covered by the Seagate End User License Agreement.
See http://www.seagate.com/legal-privacy/end-user-license-agreement/

"""

#================================================================================

import sys, os, shlex, subprocess, re, time, itertools

basics = "SeaChest_Basics"

#tool =  "SeaChest_GenericTests"
#command_line = '--userGenericStart 10000 --seconds 5 --hideLBA'
#command_line = '--twoMinuteGeneric --hideLBA'
#command_line = '--randomTest --seconds 2 --hideLBA --onlySeagate'

#tool =  "SeaChest_SMART"
#command_line = '--shortDST --poll'
#command_line = '--smartCheck'

tool = ""
command_line = ""
#linpath = "./"
linpath = "" # use this when the tool is found in the environment path
winpath = "C:\\Program Files\\Seagate\\SeaChest\\"
#winpath = "E:\\commandline_tools\\Windows\Win64\\"
scanutil = ""
utility  = ""
thread_results = []

#================================================================================

def is_linux():
    if os.name is 'posix':
        global scanutil
        global utility
        scanutil = linpath + basics
        utility = linpath + tool
        return True; 
    else:
        return False;

def is_windows():
    if os.name is 'nt':
        global scanutil
        global utility  
        scanutil = winpath + basics
        utility = (winpath + tool) if utility != (winpath + tool) else utility
        return True;
    else:
        return False;

#================================================================================

#the def previous_and_next below thanks to nosklo https://stackoverflow.com/questions/1011938/python-previous-and-next-values-inside-a-loop
from itertools import tee, islice, chain 
def previous_and_next(some_iterable):
    prevs, items, nexts = tee(some_iterable, 3)
    prevs = chain([None], prevs)
    nexts = chain(islice(nexts, 1, None), [None])
    return zip(prevs, items, nexts)

def get_device_list(devArg):
    devs = []
    devices = []
    #print (devArg)
    if is_windows() and "all" in devArg:   # Looking for all READY devs
        print("\nScanning Windows for storage devices...")
        command_line = ' -d all --abortDST --testUnitReady | findstr "PHYSICALDRIVE READY"'
        cmd = [scanutil] + shlex.split(command_line)
        #print (cmd)
        devsdata = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE).stdout.read().split()
        #print (str(devsdata))
        devsdata = devsdata[0:]
        for dev in devsdata:
            if b"PHYSICALDRIVE" in dev or b"NOT" in dev or b"READY" in dev:
                #print (dev)
                devs.append(dev)
        devs = devs[0:]
        for previous, dev, nxt in previous_and_next(devs):
            #print (previous, dev, nxt)
            if b"PHYSICALDRIVE" in dev and b"READY" in nxt:
                #print ("found: ", dev, nxt)
                dev = str(dev).replace('b', '')
                dev = str(dev).replace("'", '')
                dev = str(dev).replace('\\', '')
                dev = str(dev).replace('.PHYSICALDRIVE', 'PD')
                #print (dev)
                devices.append(dev)
    elif is_linux() and "all" in devArg:
        print("\nScanning Linux for storage devices...")
        command_line = " -d all --abortDST --testUnitReady | grep 'sg\|READY' | awk '{print $1}'"
        cmd = scanutil + command_line
        #print (cmd)
        devs = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE).stdout.read().split()
        #print (str(devs))
        devs = devs[0:]
        for previous, dev, nxt in previous_and_next(devs):
            #print (previous, dev, nxt)
            if b"sg" in dev and b"READY" in nxt:
                #print ("found: ", dev, nxt)
                dev = str(dev).replace('b', '')
                dev = str(dev).replace("'", '')
                dev = str(dev).replace('sg', '/dev/sg')
                #print (dev)
                devices.append(dev)
    if "," in devArg:   # Looking for comma delimited devs
        #print (devArg)
        devs = re.findall(r'\d+', devArg)
        #print (devs)
        devs = devs[0:]
        for dev in devs:
            if is_windows():
                dev = re.sub(r'(\d)', r'PD\1', dev)
            elif is_linux():
                dev = re.sub(r'(\d)', r'/dev/sg\1', dev)
            #print (dev)
            devices.append(dev)
    if ".." in devArg:   # Looking for a range of devs
        #print (devArg)
        start_end = re.findall(r'\d+', devArg)
        #print (start_end)
        devs = list(range(int(start_end[0]), int(start_end[1])+1))
        #print (devs)
        devs = devs[0:]
        for dev in devs:
            if is_windows():
                dev = "PD" + str(dev)
            elif is_linux():
                dev = "/dev/sg" + str(dev)
            #print (dev)
            devices.append(dev)
    return devices

#================================================================================

def issue_device_cmd(util_name, cmd_line, device):  # subprocess.Popen with line by line stdout review
    from subprocess import Popen
    return_code = ''    
    err_msg = ""
    cmd = [util_name, '-d', device] + shlex.split(cmd_line)
    #print (cmd)
    start_time_x = time.time()
    #opens new command windows for each instance let's you see stuff BUT shell True is a security flaw
    #p = subprocess.Popen(cmd, shell=True)
    #does not open a new command window for each instance
    #your program might print to stderr or directly to the terminal instead. To merge stdout&stderr, pass stderr=subprocess.STDOUT
    #p = subprocess.Popen(cmd, shell=False, bufsize=1, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    with subprocess.Popen(cmd, shell=False, bufsize=1, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True) as p:
        for line in p.stdout:  # get specific details about particular errors
            line = line.rstrip() # clean off the \n
            #print (line)  #  let's you see stuff
            if ("unknown option" in line) or ("unrecognized option" in line):  # return_code == 1
            #if "unknown option"  in line:  # return_code == 1
                #print line.partition("unknown option")[2] + line.partition("unrecognized option")[2].replace("'", '')
                #err_msg = "unknown option" + line.partition("unknown option")[2]
                err_msg = "Unknown option" + line.partition("unknown option")[2] + line.partition("unrecognized option")[2].replace("'", '')
                print (err_msg)
                break
            if "Error: Could"  in line:  # return_code == 2
                err_msg = "Error: Could" + line.partition("Error: Could")[2]
                break
            sys.stdout.flush()
        sys.stdout.flush()
    #p.wait() # wait for the subprocess to exit
    return_code = p.wait() # wait for the subprocess to exit
    #return_code = p.returncode
    #print (return_code)
    stop_time_x = time.time()
    time_x = stop_time_x - start_time_x
    if return_code == 3:
        err_msg = "Operation Failure"
    elif return_code == 4:
        err_msg = "Operation not supported"
    elif return_code == 5:
        err_msg = "Operation Aborted"
    elif return_code == 6:
        err_msg = "File Path Not Found"
    elif return_code == 7:
        err_msg = "Cannot Open File"
    elif return_code == 8:
        err_msg = "File Already Exists"
    else:
        if return_code not in [0,1,2]:
            #err_msg = "Unknown error"
            print ('', end='')            
            #p.kill()
    #print return_code
    #print err_msg
    return return_code, err_msg, time_x
u'''
pyth 3 version for above
    with subprocess.Popen(cmd, shell=False, bufsize=1, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True) as p:
        for line in p.stdout:  # get specific details about particular errors
            line = line.rstrip() # clean off the \n
            #print (line)  #  let's you see stuff


pyth 2 version for above

    with p.stdout:
        for line in iter(p.stdout.readline, b''):  # get specific details about particular errors
            line = line.rstrip() # clean off the \n
            #print line  #  let's you see stuff

'''


#================================================================================

def sequential_pull(devices):
    manager = multiprocessing.Manager(); placeHolder = manager.dict()
    start_time = time.time()
    for device in devices:
        print("*", device, end=' ')
        sys.stdout.flush()
        rtnCode = ''
        #rtnCode = issue_device_cmd(utility, command_line, device)
        rtnCode = issue_device_cmd2(utility, command_line, placeHolder, device)
        #print rtnCode, rtnCode[:-1], rtnCode[-1]
        time_x = rtnCode[-1]
        print('[Return code:', str(rtnCode[:-1]), ']', end=' ')
        print(str(round(time_x, 3)), " seconds")
        if "Unknown option" in str(rtnCode):
            print ("Aborting test!")
            print ()
            sys.exit(1)
    stop_time = time.time()
    total_time = stop_time - start_time
    print("Sequential tasks took: ", str(round(total_time, 3)), " seconds")

#================================================================================

import threading

class dev_thread(threading.Thread):
    def __init__(self, name):
        threading.Thread.__init__(self)
        self.name = name
        self.run_time = 0

    def run(self):
        global thread_results
        rtnCode = ''
        self.run_time = ''
        start_time = time.time()
        rtnCode = issue_device_cmd(utility, command_line, self.name)
        stop_time = time.time()
        #self.run_time = stop_time - start_time
        self.run_time = rtnCode[-1]
        thread_results.append([self.name, rtnCode[:-1], self.run_time])
        #thread_results.append([self.name, rtnCode[:-1], rtnCode[-1]])
        #print (thread_results)

def threaded_pull(devices):
    threads = []
    start_time = time.time()
    for device in devices:
        thread = dev_thread(device)
        thread.start()
        threads.append(thread)
        print("*", end=' ')
    print(" ")
    print("Returning multi-threaded tasks:", end=" ")
    main_thread = threading.current_thread()
    for thread in threads:
        if thread is main_thread: # avoid a deadlock situation  # <<-- new
            continue
        thread.join()
        print(".", end=' ')
    print(" ")
    end_time = time.time()
    total_time = end_time - start_time
    #print(len(thread_results))
    #print (thread_results)
    for i in range(0, len(thread_results)):
        print (' ', thread_results[i][0], '[Return code:', thread_results[i][1], ']', round(thread_results[i][2], 3), 'seconds')
        if "Unknown option" in str(thread_results[i][1]):
            print ("Aborting test!")
            print ()
            sys.exit(1)
    print("Multi-threads tasks took: ", str(round(total_time, 3)), " seconds")

    # check https://stackoverflow.com/questions/7194884/assigning-return-value-of-function-to-a-variable-with-multiprocessing-and-a-pr
    # check for python 2 see https://stackoverflow.com/questions/8463008/python-multiprocessing-pipe-vs-queue

#================================================================================

def issue_device_cmd2(util_name, cmd_line, return_dict, device):  # subprocess.Popen with line by line stdout review
    return_code = ''
    err_msg = ''
    cmd = [util_name, '-d', device] + shlex.split(cmd_line)
    #print (cmd)
    start_time_x = time.time()
    #opens new command windows for each instance let's you see stuff BUT shell True is a security flaw
    #p = subprocess.Popen(cmd, shell=True)
    #does not open a new command window for each instance
    #your program might print to stderr or directly to the terminal instead. To merge stdout&stderr, pass stderr=subprocess.STDOUT
    #p = subprocess.Popen(cmd, shell=False, bufsize=1, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    with subprocess.Popen(cmd, shell=False, bufsize=1, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True) as p:
        for line in p.stdout:  # get specific details about particular errors
            line = line.rstrip() # clean off the \n
            #print (line)  #  let's you see stuff
            if ("unknown option" in line) or ("unrecognized option" in line):  # return_code == 1
            #if "unknown option"  in line:  # return_code == 1
                #err_msg = "unknown option" + line.partition("unknown option")[2]
                err_msg = "Unknown option" + line.partition("unknown option")[2] + line.partition("unrecognized option")[2].replace("'", '')
                #print (err_msg)
                break
            if "Error: Could"  in line:  # return_code == 2
                err_msg = "Error: Could" + line.partition("Error: Could")[2]
                break
            sys.stdout.flush()
    return_code = p.wait() # wait for the subprocess to exit
    #return_code = p.returncode
    #print (return_code)
    stop_time_x = time.time()
    time_x = stop_time_x - start_time_x
    if return_code == 3:
        err_msg = "Operation Failure"
    elif return_code == 4:
        err_msg = "Operation not supported"
    elif return_code == 5:
        err_msg = "Operation Aborted"
    elif return_code == 6:
        err_msg = "File Path Not Found"
    elif return_code == 7:
        err_msg = "Cannot Open File"
    elif return_code == 8:
        err_msg = "File Already Exists"
    else:
        if return_code not in [0,1,2]:
            #err_msg = "Unknown error"
            print ('', end='')            
            #p.send_kill()
    #print return_code
    #print err_msg
    return_dict[device] = ((return_code, err_msg), time_x)
    return return_code, err_msg, time_x

u'''
pyth 3 version for above
    with subprocess.Popen(cmd, shell=False, bufsize=1, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True) as p:
        for line in p.stdout:  # get specific details about particular errors
            line = line.rstrip() # clean off the \n
            #print (line)  #  let's you see stuff


pyth 2 version for above

    with p.stdout:
        for line in iter(p.stdout.readline, b''):  # get specific details about particular errors
            line = line.rstrip() # clean off the \n
            #print line  #  let's you see stuff

'''

#================================================================================

import multiprocessing

def multiprocess_pull(devices):
    manager = multiprocessing.Manager()
    return_dict = manager.dict()
    processes = []
    if is_windows():
        multiprocessing.freeze_support()
    for device in devices:
        rtnCode = ''
        p = multiprocessing.Process(target=issue_device_cmd2, args=(utility, command_line, return_dict, device))
        processes.append(p)
    start_time = time.time()
    for p in processes:
        p.start()
        print("*", end=' ')
    print(" ")
    print("Returning multi-process tasks:", end=" ")
    for p in processes:
        p.join()
        print(".", end=' ')
    print(" ")
    stop_time = time.time()
    #print (return_dict.values())
    #print (return_dict)
    for k, v in return_dict.items():
        print (' ', k,  '[Return code:', v[0], ']', round(v[1], 3), 'seconds')
        if "Unknown option" in str(v[0]):
        	   print ()
        	   sys.exit(1)
    print("Multi-processes tasks took: ", str(round(stop_time - start_time, 3)), " seconds\n") 

#================================================================================

import pp  # Parallel Python at http://www.parallelpython.com/
           # fork of Parallel Python https://github.com/uqfoundation/ppft imports as pp

    #https://stackoverflow.com/questions/9313841/parallel-python-how-to-use-output-data

def pp_pull(devices):
    ppservers = ()
    job_server = pp.Server(ppservers=ppservers)  #  autodetect number of cpu's "workers"
    #job_server = pp.Server(ncpus=1, ppservers=ppservers)  #  manually set number of cpu's "workers", setting of 1 makes it be sequential
    start_time = time.time()
    for dev in devices:
        print ("*", end=' ')
    print (" (with", job_server.get_ncpus(), "workers)")
    print ("Returning Parallel-Python tasks:", end=' ')
    jobsList = []
    jobs = [(dev, job_server.submit(issue_device_cmd, args=(utility, command_line, dev, ), depfuncs=(),  modules=("sys", "shlex", "subprocess", "time", "itertools", ))) for dev in devices]
    for dev, job in jobs:
        r = (dev, job())
        jobsList.append(r)
        #print ("dev", dev, "got", r)
    #for job in jobsList: print job
    for job in jobsList:
        print (".", end=' ')
    print ("")
    for i in range(0, len(jobsList)):
        results = str(jobsList[i][1]).split(",")
        results1 = shlex.split(str(jobsList[i][1]))
        '''
        #print ("results:", results)
        #print ("results1:", results1)
        testTimeS = "".join(re.findall('\d+\.\d+', results1[2]))
        print (testTimeS)
        testTimeF = float(testTimeS)
        print (testTimeF)
        testTimeV = round(testTimeF, 3)
        print (testTimeV)
        '''
        testTimeV = round(float("".join(re.findall('\d+\.\d+', results1[2]))), 3)
        print (" ", jobsList[i][0], "[Return code:", results1[0], results[1].strip()+ ")", "]", testTimeV, " seconds")
        if "Unknown option" in results[1]:
            print ("Aborting test!")
            print ("")
            sys.exit(1)
    print ("Parallel-Python tasks took: ", round(time.time() - start_time, 3), "seconds")
    print ("")
    print ("Parallel-Python",)
    job_server.print_stats()

    #looks like:
    #* PD2 [Return code: (2, 'Error: Could not open handle to \\\\.\\PhysicalDrive2') ] 0.031  seconds
    
    #Error: “The process 'xxx' not found” occurs after executing parallel python code
    #https://stackoverflow.com/questions/38908321/error-the-process-xxx-not-found-occurs-after-executing-parallel-python-code
    #ERROR: The Process #### not found
    #http://www.parallelpython.com/component/option,com_smf/Itemid,1/topic,790.msg2042
 
#================================================================================

# http://chriskiehl.com/article/parallelism-in-one-line/

def map_pull(devices):
    from multiprocessing import Pool
    from multiprocessing.dummy import Pool as ThreadPool
    from functools import partial
    manager = multiprocessing.Manager()
    return_dict = manager.dict()
    myFunc = partial(issue_device_cmd2, utility, command_line, return_dict)
    start_time = time.time()
    for dev in devices:
        print ("*", end=' ')
    print ("")
    pool = ThreadPool(2) # Sets the pool size to 2 workers, left empty will default to the number of cores
    rtnCode = pool.map(myFunc, devices)
    pool.close()
    pool.join()
    print ("Returning Map Threaded tasks:", end=' ')
    for k in return_dict.items():
        print (".", end=' ')
    print ("")
    #print rtnCode
    #print (return_dict.values())
    #print (return_dict)
    for k, v in return_dict.items():  # as in key value pairs
        print (' ', k,  '[Return code:', v[0], ']', round(v[1], 3), 'seconds')        
        if "Unknown option" in str(v[0]):
            print ("Aborting test!")
            print ("")
            sys.exit(1)
    stop_time = time.time()
    total_time = stop_time - start_time
    print ("Map Threaded tasks took: ", (round(total_time, 3)), u"seconds")
                                         
    # or supposedly instead of the above four pool lines, these two: with ThreadPoolExecutor(max_workers=2) as executor:
    #   executor.map(issue_device_cmd2, params)

#================================================================================
#================================================================================

if __name__ == '__main__':

    #print (globals())
    #Main Function so to speak
    if is_windows():
        print ("\n\tFork the Task(s) - Demonstrates ways to perform tasks in parallel")
    elif is_linux():
        print("\033[1;37m\n\tFork the Task(s) - Demonstrates ways to perform tasks in parallel\033[0m")
    #if "idlelib" in sys.modules: is a test when working in Windows IDLE, not effective in Linux
    if "idlelib" in sys.modules:
        # NOTE: not sure why but in IDLE for some reason -v0 is necessary to get individual Multi-Process test times
        #sys.argv = [sys.argv[0], 'SeaChest_GenericTests', '1,2', '--randomTest', '--seconds', '5', '--hideLBA', '-v0']
        #sys.argv = [sys.argv[0], 'SeaChest_GenericTests', 'all', '--randomTest', '--seconds', '5', '--hideLBA', '--onlySeagate', '-v0']
        sys.argv = [sys.argv[0], 'SeaChest_GenericTests', 'all', '--userGenericStart', '100000', '--userGenericRange', '500000', '--hideLBA', '-v0']
    if len(sys.argv) >= 4:
        inputArgs = sys.argv
        #print (inputArgs[0]) #script file name
        #print (inputArgs[1]) #tool
        #print (inputArgs[2]) #devices_list
        #print (inputArgs[3]) #and beyone are the command_line
        #print (str(inputArgs))
        tool = inputArgs[1]
        devices = get_device_list(inputArgs[2])
        #for opt in range(3, len(inputArgs)):
            #print (inputArgs[opt])
        for opt in inputArgs[3:]:
            #print (opt)
            command_line = command_line + " " + opt
        command_line = str.strip(command_line)
        #print (command_line)
        print ()
    else:
        #print (len(sys.argv))
        #print (str(sys.argv))
        print ("\nThis script uses the following command line syntax:")
        if is_windows():
            print ("  ", sys.argv[0], "SeaChest_<tool name> device_list (see below) Command line options")
        elif is_linux():
            print ("\033[0;31m  ", sys.argv[0], "\033[0;32mSeaChest_<tool name>", "\033[0;34mdevice_list (see below)", "\033[0;35mCommand line options\033[0m")
        print ("\nExample:", sys.argv[0], "SeaChest_Basics 1,2,4 --shortDST --poll")
        print ("\nDevice list examples: 1,2,4  (commas, no spaces) equivalent to", end=' ')
        if is_windows():
            print ("PD1 PD2 PD4")
        elif is_linux():
            print ("sg1 sg2 sg4")
        print ("                      0..3  (periods, no spaces) equivalent to", end=' ')
        if is_windows():
            print ("PD0 PD1 PD2 PD3")
        elif is_linux():
            print ("sg0 sg1 sg2 sg3")
        print ("                      all   all drives in the system")
        print ("\nWhen ranges or all are utilized you can add the following filters with the command line options \nto further restrict the task to certain devices:")
        print ("--onlySeagate, --modelMatch, --onlyFW, --childModelMatch, --childOnlyFW\n")
        print ("Before running this Python script, first run any SeaChest tool with the --scan or -s option to see \na list of storage devices in the system.\n")
        sys.exit(1)
    if len(devices):    
        print("Run on these %s storage devices: " %(len(devices)), end=' ') 
        for dev in devices:
            print((dev), end=' ')
            print(" ", end=' ')
        print()
        print ("Command: ", tool, command_line)

        #1 Comment-out the following if _not_ needed timing for a sequential 
        #print("\nStarting a Sequential task")
        #sequential_pull(devices)
        #sys.exit(1)

        #2 Comment-out the following if _not_ needed timing for a threaded 
        #print("\nStarting a Multi-Threaded task:", end=' ')
        #threaded_pull(devices)

        #3 Comment-out the following if _not_ needed timing for a process 
        print("\nStarting a Multi-Process task:", end=' ')
        multiprocess_pull(devices)

        #4 Comment-out the following if _not_ needed timing for a pp process 
        #print ("\nStarting a Parallel-Python task:", end=' ')
        #pp_pull(devices)

        #5 Comment-out the following if _not_ needed timing for a map process 
        #print u"\nStarting a Mapped task:",
        #map_pull(devices)

    else:
        print("No Devices found.\nRun script without any arguments for short help.\n")
