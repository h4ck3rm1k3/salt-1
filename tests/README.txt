[description]
.
|-- json/
|   |-- basic/			#test json for basic test
|   |-- complex/		#test json for complex test
|   |-- composition/		#test json for composition test
|   |-- module_basic.lst	#config for basic test
|   |-- module_complex.lst	#config for complex test
|   `-- module_composition.lst	#config for composition test
|-- log/	#output for run.sh
|-- run.sh	#run all test case
`-- step.sh	#run single test case


[usage]

#Generate state json from IDE
in brwoser console, run:
    dd.selectedCompState()


#Install Agent and test tool
    curl -sSL -o /tmp/clean.sh  https://s3.amazonaws.com/visualops/clean.sh && bash /tmp/clean.sh reinstall debug

#Test module
    cd /opt/madeira/bootstrap/salt/tests
    ./step.sh #run single testcase
    ./run.sh #run all testcase

##example
to test "linux.user" module, run£º
    ./step.sh 0

##test module with custom api.json (/opt/madeira/env/lib/python2.7/site-packages/opsagent/state/api.json)
    cd /opt/madeira/env/lib/python2.7/site-packages/opsagent/state
    /opt/madeira/env/bin/python adaptor.py

[tips]

to view result only:
./step.sh 2 1 | grep "^(" | grep -n -E "True|False"

