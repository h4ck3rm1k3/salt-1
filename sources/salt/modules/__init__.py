# -*- coding: utf-8 -*-
'''
Execution Module Directory
'''

def state_std(kwargs, res):
	if kwargs and kwargs.has_key('state_ret'):
		# remove \r from stdout
		stdout_list = res['stdout'].split('\n')
		for idx, item in enumerate(stdout_list):
			stdout_list[idx] = item.split('\r')[-1]

		kwargs['state_ret']['state_stdout'] += '\n'.join(stdout_list) + '\n'
