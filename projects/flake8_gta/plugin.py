# -*- coding: utf-8 -*-

from flake8.formatting.default import Default

IGNORE_WORD = ('gui', 'genv')


class Formatter(Default):
	def handle(self, error):
		if error.code == 'F821' and filter(lambda word: word in error.text, IGNORE_WORD):
			return
		super(Formatter, self).handle(error)

	def after_init(self):
		pass
