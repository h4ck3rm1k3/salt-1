# -*- coding: utf-8 -*-
'''
Execution Module Directory
'''

def state_std(kwargs, res):
	if kwargs and kwargs.has_key('state_ret'):
		placeholder_list = ['.']
		repeat_num = 10

		# remove progress bar from stdout
		ori_std_list = res['stdout'].split('\n')
		new_std_list = []
		for item in ori_std_list:
			# remove \r line
			if item.find('\r')>=0:
				new_std_list.append(item.split('\r')[-1])
			else:
				is_progressbar = False
				for holder in placeholder_list:
			 		if item.find(holder*repeat_num)>0:
			 			is_progressbar = True
			 			break

			 	if not is_progressbar:
			 		new_std_list.append(item)

		kwargs['state_ret']['state_stdout'] += '\n'.join(new_std_list) + '\n'
