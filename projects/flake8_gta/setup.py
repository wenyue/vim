# -*- coding: utf-8 -*-

from __future__ import with_statement
from setuptools import setup

PLUGIN_NAME = 'gta'
setup(
	name="flake8_" + PLUGIN_NAME,
	version="1.0",
	description="flake8 " + PLUGIN_NAME,
	long_description="flake8 " + PLUGIN_NAME,
	keywords='flake8 ' + PLUGIN_NAME,
	py_modules=['plugin'],
	zip_safe=False,
	entry_points={
		'flake8.report': [
			'flake8_%s = plugin:Formatter' % PLUGIN_NAME,
		],
	},
	classifiers=[
		'Development Status :: 3 - Alpha',
		'Environment :: Console',
		'Intended Audience :: Developers',
		'License :: OSI Approved :: MIT License',
		'Operating System :: OS Independent',
		'Programming Language :: Python',
		'Programming Language :: Python :: 2',
		'Programming Language :: Python :: 3',
		'Topic :: Software Development :: Libraries :: Python Modules',
		'Topic :: Software Development :: Quality Assurance',
	],
)
