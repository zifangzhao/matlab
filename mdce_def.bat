REM ===========================================================
REM mdce_def
REM This file contains the definitions and the defaults for the mdce service and
REM the processes it manages.  The file is read only when starting and stopping
REM the mdce service, or when running the mdce service command with the
REM arguments console or, on Windows only, install and uninstall.
REM When workers and job managers are started and stopped, they contact the mdce
REM service they are running under to obtain the values of the definitions and
REM defaults stored in this file.  Thus, this file is not read again when 
REM starting and stopping workers and job managers.
REM It is recommended to use a single mdce_def file for the job manager and all
REM the workers in your cluster, in order to ensure that they are set up in a
REM consistent manner.
REM ===========================================================

REM Copyright 2004-2012 The MathWorks, Inc.


REM ========================
REM MDCE Process and Logging
REM ========================

REM HOSTNAME: The name of the host reading this file.
REM Only change this line if the hostname command is unavailable, if the
REM hostname command returns an incorrect host name, or if it returns a host
REM name that cannot be resolved by all the other computers that the MDCE
REM processes will communicate with.
REM All the MDCE processes will advertise themselves using this host name.
REM The job manager must be able to resolve the host name that the MATLAB
REM workers advertise, and all MATLAB workers and clients must be able to
REM resolve the host name that the job manager advertises.
for /F %%i in ('hostname') do set HOSTNAME=%%i

REM BASE_PORT: The base port of the mdce service.
REM The mdce service will use as many ports as needed, starting with BASE_PORT.
REM On a machine that runs a total of nJ job managers and nW workers, the mdce
REM service reserves a total of 5+nJ+3*nW consecutive ports for its own use.
REM All job managers and workers, even those on different hosts, that are going
REM to work together must use the same base port, otherwise they will not be
REM able to contact each other. In addition MPI communication will occur on ports
REM starting at BASE_PORT+1000 and using up nW consecutive ports.
REM Some operating systems are reluctant to immediately free TCP ports from the
REM TIME_WAIT state for use by the same or other processes, so you should allow
REM unfirewalled communication on 2*nW ports for MPI communications.
set BASE_PORT=27350

REM MDCEUSER: The username that is used when starting the mdce service.
REM If unset, the mdce service is started as LocalSystem.
REM All the processes that the mdce service manages run as the same user as
REM the mdce service itself. This user must have access to the MATLAB
REM installation folder.
REM The username should be specified as DOMAINNAME\USERNAME, or as
REM .\USERNAME if the user is a local user.
set MDCEUSER=

REM MDCEPASS: The password for the user MDCEUSER.
REM In order to run the mdce service as MDCEUSER, you need to specify a password
REM for that user. This can either be done in the variable below or, if left
REM blank, you will be prompted for a password when the service is installed.
REM Be aware that, if you specify the password in this file and it uses characters that
REM are treated as special characters in a batch file, they will need to be entered below
REM using appropriate escape sequences:
REM A single ! in the password should appear below as ^^!
REM A single % in the password should appear below as %%
REM A single ^ in the password should appear below as ^^^^
REM Other special characters & < > [ ] { } = ; ' + , ` ~ should be escaped with a single preceeding ^
set MDCEPASS=

REM LOGBASE: The full path to a folder in which all logfiles should be written.  
REM The user the mdce service runs as must have write access to this folder.
REM %TEMP% here is the system temp environment variable.
REM The folder name should not be enclosed in double quotes, and the
REM name must not contain parentheses.
set LOGBASE=%TEMP%\MDCE\Log

REM CHECKPOINTBASE: The full path to a folder in which all checkpoint 
REM folders should be written. 
REM The user the mdce service is run as must have write access to this
REM folder.  On the host that runs the job manager, the job manager database
REM is written to this folder, and it might require substantial diskspace.
REM On the hosts that run the workers, all the data files that are transferred
REM with the tasks are written to this folder.
REM %TEMP% here is the system temp environment variable.
REM The folder name should not be enclosed in double quotes, and the
REM name must not contain parentheses.
set CHECKPOINTBASE=%TEMP%\MDCE\Checkpoint


REM ====================
REM Job Manager Security
REM ====================

REM SECURITY_LEVEL: Choose the level of security in the cluster.
REM The following levels are available:
REM Level 0: no security. (Similar to R2009b and earlier releases.) This is the
REM          default value.
REM Level 1: users are warned when they try to access other users' jobs and
REM     tasks, but can still perform all actions.
REM Level 2: users need to enter a password to access their jobs and
REM     tasks. Other users do not have any access unless specified by the job
REM     owners (job property AuthorizedUsers).
REM Level 3: same as level 2, but in addition, the jobs and tasks are run on the
REM     workers as the user to which they belong.  The password needs to be the
REM     system password used to log on to a worker machine ("cluster password"). 
REM     NOTE: This level requires settting USE_SECURE_COMMUNICATION to true.
set SECURITY_LEVEL=0

REM USE_SECURE_COMMUNICATION: Use secure communication between services.
REM By default, job managers and workers communicate over non-secure channels.
REM In most cases this is the preferred setting, as either there is no need to
REM protect the data or the connection is already protected from unauthorized
REM access (e.g., the cluster network is isolated and has no access to the
REM Internet).
REM Setting this property to true results in encrypted communication between
REM job managers and workers. This also requires a shared secret file on each
REM participating host (see SHARED_SECRET_FILE below), and results in a 
REM performance degradation as all data is encrypted.
REM This must be set to true if SECURITY_LEVEL is set to 3.
set USE_SECURE_COMMUNICATION=false

REM SHARED_SECRET_FILE: The shared secret file used for secure communication.
REM To establish secure connections between job managers and workers, a shared
REM secret file is required on all participating hosts. Each service expects to
REM find a copy of this file here at startup. Use the createSharedSecret.bat
REM script to create a shared secret file.
REM NOTE: secret files contain sensitive data and should be protected against
REM unauthorized access. Anyone gaining access to the secret might be able to
REM eavesdrop on the connections between services.
REM If unset, the shared secret is expected in %CHECKPOINTBASE%\security\secret.
set SHARED_SECRET_FILE=

REM ALLOW_CLIENT_PASSWORD_CACHE: Remember user passwords for future sessions.
REM If set to true this option allows users to let the MATLAB client remember
REM their logons for future client sessions. Users can still choose to not store
REM any information at the password prompt in MATLAB.
set ALLOW_CLIENT_PASSWORD_CACHE=true

REM ALLOWED_USERS: A list of users allowed to log on to the job manager.
REM The following variable defines a list of users that are allowed to access the
REM job manager. Multiple usernames are separated by commas.
REM To allow any user to access the job manager, use the keyword ALL instead of
REM a list of usernames.
set ALLOWED_USERS=ALL

REM WORKER_DOMAIN: The Windows domain used by workers when logging on at 
REM security level 3. To run tasks as the user to which they belong, Windows
REM requires a domain in addition to the user name. If a task belongs to USER,
REM it will be run as %WORKER_DOMAIN%\USER.
REM In most circumstances the default value will be correct and should not be 
REM altered.
REM NOTE: This is required only when running on Windows at security level 3.
set WORKER_DOMAIN=%USERDOMAIN%


REM ===============================
REM Job Manager and Worker Settings
REM ===============================

REM DEFAULT_JOB_MANAGER_NAME: The default name of the job manager.  
REM When a new job manager is started, it needs to be identified by a name on
REM the network, and when a new worker is started, it needs to know the name of
REM the job manager it should register with. This is the default job manager
REM name used in both of these cases.  
REM The default job manager name can be overriden by the -name argument with the
REM startjobmanager command, and by the -jobmanager argument with the
REM startworker command.
set DEFAULT_JOB_MANAGER_NAME=default_jobmanager

REM JOB_MANAGER_HOST: The host on which the job manager lookup process can be
REM found.
REM If specified, the MATLAB worker processes and the job manager process will
REM use unicast to contact the job manager lookup process.  
REM If JOB_MANAGER_HOST is unset, the job manager will use unicast to contact
REM its own lookup process.  You can then also allow the MATLAB workers to
REM unicast to the job manager lookup process by specifying -jobmanagerhost
REM with the startworker command.
REM If you are certain that your network supports multicast, you can force the
REM job manager and the workers to use multicast to locate the job manager
REM lookup process by using the -multicast flag with the startjobmanager and
REM startworker commands.
set JOB_MANAGER_HOST=

REM JOB_MANAGER_MAXIMUM_MEMORY: The maximum heap size of the job manager java
REM process.
set JOB_MANAGER_MAXIMUM_MEMORY=512m

REM DEFAULT_WORKER_NAME: The default name of the worker.
REM The default worker name can be overridden by the -name argument with the
REM startworker command.
REM Note that worker names must be unique on each host.  Therefore, you must
REM use the -name flag with the startworker command if you want to start more
REM than one worker on a single host.
set DEFAULT_WORKER_NAME=%HOSTNAME%_worker

REM WORKER_START_TIMEOUT: The time in seconds worker sessions allow for MATLAB 
REM to start before detecting a stall. This value should be greater than the 
REM time it takes for a MATLAB session to start.
set WORKER_START_TIMEOUT=600

REM USE_MATHWORKS_HOSTED_LICENSE_MANAGER: Use a license that is managed online.
REM Set this to "true" to enable on-demand licensing or to use a license that is
REM managed online.
REM When enabled, users will be required to login to their MathWorks account to
REM connect to the cluster, and their account must be associated with a MATLAB
REM Distributed Computing Server license that is managed online.
set USE_MATHWORKS_HOSTED_LICENSE_MANAGER=false

REM RELEASE_LICENSE_WHEN_IDLE: Licenses will be released when workers are idle.
REM Set this to "true" to release licenses when idle. This might be useful when
REM using on-demand licensing so that the license is in use only when there is 
REM work to do. This may cause jobs to run more slowly, as it takes time to
REM re-acquire licenses once they have been released.
set RELEASE_LICENSE_WHEN_IDLE=false
