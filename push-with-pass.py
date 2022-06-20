
import sys
import pexpect
import time


bitbucket_login = 'https://something@bitbucket.org';
bitbucket_app_pass = "********************"
sleep_time = 5 # 10


try:
    with pexpect .spawn ('git push', echo = True) as pe_spawn: #, \
        # open ('./pexpect.log', 'wb') as log:
        # pe_spawn .logfile = log

        pe_spawn .expect ("Password for : ")
        pe_spawn .sendline (bitbucket_app_pass)
        time .sleep (sleep_time)
        pe_spawn .expect (".+")
        pe_spawn .sendline (bitbucket_app_pass)
        
        # pe_spawn .expect (pexpect.EOF)
        pe_spawn .wait()
except:
    print ('Exception occured during git push with pass')

sys .exit ()
